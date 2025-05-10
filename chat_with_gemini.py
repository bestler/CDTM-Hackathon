#!/usr/bin/env python3
"""
Interactive chat with Gemini AI using the GeminiLLM wrapper.
This script allows you to have a conversation with the AI in the console.
"""

import os
import sys
from dotenv import load_dotenv

# Add the ai_thing directory to the Python path so we can import GeminiLLM
sys.path.append(os.path.join(os.path.dirname(__file__), 'ai_thing'))

# Import the GeminiLLM class
from ai_thing.gemini_llm import GeminiLLM

# Load environment variables
load_dotenv(dotenv_path=".env")

# ANSI color codes for better console output
GREEN = '\033[92m'
BLUE = '\033[94m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def main():
    print(f"{YELLOW}=== Interactive Chat with Gemini AI ==={RESET}")
    print(f"{YELLOW}Type 'exit', 'quit', or press Ctrl+C to end the conversation.{RESET}")
    print(f"{YELLOW}Loading Gemini AI...{RESET}")
    
    try:
        # Initialize the GeminiLLM class
        llm = GeminiLLM()
        print(f"{GREEN}Gemini AI ready! Start chatting...{RESET}")
        
        # Keep a conversation history for context
        conversation = []
        
        # Start the chat loop
        while True:
            # Get user input
            user_input = input(f"{BLUE}You: {RESET}")
            
            # Check if the user wants to exit
            if user_input.lower() in ['exit', 'quit']:
                print(f"{YELLOW}Ending conversation. Goodbye!{RESET}")
                break
            
            # Format the conversation history and current question
            conversation_context = ""
            if conversation:
                for i, (q, a) in enumerate(conversation):
                    conversation_context += f"Q{i+1}: {q}\nA{i+1}: {a}\n\n"
            
            prompt = f"{conversation_context}Q: {user_input}\nA:"
            
            # Send the prompt to the AI
            print(f"{YELLOW}AI thinking...{RESET}")
            try:
                response = llm.complete(prompt)
                print(f"{GREEN}AI: {response}{RESET}")
                
                # Add to conversation history
                conversation.append((user_input, response))
            except Exception as e:
                print(f"{YELLOW}Error: {str(e)}{RESET}")
    
    except KeyboardInterrupt:
        print(f"{YELLOW}\nEnding conversation. Goodbye!{RESET}")
    except Exception as e:
        print(f"{YELLOW}Error initializing Gemini AI: {str(e)}{RESET}")

if __name__ == "__main__":
    main()