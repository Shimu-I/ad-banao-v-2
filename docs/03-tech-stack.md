# Technology stack

The tools chosen, the reasons, and the alternatives rejected. Decisions are also recorded in [adr/](adr/).

## The recommendation in one table

| Layer | Choice | Why this one | Alternatives considered |
| --- | --- | --- | --- |
| Backend language | **Python 3.11 or newer** | Best ecosystem for imaging (Pillow), OCR (Tesseract), vision (OpenCV, CLIP) and LLM clients, all of which this product needs | Node.js: weaker imaging and ML libraries |
| Backend framework | **FastAPI** | Typed, fast, automatic OpenAPI documentation, which also generates the frontend's API client | Django: heavier, and its strengths (admin, templates) are not what we need. Flask: fewer built-in guarantees |
| Data validation | **Pydantic v2** | Already used. Same models for API and settings | |
| Database access | **SQLAlchemy 2.0 with Alembic migrations** | Standard, typed, migrations are essential for a shipped product | Raw SQL, Django ORM |
| Database | **PostgreSQL** (Supabase or Neon free tier). SQLite only for quick local tests | Reliable, JSON support, free hosted tiers | MySQL |
| Image rendering | **Pillow with Raqm text layout** (see risk R-04) | Deterministic server render is the final, verified image | HTML to image: harder to verify and slower |
| OCR | **Tesseract** (English and Bangla packs) | Free, runs on the server | Cloud OCR (better Bangla, paid, kept as upgrade) |
| Vision checks | **OpenCV** for colors and layout, **CLIP** later and optional | Free. Photo integrity relies on hashes, not CLIP | |
| LLM | **Gemini and Groq free tiers behind one interface** | Swappable, tested fallback chain | Paid API later |
| Background work | **FastAPI background tasks first, Redis with RQ or Celery only if needed** | Keep it simple until generation time proves it necessary | Add queue from day one: more moving parts than the MVP needs |
| Auth | **Supabase Auth or `fastapi-users`, with JWT** | Do not hand-write password handling | Custom auth: avoid |
| File storage | **S3-compatible object storage** (Supabase Storage or Cloudflare R2) behind a `Storage` interface. Local disk in development | Free tiers, content-addressed filenames already in use | Database blobs: no |
| Frontend framework | **React with TypeScript, built with Vite** | Largest ecosystem, the editor library is React-friendly | Next.js: see decision D-04 |
| Styling and components | **Tailwind CSS with shadcn/ui (Radix based)** | Fast, accessible components, consistent design system | Material UI: heavier look |
| Server state | **TanStack Query** | Caching, retries, loading states | Redux: more code than needed |
| Forms | **React Hook Form with Zod** | Typed validation shared with the UI | |
| Animation | **Framer Motion** (the `motion` package) | Smooth, declarative animation for the home page and screens | CSS only: harder to orchestrate |
| Ad editor canvas | **Konva through `react-konva`** | Drag, resize, rotate, layers, export. Maps directly to our layer JSON | Fabric.js: also fine. Custom canvas: too much work |
| API client | **Generated from FastAPI's OpenAPI schema** (`openapi-typescript`) | Frontend and backend cannot drift apart silently | Hand-written fetch calls |
| i18n | **react-i18next** | English and Bangla | |
| Backend tests | **pytest, pytest-cov, httpx test client** | Already in use | |
| Frontend tests | **Vitest and Testing Library**, end to end with **Playwright** | Standard | Cypress |
| Code quality | **Ruff** (lint and format), **mypy** (types), **pre-commit**, ESLint and Prettier | One fast tool for Python style | Black plus flake8 |
| CI/CD | **GitHub Actions** | Free for the repository, runs on every pull request | |
| Containers | **Docker and Docker Compose** | One command for the full stack | |
| Hosting | **Vercel or Netlify** (frontend), **Render or Fly.io** (backend), **Supabase or Neon** (database) | Free tiers for demo | Paid always-on plan when real users arrive |
| Monitoring | **Sentry** (errors) and structured logs | Free tier | |
| Python environment | **`venv` with `pip`**, optionally `uv` for speed | Matches your Linux setup | Conda: not needed |

## Decision records (ADR summary)

Each decision is recorded in `docs/adr/` as a short file when we implement it. Summary:

| ID | Decision | Reason | Revisit when |
| --- | --- | --- | --- |
| D-01 | The ad is stored as **layers (scene JSON)**, and the **server render is final** | Checks know exactly what text, price and photo are in the ad. The browser preview can differ slightly, so only the server image is verified | Never. This is the core design |
| D-02 | The original photo is **never regenerated**, and integrity is a **hash check** | Far more reliable than image similarity | If AI backgrounds are added later |
| D-03 | Three-state results: Verified, Issue found, Cannot verify | Honest uncertainty is the product's main promise | Never |
| D-04 | **Vite single-page app**, not Next.js | Simpler to build and host. The signed-in app does not need server rendering. The home page needs good search visibility, so we pre-render it | If marketing pages grow, split them into an Astro or Next.js site later |
| D-05 | Approval is tied to a **content hash** | Any change to the ad makes the old approval invalid automatically | Never |
| D-06 | **Archive, do not delete** | Existing ads reference products and brands | When a privacy deletion feature is built |
| D-07 | **Free tiers first**, paid only when the MVP proves itself | Your instruction | After S1 results |
| D-08 | Monorepo with `backend/` and `frontend/` | One pull request can change both sides of one feature | If teams split |

## Why this stack is the best fit

- The hardest parts of the product are image work, text checking and AI calls. Python is the strongest place to build all three.
- The most visible part is the interface. React with Tailwind and shadcn/ui gives a modern, polished result quickly, and Konva gives a real editing canvas.
- Generating the frontend's API client from the backend's schema keeps both halves in step, which is what makes the product maintainable as it grows.
- Every paid upgrade (cloud OCR, paid LLM, always-on hosting) is a swap behind an interface, so nothing needs rewriting.
