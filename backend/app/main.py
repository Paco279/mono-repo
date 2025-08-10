import os
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Mono Repo API")

class Health(BaseModel):
    ok: bool
    db_url_present: bool

@app.get("/health", response_model=Health)
def health():
    return Health(ok=True, db_url_present=bool(os.getenv("DATABASE_URL")))
