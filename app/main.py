from fastapi import FastAPI
from prometheus_metrics import setup_metrics
from health import router as health_router

app = FastAPI(title="Resilio TaskPulse")

app.include_router(health_router)
setup_metrics(app)
