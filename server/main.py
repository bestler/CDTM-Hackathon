from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.responses import JSONResponse
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
from llm import get_vac_from_images
import base64
import logging
import fitz

app = FastAPI()

data_store = {}

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

@app.post("/post/generalInformation")
async def post_general_information(payload: GeneralInformation):
    logging.info("POST /post/generalInformation called with payload: %s", payload.model_dump())
    data_store["generalInformation"] = payload.model_dump()
    return JSONResponse(content={"message": "generalInformation saved successfully."})

@app.get("/get/generalInformation")
async def get_general_information():
    logging.info("GET /get/generalInformation called")
    if "generalInformation" not in data_store:
        logging.warning("generalInformation not found in data_store")
        raise HTTPException(status_code=404, detail="generalInformation not found")
    return JSONResponse(content=data_store["generalInformation"])

@app.post("/post/appleHealth")
async def post_apple_health(payload: AppleHealth):
    logging.info("POST /post/appleHealth called with payload: %s", payload.model_dump())
    data_store["appleHealth"] = payload.model_dump()
    return JSONResponse(content={"message": "appleHealth data saved successfully."})

@app.get("/get/appleHealth")
async def get_apple_health():
    logging.info("GET /get/appleHealth called")
    if "appleHealth" not in data_store:
        logging.warning("appleHealth data not found in data_store")
        raise HTTPException(status_code=404, detail="appleHealth data not found")
    return JSONResponse(content=data_store["appleHealth"])

@app.post("/post/vaccinations")
async def post_vaccinations(files: list[UploadFile] = File(...)):
    logging.info("POST /post/vaccinations called with %d files", len(files))
    images = []
    for file in files:
        image_bytes = await file.read()

        # Support for PDF files
        if file.content_type == "application/pdf":
            try:
                with fitz.open(stream=image_bytes, filetype="pdf") as doc:
                    for page in doc:
                        pix = page.get_pixmap(dpi=200)
                        img_bytes = pix.tobytes("jpeg")
                        base64_jpg = base64.b64encode(img_bytes).decode("utf-8")
                        images.append({
                            "type": "image_url",
                            "image_url": f"data:image/jpeg;base64,{base64_jpg}"
                        })
            except Exception as e:
                logging.error("Failed to convert PDF to JPG: %s", e)
                raise HTTPException(status_code=400, detail=f"Failed to convert PDF to JPG: {e}")

        # Support for image files
        else:
            base64_image = base64.b64encode(image_bytes).decode("utf-8")
            images.append({
                "type": "image_url",
                "image_url": f"data:{file.content_type};base64,{base64_image}"
            })

    try:
        vaccinations: list[Vaccination] = get_vac_from_images(images)
        logging.info("Vaccination extraction successful, %d records found", len(vaccinations))
    except Exception as e:
        logging.error("LLM extraction failed: %s", e)
        raise HTTPException(status_code=500, detail=f"LLM extraction failed: {e}")
    data_store["vaccinations"] = [v.model_dump() for v in vaccinations]
    return JSONResponse(content={"message": "vaccinations saved successfully.", "vaccinations": data_store["vaccinations"]})

@app.get("/get/vaccinations")
async def get_vaccinations():
    logging.info("GET /get/vaccinations called")
    if "vaccinations" not in data_store:
        logging.warning("vaccinations not found in data_store")
        raise HTTPException(status_code=404, detail="vaccinations not found")
    return JSONResponse(content=data_store["vaccinations"])

@app.post("/post/medicalHistory")
async def post_medical_history(payload: MedicalHistory):
    logging.info("POST /post/medicalHistory called with payload: %s", payload.model_dump())
    data_store["medicalHistory"] = payload.model_dump()
    return JSONResponse(content={"message": "medicalHistory saved successfully."})

@app.get("/get/medicalHistory")
async def get_medical_history():
    logging.info("GET /get/medicalHistory called")
    if "medicalHistory" not in data_store:
        logging.warning("medicalHistory not found in data_store")
        raise HTTPException(status_code=404, detail="medicalHistory not found")
    return JSONResponse(content=data_store["medicalHistory"])

@app.post("/post/reasonsForVisit")
async def post_reasons_for_visit(payload: ReasonsForVisit):
    logging.info("POST /post/reasonsForVisit called with payload: %s", payload.model_dump())
    data_store["reasonsForVisit"] = payload.model_dump()
    return JSONResponse(content={"message": "reasonsForVisit saved successfully."})

@app.get("/get/reasonsForVisit")
async def get_reasons_for_visit():
    logging.info("GET /get/reasonsForVisit called")
    if "reasonsForVisit" not in data_store:
        logging.warning("reasonsForVisit not found in data_store")
        raise HTTPException(status_code=404, detail="reasonsForVisit not found")
    return JSONResponse(content=data_store["reasonsForVisit"])

@app.post("/post/additionalComments")
async def post_additional_comments(payload: AdditionalComments):
    logging.info("POST /post/additionalComments called with payload: %s", payload.model_dump())
    data_store["additionalComments"] = payload.model_dump()
    return JSONResponse(content={"message": "additionalComments saved successfully."})

@app.get("/get/additionalComments")
async def get_additional_comments():
    logging.info("GET /get/additionalComments called")
    if "additionalComments" not in data_store:
        logging.warning("additionalComments not found in data_store")
        raise HTTPException(status_code=404, detail="additionalComments not found")
    return JSONResponse(content=data_store["additionalComments"])