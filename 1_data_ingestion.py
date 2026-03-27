print("Script started...")

# Importing the required libraries
import pandas as pd
from sqlalchemy import create_engine
import os

# MySQL Connection
engine = create_engine('mysql+pymysql://root:rudra123@localhost:3306/olist_db')

# Path to the Data Folder
data_path= r'C:\Users\rudra\OneDrive\Documents\Projects\E-commerce Sales & Customer Insights Analysis\Olist Data'

# Load all CSV files and push to MySQL
csv_files = {
    'customers'         : 'olist_customers_dataset.csv',
    'orders'            : 'olist_orders_dataset.csv',
    'order_items'       : 'olist_order_items_dataset.csv',
    'order_payments'    : 'olist_order_payments_dataset.csv',
    'order_reviews'     : 'olist_order_reviews_dataset.csv',
    'products'          : 'olist_products_dataset.csv',
    'sellers'           : 'olist_sellers_dataset.csv',
    'geolocation'       : 'olist_geolocation_dataset.csv',
    'category_translate': 'product_category_name_translation.csv'
}

for table_name, file_name in csv_files.items():
    file_path = os.path.join(data_path, file_name)
    df = pd.read_csv(file_path)
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    print(f'{table_name} loaded successfully — {len(df)} rows')

print('All tables loaded into MySQL!')