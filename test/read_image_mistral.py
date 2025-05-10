import base64
from mistralai import Mistral

def encode_image(image_path):
    """Encode the image to base64."""
    try:
        with open(image_path, "rb") as image_file:
            return base64.b64encode(image_file.read()).decode('utf-8')
    except FileNotFoundError:
        print(f"Error: The file {image_path} was not found.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def process_images_with_mistral(image_paths):
    # Step 1: Encode all images to base64
    base64_images = []
    for image_path in image_paths:
        base64_image = encode_image(image_path)
        if base64_image:
            base64_images.append({
                "type": "image_url",
                "image_url": f"data:image/jpeg;base64,{base64_image}"
            })
        else:
            print(f"Skipping image: {image_path}")

    if not base64_images:
        print("No valid images to process. Exiting.")
        return

    # Step 2: Set up Mistral API
    api_key = "cr0jsksN6GrXg0spar0vMPENfHVNza6v"
    model = "mistral-small-latest"

    if not api_key:
        raise ValueError("API key not found. Set the API key in the script.")

    client = Mistral(api_key=api_key)

    # Step 3: Define the messages
    messages = [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "Extract and return the vaccination details in the specified JSON format. Check every entry in the images."
                },
                *base64_images  # Add all encoded images to the content
            ]
        }
    ]

    # Step 4: Get the chat response using the updated JSON schema
    try:
        chat_response = client.chat.complete(
            model=model,
            messages=messages,
            response_format={
                "type": "json_schema",
                "json_schema": {
                    "name": "VaccinationInfo",
                    "description": "Extracted vaccination details from the documents.",
                    "schema": {
                        "type": "object",
                        "properties": {
                            "Vaccinations": {
                                "type": "array",
                                "items": {
                                    "type": "object",
                                    "properties": {
                                        "name": { "type": "string" },
                                        "doctor": { "type": "string" },
                                        "date": { "type": "string" }
                                    },
                                    "additionalProperties": False
                                }
                            }
                        },
                        "required": ["Vaccinations"],
                        "additionalProperties": False
                    },
                    "strict": True
                }
            }
        )
        print("\nExtracted vaccination details (strict JSON format):")
        print(chat_response.choices[0].message.content)
    except Exception as e:
        print(f"Error processing images with Mistral: {e}")

if __name__ == "__main__":
    # List of image paths to process
    image_paths = [
        "resources/impfpass2.jpeg",  # First image
        "resources/impfpass.jpeg"   # Second image
    ]

    # Process all images in a single request
    process_images_with_mistral(image_paths)