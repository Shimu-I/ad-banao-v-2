# Linux setup

Set up a development machine with a Python virtual environment.

Commands for a typical Debian or Ubuntu system. Adjust the package manager for other distributions.

## System packages

```bash
sudo apt update
sudo apt install -y git python3 python3-venv python3-pip build-essential \
    libraqm-dev libjpeg-dev zlib1g-dev libfreetype6-dev \
    tesseract-ocr tesseract-ocr-ben \
    docker.io docker-compose-plugin
# Node.js (for the frontend): install the current LTS from https://nodejs.org or with nvm
```

`libraqm-dev` matters: without it, Pillow can render Bangla conjunct letters incorrectly (see risk R-04). `tesseract-ocr-ben` adds the Bangla OCR language pack.

## Clone and create the virtual environment

```bash
git clone git@github.com:<you>/adbanao.git
cd adbanao

python3 -m venv .venv
source .venv/bin/activate          # run this in every new terminal
python -m pip install --upgrade pip
pip install -r backend/requirements-dev.txt

cp .env.example .env               # then edit .env with your own keys
```

Rules for the virtual environment:

- `.venv/` is in `.gitignore` and is never committed.
- Always activate it before running anything (`source .venv/bin/activate`). The prompt shows `(.venv)`.
- Dependencies live in `requirements.txt` (runtime) and `requirements-dev.txt` (tools). After adding a package, update the file in the same pull request.

## Everyday commands (after goal F5 adds the Makefile)

| Command | What it does |
| --- | --- |
| `make setup` | Creates `.venv`, installs dependencies, installs pre-commit hooks |
| `make test` | Runs all backend tests |
| `make lint` | Ruff and mypy |
| `make run` | Starts the API on http://localhost:8000 with `/docs` |
| `make db-up` | Starts local Postgres with Docker Compose |
| `make migrate` | Applies database migrations |
| `make web` | Starts the frontend on http://localhost:5173 |

Until F5 exists, the equivalent commands are:

```bash
pytest                                        # from the repository root
cd backend && uvicorn app.main:app --reload   # then open http://localhost:8000/docs
```

## Free AI keys

Create free API keys for Gemini and Groq in their consoles, and put them in `.env` as `GEMINI_API_KEY` and `GROQ_API_KEY`. Never paste keys into code, chat, or commits. Free tier limits and model names change, so goal F8 makes the model names settings you can change without editing code.
