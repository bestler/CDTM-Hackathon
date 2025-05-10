import os
import base64
from mistralai import Mistral

# Function to encode the image to base64
def encode_image(image_path):
    """Encode the image to base64."""
    try:
        with open(image_path, "rb") as image_file:
            return base64.b64encode(image_file.read()).decode("utf-8")
    except FileNotFoundError:
        print(f"Error: The file {image_path} was not found.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

# Set up Mistral API
api_key = "cr0jsksN6GrXg0spar0vMPENfHVNza6v"  # Replace with your actual API key
client = Mistral(api_key=api_key)

# Path to the local JPEG file
image_path = "resources/impfpass.jpeg"  # Replace with the path to your JPEG file

# Encode the image
base64_image = encode_image(image_path)
if not base64_image:
    exit("Failed to encode the image. Exiting.")

# Process the image with the OCR API
ocr_response = client.ocr.process(
    model="mistral-ocr-latest",  # Replace with the correct OCR model name
    document={
        "type": "image_url",
        "image_url": f"data:image/jpeg;base64,{base64_image}"
    }
)

# Print the OCR response
print(ocr_response)