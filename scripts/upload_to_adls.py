import os
from azure.storage.blob import BlobServiceClient

CONNECTION_STRING = os.getenv("AZURE_STORAGE_CONNECTION_STRING", "YOUR_AZURE_CONNECTION_STRING")
CONTAINER_NAME = "retail-data"

blob_service_client = BlobServiceClient.from_connection_string(CONNECTION_STRING)

upload_map = {
    "data/customers.csv": "raw/customers/2026/01/10/customers.csv",
    "data/products.csv": "raw/products/2026/01/10/products.csv",
    "data/sales.csv": "raw/sales/2026/01/10/sales.csv",
}

for local_file, adls_path in upload_map.items():
    blob_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=adls_path)
    with open(local_file, "rb") as data:
        blob_client.upload_blob(data, overwrite=True)
    print(f"Uploaded: {CONTAINER_NAME}/{adls_path}")
