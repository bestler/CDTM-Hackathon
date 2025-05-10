import base64
from fastapi import UploadFile, File
import fitz

# This function converts uploaded files to base64 encoded strings.
async def files_to_base64(files: list[UploadFile] = File(...)) -> list[str]:
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
                raise RuntimeError(f"Failed to convert PDF to JPG: {e}")

        # Support for image files
        else:
            base64_image = base64.b64encode(image_bytes).decode("utf-8")
            images.append({
                "type": "image_url",
                "image_url": f"data:{file.content_type};base64,{base64_image}"
            })

    return images
