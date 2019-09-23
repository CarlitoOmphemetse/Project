#!/usr/bin/env python
# coding: utf-8

# # Reading in the Raw sp500 data extracted from the web

# In[ ]:


import pandas as pd
import datetime 
from datetime import datetime


data = pd.read_csv("sp500_joined_closes.csv")
data.head(2)


# # Drop columns with NaNs

# In[ ]:


dataset = data.dropna(axis='columns')


# # Observe the number of columns and rows left

# In[ ]:


dataset.shape


# # Change the Date column to datetime format

# In[15]:


dataset['Date'] = pd.to_datetime(dataset['Date'], infer_datetime_format=True)


# In[17]:


dataset['day'] = (dataset['Date']).dt.day
dataset['month'] = (dataset['Date']).dt.month
dataset['year'] = (dataset['Date']).dt.year
dataset['hour'] = (dataset["Date"]).dt.hour


# # Save the prepared data to be used for the Shiny Web App

# In[19]:


dataset.to_csv("stock_data.csv")

