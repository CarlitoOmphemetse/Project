# Project
This project aims at analyzing the daily stock data of the top S&P500 companies in the world.


# Financial time series analysis of top S&P500 companies using Shiny Web App 

This project aims at analyzing the daily stock data of the top s&amp;p500 companies. There are two major components of the project, which includes: Web Scrapping in python using tickers to iterate through all the list of 500 top companies in the world. Secondly, is the development of the Shiny web application in R where the data analysis and visualization of financial time series will be performed. 

# Overview

# Data 

The data was extracted from the 'Yahoo' through Web scapping in python. The tickers of each company belonging in the S&P500 list were downloaded. Through data exploration, I discovered that there majority of the tickers that were in various companies were missing, therefore the rest of the companies with NaNs were deleted due to this matter. A total of 72 companies each with 428 tickers(different stock prices) is used. The financial time series data extracted is the daily stock closes which starts from 2018-01-02 to 2019-09-13.  

# Data Preparation 

The data was prepared by removing NaNs if there are any, because it might happen that majority of the tickers are missing, therefore they are removed. This will ensure that there is no imbalance in the data and incompleteness.

# Data Analysis and Visualization

Data analysis will be carried out on the shiny web application produced in R. The application consists of simple but imformative visualizations that provide with information about the rise and falls of stock. The application has an upload tab which allows the user to upload the file (NB: Only text files can be uploaded at this stage). Then the remaining tabs contain the summary of the data and the charts. The first chart called Scatterplot takes x variable and y variable as input, (NB: Choose the Date and month as an x variable, the for Y variable you can change between different companies and see as the plot change as y variable chnges). Reactive technique was used to allows the flexibility of the app.

