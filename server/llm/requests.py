import os
import json
from mistralai import Mistral
# ----------------------------------------------------------
import llm.constants as constants
# ----------------------------------------------------------
def image2struct(
    images,
    model_class,
    prompt: str,
    result_key: str
) -> list:
    if not constants.api_key:
        raise ValueError("API key not found. Set the MISTRAL_API_KEY environment variable.")

    client = Mistral(api_key=constants.api_key)
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
            model=constants.model,
            messages=messages,
            response_format={
                "type": "json_schema",
                "json_schema": {
                    "name": f"{model_class.__name__}Info",
                    "schema": {
                        "type": "object",
                        "properties": {
                            result_key: {
                                "type": "array",
                                "items": model_class.schema()
                            }
                        },
                        "required": [result_key],
                        "additionalProperties": False
                    },
                    "strict": True
                }
            }
        )
    except Exception as e:
        raise ValueError(f"Error processing images with Mistral: {e}")

    result = chat_response.choices[0].message.content
    print(result)
    if isinstance(result, str):
        try:
            result = json.loads(result)
        except json.JSONDecodeError as e:
            print("JSON decode error:", e)
            raise ValueError(f"LLM returned invalid JSON: {e}")

    if isinstance(result, dict) and result_key in result:
        result = result[result_key]
    else:
        raise ValueError(f"LLM returned unexpected format. Expected a dictionary with '{result_key}' key.")

    return [model_class(**item) for item in result]