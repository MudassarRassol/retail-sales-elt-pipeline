import os
import zipfile
import io
import requests
import pandas as pd

os.makedirs("data", exist_ok=True)
url = "https://archive.ics.uci.edu/static/public/352/online+retail.zip"
response = requests.get(url)
response.raise_for_status()

with zipfile.ZipFile(io.BytesIO(response.content)) as z:
    excel_filename = [f for f in z.namelist() if f.endswith(".xlsx")][0]
    with z.open(excel_filename) as f:
        df = pd.read_excel(f)

customers_df = df[["CustomerID", "Country"]].dropna(subset=["CustomerID"]).drop_duplicates(subset=["CustomerID"]).copy()
customers_df["customer_id"] = "C" + customers_df["CustomerID"].astype(int).astype(str)
customers_df["customer_name"] = "Customer_" + customers_df["CustomerID"].astype(int).astype(str)
customers_df = customers_df[["customer_id", "customer_name", "Country"]].rename(columns={"Country": "country"})

products_df = df[["StockCode", "Description", "UnitPrice"]].dropna(subset=["StockCode", "Description"]).drop_duplicates(subset=["StockCode"]).copy()
products_df["product_id"] = products_df["StockCode"].astype(str).str.strip()
products_df["product_name"] = products_df["Description"].astype(str).str.strip()
products_df["category"] = "Retail"
products_df = products_df[["product_id", "product_name", "category", "UnitPrice"]].rename(columns={"UnitPrice": "unit_price"})

sales_df = df.dropna(subset=["InvoiceNo", "CustomerID", "StockCode"]).copy()
sales_df["order_id"] = sales_df["InvoiceNo"].astype(str).str.strip()
sales_df["customer_id"] = "C" + sales_df["CustomerID"].astype(int).astype(str)
sales_df["product_id"] = sales_df["StockCode"].astype(str).str.strip()
sales_df["order_date"] = pd.to_datetime(sales_df["InvoiceDate"]).dt.strftime("%Y-%m-%d")
sales_df = sales_df[["order_id", "customer_id", "product_id", "Quantity", "order_date"]].rename(columns={"Quantity": "quantity"})

customers_df.to_csv("data/customers.csv", index=False)
products_df.to_csv("data/products.csv", index=False)
sales_df.to_csv("data/sales.csv", index=False)
