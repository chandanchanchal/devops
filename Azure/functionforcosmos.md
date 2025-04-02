#### **Create a Function App**
1. Open **Azure Portal** and search for **Function App**.
2. Click **Create** and configure the following:
   - **Subscription**: Select your Azure subscription.
   - **Resource Group**: Use the same resource group as Cosmos DB.
   - **Function App Name**: `myfunctionapp`
   - **Runtime Stack**: **Python**
   - **Region**: Same as Cosmos DB.
   - **Storage Account**: Create a new one or use an existing one.
3. Click **Review + Create**, then **Create**.

#### **Deploy Azure Functions**
1. Open your **Function App** in the **Azure Portal**.
2. Click **Functions > Create**.
3. Select **HTTP Trigger** for each function.

---

