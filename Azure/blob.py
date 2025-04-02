import logging
import azure.functions as func

def main(req: func.HttpRequest, inputblob: func.InputStream) -> func.HttpResponse:
    try:
        # Retrieve the file name from the blob trigger
        file_name = inputblob.name.split('/')[-1]  # Extract the file name
        
        logging.info(f"File uploaded: {file_name}")
        
        # Return the file name as a response (just for confirmation)
        return func.HttpResponse(f"File uploaded: {file_name}", status_code=200)
    
    except Exception as e:
        logging.error(f"Error: {str(e)}")
        return func.HttpResponse("Error processing the file", status_code=500)
