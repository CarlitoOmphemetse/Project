#!/usr/bin/env python
# coding: utf-8

# # You might want to upgrade your pip and install pandas_datareader if not yet installed

# In[ ]:


#!pip install --upgrade pip


# In[1]:



#!pip install pandas_datareader


# # Required Libraries 

# In[10]:


import bs4 as bs
import datetime as dt
import os
import pandas_datareader.data as web
import pickle
import requests
import pandas as pd


# # Function for saving tickers(increase and decrease of stocks)

# In[11]:



def save_sp500_tickers():
    resp = requests.get('http://en.wikipedia.org/wiki/List_of_S%26P_500_companies')
    soup = bs.BeautifulSoup(resp.text, 'lxml')
    table = soup.find('table', {'class': 'wikitable sortable'})
    tickers = []
    for row in table.findAll('tr')[1:]:
        ticker = row.findAll('td')[0].text.replace('.','-')
        ticker = ticker[:-1]
        tickers.append(ticker)
    with open("sp500tickers.pickle", "wb") as f:
        pickle.dump(tickers, f)
    return tickers


# # Function for fetching stock data from yahoo 

# In[ ]:


# save_sp500_tickers()
def get_data_from_yahoo(reload_sp500=False):
    if reload_sp500:
        tickers = save_sp500_tickers()
    else:
        with open("sp500tickers.pickle", "rb") as f:
            tickers = pickle.load(f)
    if not os.path.exists('stock_dfs'):
        os.makedirs('stock_dfs')
    start = dt.datetime(2019, 6, 8)
    end = dt.datetime.now()
    for ticker in tickers:
        print(ticker)
        if not os.path.exists('stock_dfs/{}.csv'.format(ticker)):
            df = web.DataReader(ticker, 'yahoo', start, end)
            df.reset_index(inplace=True)
            df.set_index("Date", inplace=True)
            df.to_csv('stock_dfs/{}.csv'.format(ticker))
        else:
            print('Already have {}'.format(ticker))
save_sp500_tickers()
get_data_from_yahoo()


# # Function for structuring the data into a suitable format in preparation for storage

# In[13]:


def compile_data():
    with open("sp500tickers.pickle","rb") as f:
        tickers = pickle.load(f)
    
    
    main_df = pd.DataFrame()
  
    for count, ticker in enumerate(tickers):
        df = pd.read_csv('stock_dfs/{}.csv'.format(ticker))
        df.set_index('Date', inplace = True)
    
        df.rename(columns = {'Adj Close':ticker}, inplace=True)
        df.drop(['Open','High','Low','Close','Volume'], 1, inplace =True)
    
    if main_df.empty:
        main_df = df
      
    else:
        main_df = main_df.join(df, how = 'outer')
      
      
    if count % 10 == 0:
        print(count)
      
      
    print(main_df.head())
    main_df.to_csv('sp500_joined_closes.csv')


# In[ ]:


compile_data() #It will compile the data into a suitable format for analysis

