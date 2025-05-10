from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.responses import JSONResponse
from models import (
    GeneralInformation,
    AppleHealth,
    Vaccination,
    ReasonsForVisit,
    AdditionalComments,
    BloodPanel,
    ClinicalReport,
    DoctorLetter,
)
import logging
# ------------------------------------------------------
import llm
import utils
# ------------------------------------------------------
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
    # ----------------------------------------------------------
    # Convert files to base64
    try:
        images = await utils.files_to_base64(files)
    except RuntimeError as e:
        logging.error("Error converting files to base64: %s", e)
        raise HTTPException(status_code=400, detail=f"Error converting files to base64: {e}")
    # ----------------------------------------------------------
    # Read the images
    try:
        vaccinations: list[Vaccination] = llm.image2struct(images, Vaccination, llm.vax_prompt, "Vaccinations")
        logging.info("Vaccination extraction successful, %d records found", len(vaccinations))
    except Exception as e:
        logging.error("LLM extraction failed: %s", e)
        raise HTTPException(status_code=500, detail=f"LLM extraction failed: {e}")
    # ----------------------------------------------------------
    data_store["vaccinations"] = [v.model_dump() for v in vaccinations]
    return JSONResponse(content={"message": "vaccinations saved successfully.", "data": data_store["vaccinations"]})

@app.get("/get/vaccinations")
async def get_vaccinations():
    logging.info("GET /get/vaccinations called")
    if "vaccinations" not in data_store:
        logging.warning("vaccinations not found in data_store")
        raise HTTPException(status_code=404, detail="vaccinations not found")
    return JSONResponse(content=data_store["vaccinations"])

@app.post("/post/reasonsForVisit")
async def post_reasons_for_visit(payload: ReasonsForVisit):
    logging.info("POST /post/reasonsForVisit called with payload: %s", payload.model_dump())
    data_store["reasonsForVisit"] = payload.model_dump()
    return JSONResponse(content={"message": "reasonsForVisit saved successfully.", "data": data_store["reasonsForVisit"]})

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
    return JSONResponse(content={"message": "additionalComments saved successfully.", "data": data_store["additionalComments"]})

@app.get("/get/additionalComments")
async def get_additional_comments():
    logging.info("GET /get/additionalComments called")
    if "additionalComments" not in data_store:
        logging.warning("additionalComments not found in data_store")
        raise HTTPException(status_code=404, detail="additionalComments not found")
    return JSONResponse(content=data_store["additionalComments"])

@app.post("/post/bloodPanels")
async def post_blood_panels(files: list[UploadFile] = File(...)):
    logging.info("POST /post/bloodPanels called with %d files", len(files))
    # ----------------------------------------------------------
    # Convert files to base64
    try:
        images = await utils.files_to_base64(files)
    except RuntimeError as e:
        logging.error("Error converting files to base64: %s", e)
        raise HTTPException(status_code=400, detail=f"Error converting files to base64: {e}")
    # ----------------------------------------------------------
    # Read the images
    try:
        blood_panels: list[BloodPanel] = llm.image2struct(images, BloodPanel, llm.blood_panel_prompt, "Blood Panels")
        logging.info("Blood panel extraction successful, %d records found", len(blood_panels))
    except Exception as e:
        logging.error("LLM extraction failed: %s", e)
        raise HTTPException(status_code=500, detail=f"LLM extraction failed: {e}")
    # ----------------------------------------------------------
    data_store["bloodPanels"] = [p.model_dump() for p in blood_panels]
    return JSONResponse(content={"message": "bloodPanels saved successfully.", "data": data_store["bloodPanels"]})

@app.get("/get/bloodPanels")
async def get_blood_panels():
    logging.info("GET /get/bloodPanels called")
    if "bloodPanels" not in data_store:
        logging.warning("bloodPanels not found in data_store")
        raise HTTPException(status_code=404, detail="bloodPanels not found")
    return JSONResponse(content=data_store["bloodPanels"])

@app.post("/post/clinicalReports")
async def post_clinical_reports(files: list[UploadFile] = File(...)):
    logging.info("POST /post/clinicalReports called with %d files", len(files))
    # ----------------------------------------------------------
    try:
        images = await utils.files_to_base64(files)
    except RuntimeError as e:
        logging.error("Error converting files to base64: %s", e)
        raise HTTPException(status_code=400, detail=f"Error converting files to base64: {e}")
    # ----------------------------------------------------------
    try:
        clinical_reports: list[ClinicalReport] = llm.image2struct(images, ClinicalReport, llm.clinical_report_prompt, "ClinicalReports")
        logging.info("Clinical report extraction successful, %d records found", len(clinical_reports))
    except Exception as e:
        logging.error("LLM extraction failed: %s", e)
        raise HTTPException(status_code=500, detail=f"LLM extraction failed: {e}")
    # ----------------------------------------------------------
    data_store["clinicalReports"] = [p.model_dump() for p in clinical_reports]
    return JSONResponse(content={"message": "clinicalReports saved successfully.", "data": data_store["clinicalReports"]})

@app.get("/get/clinicalReports")
async def get_clinical_reports():
    logging.info("GET /get/clinicalReports called")
    if "clinicalReports" not in data_store:
        logging.warning("clinicalReports not found in data_store")
        raise HTTPException(status_code=404, detail="clinicalReports not found")
    return JSONResponse(content=data_store["clinicalReports"])

@app.post("/post/doctorLetters")
async def post_doctor_letters(files: list[UploadFile] = File(...)):
    logging.info("POST /post/doctorLetters called with %d files", len(files))
    # ----------------------------------------------------------
    try:
        images = await utils.files_to_base64(files)
    except RuntimeError as e:
        logging.error("Error converting files to base64: %s", e)
        raise HTTPException(status_code=400, detail=f"Error converting files to base64: {e}")
    # ----------------------------------------------------------
    try:
        doctor_letters: list[DoctorLetter] = llm.image2struct(images, DoctorLetter, llm.doctor_letter_prompt, "DoctorLetters")
        logging.info("Doctor letter extraction successful, %d records found", len(doctor_letters))
    except Exception as e:
        logging.error("LLM extraction failed: %s", e)
        raise HTTPException(status_code=500, detail=f"LLM extraction failed: {e}")
    # ----------------------------------------------------------
    data_store["doctorLetters"] = [p.model_dump() for p in doctor_letters]
    return JSONResponse(content={"message": "doctorLetters saved successfully.", "data": data_store["doctorLetters"]})

@app.get("/get/doctorLetters")
async def get_doctor_letters():
    logging.info("GET /get/doctorLetters called")
    if "doctorLetters" not in data_store:
        logging.warning("doctorLetters not found in data_store")
        raise HTTPException(status_code=404, detail="doctorLetters not found")
    return JSONResponse(content=data_store["doctorLetters"])