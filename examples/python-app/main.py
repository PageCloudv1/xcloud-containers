"""
Example Python application for xCloud containers
"""
from fastapi import FastAPI
from pydantic import BaseModel
import os

app = FastAPI(title="xCloud Python Example App")


class HealthResponse(BaseModel):
    status: str
    service: str


class InfoResponse(BaseModel):
    message: str
    version: str
    environment: str


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "python-app"}


@app.get("/", response_model=InfoResponse)
async def root():
    """Root endpoint with app information"""
    return {
        "message": "xCloud Python Example App",
        "version": "1.0.0",
        "environment": os.getenv("ENV", "development")
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
