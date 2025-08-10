# mono-repo
A repo for experimenting with full web app development and deployment.

![alt text][file]

[file]: https://github.com/Paco279/mono-repo/blob/main/monorepo.png "Mono repo image"

## Repo setup (Linux)

```bash
git clone <mono-repo>
cd mono-repo
cp .env.example .env   # credentials editting required
docker compose up --build
```
*   API: http://localhost:8000/health
*   Postgres: port ${POSTGRES_PORT} (default: 5432)

## Backend development (optional)
```bash
cd backend
rye sync
rye run uvicorn app.main:app --reload
```

## Frontend (Next.js) — WiP
Read frontend/README.md to setup the framework.


## Repo structure

```css
mono-repo/
├─ LICENSE                      License (MIT)
├─ .gitignore                   To skip uploading certain files
├─ .env.example                 Example of env variables
├─ docker-compose.yml           Docker setup file
├─ README.md                    This file
├─ frontend/                    Frontend folder
│  └─ README.md                 Frontend's readme
└─ backend/                     Backend folder
   ├─ README.md                 Backend's readme
   ├─ pyproject.toml            Python dependencies
   ├─ requirements.txt          Python dependencies (only for Docker)
   ├─ Dockerfile                Docker file for backend
   └─ app/                      Backend's app folder
      ├─ __init__.py            Initial python script
      └─ main.py                Main python script
```