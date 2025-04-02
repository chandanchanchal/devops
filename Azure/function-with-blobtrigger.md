# Azure Function App Setup

## Create an Azure Function App

1. Go to the [Azure portal](https://portal.azure.com/).
2. In the left sidebar, click on **Create a resource**.
3. Search for **Function App** and create a new one.
4. Fill in the required fields:
   - **Subscription**: Select your subscription.
   - **Resource Group**: Select `rg8a45`.
   - **Function App Name**: Choose a unique name for your Function App.
   - **Runtime Stack**: Choose **Python**.
   - **Region**: Select the region close to you or your services.
5. Click **Review + Create** and then **Create**.

## Create a Blob Storage Container

1. Go to **Storage Accounts** in the Azure portal and select or create a new storage account.
2. In the storage account, create a **Blob Container** (e.g., `images`).
3. Make sure you have the container set to **Blob access level**.

## Create the Azure Function

1. Go to your **Function App**.
2. In the left sidebar under the **Functions** section, click on **+ Add** to create a new function.
3. Select **Python** as the language and choose the **HTTP trigger** template.
4. Give the function a name, e.g., `BlobImageUploader`.
5. Click **Create** to create the function.

## Add Blob Storage Binding to the Function

1. Open your function's editor by clicking on the newly created function.
2. In the editor, click on **Integrate** in the left sidebar.
3. Under **Trigger**, change the **Type** to **Blob Trigger**.
4. In the **Blob path**, specify the path to the container you want to monitor, e.g., `images/{name}`. This means any new file uploaded to the `images` container will trigger the function.
5. Ensure that the **Connection** field is set to use your **Azure Storage account connection string** (the default one from your storage account).

## Write the Function Code

1. Go back to the **Code + Test** section of your function.
2. Replace the default Python code with the following:

```python
import logging
import azure.functions as func

def main(myblob: func.InputStream):
    logging.info(f"Processing blob: Name: {myblob.name}, Size: {myblob.length} bytes")
```

This function logs the name and size of the uploaded blob.
