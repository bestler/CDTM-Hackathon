from fastapi import FastAPI, HTTPException
from typing import Dict, Any
from models import (
    Insurance,
    GeneralInformation,
    Activity,
    BodyMeasurements,
    CycleTracking,
    Hearing,
    Electrocardiogram,
    Heart,
    Medication,
    MentalWellbeing,
    Mobility,
    Nutrition,
    Respiratory,
    SleepStages,
    Sleep,
    Symptoms,
    BloodPressure,
    Vitals,
    OtherData,
    AppleHealth,
    Vaccination,
    MedicalHistory,
    ReasonsForVisit,
    AdditionalComments
)

# Initialize FastAPI app
app = FastAPI()

# In-memory storage for posted data
data_store = {}

# Update endpoints to use camelCase keys
@app.post("/post/generalInformation")
async def post_general_information(payload: GeneralInformation):
    data_store["generalInformation"] = payload.model_dump()
    return {"message": "generalInformation saved successfully."}

@app.get("/get/generalInformation")
async def get_general_information():
    if "generalInformation" not in data_store:
        raise HTTPException(status_code=404, detail="generalInformation not found")
    return data_store["generalInformation"]

@app.post("/post/appleHealth")
async def post_apple_health(payload: AppleHealth):
    data_store["appleHealth"] = payload.model_dump()
    return {"message": "appleHealth data saved successfully."}

@app.get("/get/appleHealth")
async def get_apple_health():
    if "appleHealth" not in data_store:
        raise HTTPException(status_code=404, detail="appleHealth data not found")
    return data_store["appleHealth"]

@app.post("/post/vaccinations")
async def post_vaccinations(payload: list[Vaccination]):
    data_store["vaccinations"] = [v.model_dump() for v in payload]
    return {"message": "vaccinations saved successfully."}

@app.get("/get/vaccinations")
async def get_vaccinations():
    if "vaccinations" not in data_store:
        raise HTTPException(status_code=404, detail="vaccinations not found")
    return data_store["vaccinations"]

@app.post("/post/medicalHistory")
async def post_medical_history(payload: MedicalHistory):
    data_store["medicalHistory"] = payload.model_dump()
    return {"message": "medicalHistory saved successfully."}

@app.get("/get/medicalHistory")
async def get_medical_history():
    if "medicalHistory" not in data_store:
        raise HTTPException(status_code=404, detail="medicalHistory not found")
    return data_store["medicalHistory"]

@app.post("/post/reasonsForVisit")
async def post_reasons_for_visit(payload: ReasonsForVisit):
    data_store["reasonsForVisit"] = payload.model_dump()
    return {"message": "reasonsForVisit saved successfully."}

@app.get("/get/reasonsForVisit")
async def get_reasons_for_visit():
    if "reasonsForVisit" not in data_store:
        raise HTTPException(status_code=404, detail="reasonsForVisit not found")
    return data_store["reasonsForVisit"]

@app.post("/post/additionalComments")
async def post_additional_comments(payload: AdditionalComments):
    data_store["additionalComments"] = payload.model_dump()
    return {"message": "additionalComments saved successfully."}

@app.get("/get/additionalComments")
async def get_additional_comments():
    if "additionalComments" not in data_store:
        raise HTTPException(status_code=404, detail="additionalComments not found")
    return data_store["additionalComments"]