from google import genai
from dotenv import load_dotenv
import os
from colorama import Fore, Style

# Load environment variables
load_dotenv(dotenv_path=".env")  # Make sure this is the correct path to your .env file

class GeminiLLM:
    def __init__(self, model=None):
        # Get environment variables
        api_key = os.getenv("GOOGLE_CLOUD_API")
        
        if not api_key:
            raise ValueError("API key (GOOGLE_CLOUD_API) must be set")
        
        # Set default model to the one that works in gemini_api.py
        self.model = model or "gemini-2.0-flash-001"
        
        # Print debug information
        print(f"API Key: {'Set' if api_key else 'Not set'}")
        print(f"Model: {self.model}")
        
        # Initialize the client exactly like in gemini_api.py
        self.client = genai.Client(
            vertexai=False,  # Do not use Vertex AI
            api_key=api_key
        )

    def complete(self, prompt: str) -> str:
        try:
            print(f"{Fore.YELLOW}Debug: Sending prompt to Gemini: {prompt}{Style.RESET_ALL}")
            # Generate content from the Gemini model given a prompt
            response = self.client.models.generate_content(
                model=self.model,
                contents=prompt,
            )
            print(f"{Fore.YELLOW}Debug: Received response from Gemini{Style.RESET_ALL}")
            return response.text
        except Exception as e:
            print(f"{Fore.RED}Error generating content: {str(e)}{Style.RESET_ALL}")
            # Return a fallback response in case of error
            return "I'm having trouble processing that request. Could you try again?"