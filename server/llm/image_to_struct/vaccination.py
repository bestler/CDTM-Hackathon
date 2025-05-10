import os
import json
from mistralai import Mistral
from dotenv import load_dotenv

from models import Vaccination

load_dotenv()

model: str = "mistral-medium-latest"
prompt: str = "Extract and return the vaccination details in the specified JSON format." \
"Check every entry in the images." \
"What out that there can be multiple pages in the images."

def get_vac_from_images(images) -> list[Vaccination]:
    api_key = os.environ.get("MISTRAL_API_KEY")
    if not api_key:
        raise ValueError("API key not found. Set the MISTRAL_API_KEY environment variable.")

    client = Mistral(api_key=api_key)
    messages = [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": prompt
                },
                *images
            ]
        }
    ]

    try:
        chat_response = client.chat.complete(
            model=model,
            messages=messages,
            response_format={
                "type": "json_schema",
                "json_schema": {
                    "name": "VaccinationInfo",
                    "schema": {
                    "type": "object",
                    "properties": {
                        "Vaccinations": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": Vaccination.model_json_schema().get("properties", {}),
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

    except Exception as e:
        raise ValueError(f"Error processing images with Mistral: {e}")

    result = chat_response.choices[0].message.content
    if isinstance(result, str):
        try:
            result = json.loads(result)
        except json.JSONDecodeError as e:
            print("JSON decode error:", e)
            raise ValueError(f"LLM returned invalid JSON: {e}")

    if isinstance(result, dict) and "Vaccinations" in result:
        result = result["Vaccinations"]
    else:
        raise ValueError("LLM returned unexpected format. Expected a dictionary with 'Vaccinations' key.")

    return [Vaccination(**item) for item in result]