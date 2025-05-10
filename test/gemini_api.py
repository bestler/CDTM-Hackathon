from google import genai
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv(dotenv_path=".env")

# Initialize the GenAI client using only the API key
client = genai.Client(
    vertexai=False,  # Do not use Vertex AI
    api_key=os.getenv("GOOGLE_CLOUD_API"),  # Load API key from environment variable
)

# Generate content using the Gemini model
response = client.models.generate_content(
    model="gemini-2.0-flash-001",
    contents="Explain bubble sort to me.",
)

# Print the response
print(response.text)