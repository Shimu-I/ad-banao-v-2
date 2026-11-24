# Folder structure

Where everything lives, and why.

## What is in the repository today

This tree is generated from the real files. Folders marked "empty" hold only a placeholder until their goal starts.

```text
adbanao/
├── .github/                                   CI workflow, pull request and issue templates, code owners
├── assets/                                    Fonts and ad templates (goals A2, A4)
├── backend/                                   The API and all server-side logic
│   ├── app/                                   The application package
│   │   ├── api/
│   │   │   └── v1/                            Thin routers: brands, products, health
│   │   ├── core/                              Settings (config.py)
│   │   ├── db/                                Database: session.py, url.py, models.py
│   │   ├── domain/                            Pure logic, no web or database imports: normalize, images, profile_checks, grounding, generation
│   │   ├── providers/                         Adapters for outside services (Gemini and Groq in llm.py)
│   │   ├── rendering/                         Ad renderer (empty until goals A2 to A4)
│   │   ├── schemas/                           Request and response models
│   │   ├── services/                          Use cases (empty until goal A5)
│   │   ├── verification/                      Verification modules (empty until goals V1 to V5)
│   │   └── main.py                            FastAPI app: wires routers, creates tables
│   ├── tests/                                 Automated tests
│   │   ├── evaluation/                        Test ads with injected errors (goal S1)
│   │   ├── integration/                       API and database tests
│   │   ├── unit/                              Fast tests for pure logic
│   │   ├── README.md
│   │   └── conftest.py
│   ├── README.md
│   ├── requirements-dev.txt                   Test dependencies
│   └── requirements.txt                       Runtime dependencies
├── docs/                                      All documentation (start with docs/README.md)
├── frontend/                                  Web app (not started)
├── scripts/                                   Developer helpers
├── .editorconfig                              Editor formatting rules
├── .env.example                               Every setting, with no secrets
├── .gitignore
├── .pre-commit-config.yaml                    Checks that run before each commit
├── CHANGELOG.md                               Release notes
├── Makefile                                   One-word commands: make setup, test, lint, run
├── README.md                                  Simple project summary, features, stack, quick start
├── SECURITY.md                                How to report a vulnerability
├── docker-compose.yml                         Local PostgreSQL
├── pyproject.toml                             Ruff and mypy settings
└── pytest.ini                                 Test settings
```

## Added by later goals

| Item | Goal | Purpose |
| --- | --- | --- |
| `backend/app/core/` logging, errors, request IDs | F8 | One error format and structured logs |
| `backend/alembic.ini`, `backend/migrations/` | F7 | Versioned database changes |
| `backend/Dockerfile`, `frontend/Dockerfile` | S2 | Production containers |
| `backend/app/domain/scene.py`, `content_hash.py` | A1 | Ad layer format and content fingerprint |
| `backend/app/rendering/` renderer, templates, fonts | A2 to A4 | Draw the ad image |
| `backend/app/verification/` price, ocr, claims, brand, integrity, engine | V1 to V5 | The checks |
| `backend/app/services/` | A5 onward | Use cases that tie the pieces together |
| `backend/app/api/v1/ads.py`, `verification.py` | A5 to V6 | Ad, check, approval and export routes |
| `frontend/src/` app, pages, features, components, lib | U1 to U8 | The web app and editor |
| `frontend/tests/` | U10 | Vitest and Playwright tests |
| `.github/workflows/frontend-ci.yml`, `e2e.yml` | U1, U10 | Frontend and end-to-end checks |
| `assets/fonts/`, `assets/templates/` content | A2, A4 | Bangla and English fonts, starter templates |
| `LICENSE` | S5 | Chosen by the owner |

## Rules that shape the layout

- **`domain/` has no web or database imports.** That is why most logic can be tested quickly anywhere.
- **`providers/` isolates everything external** (Gemini, Groq, later storage and OCR). Swapping a free service for a paid one touches one folder.
- **`api/v1/` is thin.** Routers translate HTTP and call logic.
- **`docs/adr/`** records why decisions were made, so they are not argued again.
- **One concern per module**, so each can be read and tested alone.

