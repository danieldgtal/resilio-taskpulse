from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/healthz", tags=["Health"])
async def healthcheck():
    return JSONResponse(content={"status": "ok"})
