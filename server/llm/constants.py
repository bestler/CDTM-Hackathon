from dotenv import load_dotenv
import os
# ------------------------------------------------------
load_dotenv()
# ----------------------------------------------------
# MODEL
# ----------------------------------------------------
model: str = "mistral-medium-latest"
api_key = os.environ.get("MISTRAL_API_KEY")
# ----------------------------------------------------
# PROMPTS
# ----------------------------------------------------
vax_prompt: str = "Extract and return the vaccination details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."
# ----------------------------------------------------
blood_panel_prompt: str = "Extract and return the blood panel details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."
# ----------------------------------------------------
clinical_report_prompt: str = "Extract and return the clinical report details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."
# ----------------------------------------------------
doctor_letter_prompt: str = "Extract and return the doctor letter details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."
# ----------------------------------------------------
general_info_prompt: str = "Extract and return the general information details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."
# ----------------------------------------------------
medication_prompt: str = "Extract and return the medication details in the specified JSON format." \
"Check every entry in the images." \
"Please return syntax correct JSON format."

