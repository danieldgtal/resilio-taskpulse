from fastapi import FastAPI, Request, Response
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST, Counter

REQUEST_COUNT = Counter("http_requests_total", "Total HTTP requests", ["method", "endpoint"])

def setup_metrics(app: FastAPI):
    @app.middleware("http")
    async def count_requests(request: Request, call_next):
        response = await call_next(request)
        REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path).inc()
        return response

    @app.get("/metrics")
    async def metrics():
        return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
