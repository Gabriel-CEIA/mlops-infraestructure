from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pathlib import Path
from config import BASE_DIR

app = FastAPI()


def safe_path(p: str) -> Path:
    full = (BASE_DIR / p).resolve()
    if not str(full).startswith(str(BASE_DIR)):
        raise HTTPException(403, "Access denied")
    return full


@app.get("/{path:path}")
def serve(path: str = ""):
    full = safe_path(path)

    if not full.exists():
        raise HTTPException(404, "Not found")

    if full.is_dir():
        return {
            "path": path,
            "items": [
                {
                    "name": p.name,
                    "type": "dir" if p.is_dir() else "file",
                    "size": p.stat().st_size,
                }
                for p in sorted(full.iterdir())
            ],
        }

    return FileResponse(full, filename=full.name)
