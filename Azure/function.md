# Steps Walkthrough: Creating a Function

## Step 1: Set Up an Azure Function App

1. Log in to the Azure Portal.
2. Navigate to **Create a resource** → **Function App**.
3. Configure the function app:
   - **Subscription**: Select your subscription.
   - **Resource Group**: Create or select an existing resource group.
   - **Function App Name**: Choose a unique name.
   - **Runtime Stack**: Select .NET, Python, or Node.js.
   - **Region**: Choose a region close to your users.
   - **Storage Account**: Create a new one or use an existing one.
4. Click **Review + Create**, then **Create**.

## Step 2: Create an HTTP Trigger Function

1. Open the Function App in **Azure Portal**.
2. Click **Functions** → **Add Function**.
3. Choose **HTTP Trigger**.
4. Set the **authorization level** to **Function** or **Anonymous**.
5. Click **Create**.

## Step 3: Test the Function

1. Open the function in **Azure Portal**.
2. Click **Code + Test** → **Test/Run**.
3. Provide input and run the function.
4. Note the output and verify the response.

---

# Assignment: Create Your Own Function

## Task:

- Create an **Azure Function App**.
- Implement a **Timer Trigger** function that logs a message every **5 minutes**.
- Deploy and verify execution in **Azure Monitor**.
