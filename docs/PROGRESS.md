# Progress log

Last updated: 2026-11-24 (Asia/Dhaka). This file is updated in every step's pull request.

**The one-page summary (mission, scoreboard, what Claude can do alone, what needs a person) is [TRACKER.md](TRACKER.md).** This file keeps the detail: tests, approvals, decisions and history.

## How far are we

**38 roadmap goals: 6 done, 5 partly done, 27 not started** (see the scoreboard in [TRACKER.md](TRACKER.md)). The goals still ahead include the largest pieces (ad generation, the editor, verification and the screens), so the real share finished is smaller than the count suggests.

| Part of the product | State |
| --- | --- |
| Project structure and docs | Done |
| Backend foundation (app, settings, database models) | Done. Tests pass in GitHub Actions and on your machine. Migrations and the API also pass on a local PostgreSQL 2026-11-22. Not yet tried on Supabase or Neon |
| Product and brand profiles (input, photo upload, price and unit cleanup, readiness report) | Done. API tests pass in GitHub Actions. Not yet tried by you |
| Product description and ad text generation | Done in code: key features, AI writing behind a swappable layer, fact checking, basic-text fallback. API tests pass in GitHub Actions with fake AI providers. Never tried with a real Gemini or Groq key |
| User accounts (sign up, sign in, sign out, profile) | Backend done and tested in CI. Home page with working sign-in and sign-up screens, header sign-in state, and a profile page. Tested in a browser against a fake API; in GitHub Actions the same pages also pass against the real backend (SQLite) |
| Admin console (roles, suspend, activity log, admin page) | Built 2026-11-23, admin sign-in 2026-11-24. Passes in GitHub Actions. Not yet run on the owner's PC |
| Image ad creation | Not started |
| Editing the ad | Not started |
| Verification (prices, OCR, claims, brand, photo) | Not started |
| Reports, approval, export | Not started |
| Screens (guided form, editor, check panel) | Not started |
| Evaluation and deployment | Not started |

**What a user can do today:** sign up, sign in and out, edit a profile on real pages; an admin can sign in separately and manage users. No ads can be generated yet.

## Steps

| # | Step | Status | Merged in | Tested by Claude | Tested by you |
| --- | --- | --- | --- | --- | --- |
| 1 | Repo setup | Done | Pushed as the default branch | Files only; no code to test | Not reported |
| 2 | Backend skeleton and database models | Done | PR #2 | Code compiles; 6 database-URL tests pass; model and health tests first ran in GitHub Actions on 2026-11-21 and passed | Not reported |
| 3 | Product and brand profiles | Done | PR #3 | 213 tests pass for the logic; API and model tests first ran in GitHub Actions on 2026-11-21 and passed | Not reported |
| 4 | One-form brief and grounded generation | Done | PR #6 | 28 new tests pass (fact checking, prompt, reply parsing, provider fallback, basic text); the new API route and its tests passed in GitHub Actions on 2026-11-21; no real AI service was called | Not reported |
| 5 | Ad design and image renderer | Not started | | | |
| 6 | Ad editing API | Not started | | | |
| 7 | Verification: prices and details | Not started | | | |
| 8 | Verification: OCR | Not started | | | |
| 9 | Verification: unsupported claims | Not started | | | |
| 10 | Verification: brand and image integrity | Not started | | | |
| 11 | Reports, one-click fixes, approval, export | Not started | | | |
| 12 | Frontend: guided form, editor, check panel | Not started | | | |
| 13 | Test set and evaluation | Not started | | | |
| 14 | Deployment and docs | Not started | | | |

Existing databases need the new `key_features` column: delete the local `adbanao.db` file and let the app recreate it (there is no data worth keeping yet), or add the column by hand.

Other work merged: project overview document (PR #1), rename to AdBanao (PR #4), faculty changes and this log (the pull request that added this file).

## Testing

### Run by Claude, in Claude's own environment (2026-11-16)

245 tests pass. They cover logic that does not need a web server or database.

| Area | Tests | Result |
| --- | --- | --- |
| Database URL helper | 6 | Pass |
| Price, discount and unit parsing | 119 | Pass |
| Photo validation and storage | 19 | Pass |
| Readiness checks | 28 | Pass |
| Request and response schemas | 45 | Pass |
| Fact checking of generated text | 12 | Pass |
| Text generation logic (with fake AI providers) | 16 | Pass |
| **Total** | **245** | **Pass** |

### Run in GitHub Actions (2026-11-21, first real run)

**289 tests passed, 0 skipped** on Python 3.12 in the `backend-ci` workflow (pull request #8). That includes the 44 tests that Claude's environment cannot run because it cannot install FastAPI and SQLAlchemy. The tests use SQLite, not PostgreSQL, and fake AI providers.

What those 44 tests cover:

| Area | Test functions | Why it matters |
| --- | --- | --- |
| Database models | 8 | Checks the archive rule, approval expiry and the three-state result against a real database |
| Health endpoints | 2 | Checks the server starts and reaches the database |
| Brand and product API (includes the new generate-copy route) | 31 | Checks every route: create, edit, archive, photo upload, readiness |

Counted by test function; tests with several cases count once. The lint step passed. The type check (mypy) reported one finding, which is fixed. One deprecation warning appears: Starlette's test client prefers the `httpx2` package. It is harmless today and worth fixing later.

### Not tested at all yet

- A hosted PostgreSQL (Supabase or Neon). A local PostgreSQL in Docker passed on 2026-11-22
- Photo upload through a browser or the API
- Gemini and Groq with a real key (the code is written, but only fake providers were used in tests)
- Any screen or browser behavior (not built yet)
- Bangla text rendering and OCR (not built yet)

### Tested by you

**2026-11-22, 01:16 (Asia/Dhaka): first run on the owner's own computer.** Ubuntu (Linux 7.0.0-43, x86_64), Python 3.12.3, Docker 29.10.0, commit `e980609` on `step-01-repo-setup`. Produced by `./scripts/check_my_machine.sh --browser`. Full report below.

```text
AdBanao machine check
Date:    2026-11-22T01:16:18+06:00
System:  Linux 7.0.0-43-generic x86_64
Python:  Python 3.12.3
Git:     e980609 on step-01-repo-setup
Docker:  Docker version 29.10.0, build fdd4b8e

Results
PASS  Python 3.11 or newer found (you have 3.12)
PASS  Create virtual environment (.venv)
PASS  Install backend packages
PASS  Lint (ruff)
PASS  Automated tests (pytest)
PASS  Create tables with migrations (SQLite)
PASS  API check on SQLite (sign up, profile, brand, product, photo)
SKIP  PostgreSQL checks   (add --postgres to run them)
PASS  Install browser test tools
PASS  Browser: sign up, sign in, profile, sign out
```

What this proves: the project installs and runs on the owner's machine with the newest package versions (FastAPI 0.165, SQLAlchemy 2.1.9, Pydantic 2.14), all tests pass there, and sign up, sign in, profile, brand, product and photo work against a real server and a real browser.

What it does not prove yet: PostgreSQL (skipped in this run, see the next one), a real Gemini or Groq key, phones and other browsers.

**2026-11-22, 01:27: second run, with PostgreSQL and the browser test.** Same machine, commit `5eb3a02`, produced by `./scripts/check_my_machine.sh --postgres --browser`. Every step passed.

```text
AdBanao machine check
Date:    2026-11-22T01:27:04+06:00
System:  Linux 7.0.0-43-generic x86_64
Python:  Python 3.12.3
Git:     5eb3a02 on step-01-repo-setup
Docker:  Docker version 29.10.0, build fdd4b8e

Results
PASS  Python 3.11 or newer found (you have 3.12)
PASS  Create virtual environment (.venv)
PASS  Install backend packages
PASS  Lint (ruff)
PASS  Automated tests (pytest)
PASS  Create tables with migrations (SQLite)
PASS  API check on SQLite (sign up, profile, brand, product, photo)
PASS  Start PostgreSQL in Docker
PASS  Create tables with migrations (PostgreSQL)
PASS  API check on PostgreSQL
PASS  Migration downgrade and upgrade again (PostgreSQL)
PASS  Install browser test tools
PASS  Browser: sign up, sign in, profile, sign out
```

This adds: the migration builds the schema on PostgreSQL 16 (Docker), the server works on it, and downgrade followed by upgrade works. An earlier run the same evening failed at the Docker step only because the user was not yet in the `docker` group; that was fixed on the machine, not in the project.

Still not proven: a real Gemini or Groq key, a hosted database (Supabase or Neon), phones and other browsers.

Earlier, the owner created and renamed the GitHub repository and connected GitHub (screenshots on 2026-11-13 and 2026-11-16).

Tick what you have run yourself, and write the result next to it. Tell Claude, or tick the same list in the project document, and it will be copied here.

- [x] Install: `pip install -r backend/requirements-dev.txt` (2026-11-22)
- [x] Run `pytest` from the repository root. Result: all passed (2026-11-22, via the check script)
- [ ] Start the server: `cd backend` then `uvicorn app.main:app --reload`, and open http://localhost:8000/docs
- [x] Create a brand (covered by the API check, 2026-11-22)
- [x] Create a product with price `৳1,299` and unit `0.5kg`. Comes back as `1299.00` and `500 g` (API check, 2026-11-22)
- [x] Upload a product photo (API check, 2026-11-22). Warning wording not yet reviewed by a person
- [ ] Open `GET /products/{id}/readiness` and check it lists what is missing
- [x] Try bad input: price `12,99` and a PDF as the photo. Both refused (API check, 2026-11-22). Message wording not yet reviewed by a person
- [ ] (Optional, step 4) Put a free Gemini or Groq key in `.env`, create a product with key features, and call `POST /products/{id}/generate-copy`. Check the text uses only your facts and `source` is `gemini` or `groq`
- [ ] (Optional) Connect a free Supabase or Neon database through `.env`

## Approvals

| Date | Approval | Scope |
| --- | --- | --- |
| 2026-11-16 | Owner wrote "i approve all and everyting" in chat (13:26, repeated 18:47, Asia/Dhaka) | The revised plan with the faculty changes, and all work merged so far: steps 1 to 3, the project overview, the rename to AdBanao |

Recorded as the owner's statement in chat. It is an approval of the direction and the merged work, not a record of reviewing the code line by line, and it does not replace the testing checklist above.

Earlier instructions from the owner: merge pull requests #1 and #2 (2026-11-13); after each update, pull and merge (2026-11-16).

## Decisions

| Date | Decision |
| --- | --- |
| 2026-11-13 | Build on free resources first. Move to paid services only if the MVP proves itself. |
| 2026-11-13 | Build one step at a time, with a plan shown first. |
| 2026-11-13 | Every check returns Verified, Issue found or Cannot verify. Never a forced pass. |
| 2026-11-13 | The original product photo is never regenerated or altered. |
| 2026-11-16 | Renamed the project from AdGuard AI to AdBanao. The GitHub repository is now `ad-banao`. |
| 2026-11-16 | After each step is pushed, open the pull request, merge it and pull. |
| 2026-11-16 | Faculty feedback adopted: the ad is an image generated from the user's details, product information and photo. One form also writes the product description. The ad can be edited after it is made. The interface must be user friendly. |
| 2026-11-16 | No AI-generated product imagery for now. It could change how the product looks. It stays on the "later" list as optional backgrounds. |

## Known gaps before this counts as a professional product

Each gap names the roadmap goal that closes it. Goal IDs are in the [roadmap](07-roadmap.md).

These are the honest gaps a senior reviewer would raise, each with the goal that closes it.

| Gap | Closed by |
| --- | --- |
| Run end to end on the owner's machine and on a local PostgreSQL (done 2026-11-22). Still not run with a real AI key or a hosted database | F6 |
| No automated checks on every pull request (lint, types, tests) | F5 (workflow file added, first real run pending) |
| ~~No database migrations~~ Done in PR #9. Existing local databases made before it still need to be deleted once | F7 |
| ~~No user accounts, so every brand and product is visible to everyone~~ Done (F9). Still missing: password reset by email, login rate limit | later |
| No consistent error format, request IDs or API versioning | F8 |
| **Default Gemini model `gemini-2.0-flash` in code was shut down by Google on 2026-06-01** (Google pricing page, checked 2026-11-24). A real Gemini call would fail today. Fake-provider tests do not show this | F8.1 (make it a setting, verify with a real key) |
| Default branch is still named `step-01-repo-setup` | F5 (rename to `main`) |
| Product name AdBanao not checked for trademark or domain | S5 |

## Open items and risks

- The default branch is still named `step-01-repo-setup`. Rename it to `main` in the repository settings.
- The name AdBanao has not been checked for existing companies, trademarks or domain availability.
- The API and models pass in GitHub Actions and on the owner's machine, on SQLite and on a local PostgreSQL. A hosted database (Supabase or Neon) and a real AI key have not been tried (see Testing).
- Claude's environment cannot install packages, so the React frontend and editor cannot be built or run there. They will need testing on your machine.
- Free AI services have rate limits, and Bangla output will be weaker. Step 4's basic-text fallback is in place.
- The editor preview in the browser may differ slightly from the exported image. The exported image is final and is the one that gets verified.
- Not handled yet: two people editing the same record at once, cleaning up unused photo files, and serving uploaded images over HTTP.

## History

| Date | What happened |
| --- | --- |
| 2026-11-24 | Owner accepted option B for the ad engine (the AI proposes the design, our code validates, renders and checks it). Recorded as ADR 0007. Docs only. |
| 2026-11-24 | AI and ad engine plan written ([25](25-ai-and-ad-engine-plan.md)): four options with pros and cons, free-tier facts checked against provider pages, recommendation and six decisions for the owner. Found that our default Gemini model is shut down. Docs only, no code. |
| 2026-11-24 | Project tracker added ([TRACKER.md](TRACKER.md)) with a script, `scripts/update_tracker.py`, that recomputes the scoreboard from the roadmap. This page's top section brought up to date. Docs only. |
| 2026-11-24 | Team roles page added (docs/23) for a team of five, plus `docs/jira-import.csv` made from the roadmap. The Jira board itself is not created yet. |
| 2026-11-24 | Admin sign-in page (email + password + secret word, migration 0004) and gradients on sign-in/sign-up added on branch feat/admin-login. Test result recorded after the pull request runs. |
| 2026-11-23 | Admin console built (docs/22): roles, suspension, activity log (migration 0003), admin API with CSV, admin page in light/dark and desktop/phone. Page checked in a browser against fake data. GitHub Actions (PR #56): 355 tests pass (29 new), plus the admin API checks and the admin page browser checks against the real backend. Not yet tried on the owner's machine. |
| 2026-11-13 | Idea reviewed. Project document written with features, corner cases, limits and costs. |
| 2026-11-13 | Step 1 pushed (repo setup). |
| 2026-11-13 | Step 2 built and merged (PR #2). Project overview added (PR #1). |
| 2026-11-16 | Step 3 built and merged (PR #3). |
| 2026-11-16 | Project renamed to AdBanao (PR #4). Repository renamed to `ad-banao` by the owner. |
| 2026-11-16 | Faculty feedback applied to the plan, the overview, the README and the contributing guide. This progress log added. |
| 2026-11-18 | Master plan written (docs/): stack, diagrams, 37-goal roadmap. Project packaged as a fresh repository with Makefile, ruff and pre-commit config, CI workflow, templates and decision records. Lint fixes applied to existing code (import order, one `raise ... from None`). The CI workflow has not run yet. |
| 2026-11-22 | Goal F9 ownership: brands belong to users (migration 0002), all brand and product routes require sign-in and are limited to the owner, tests with three users, demo users now have a brand and product each. |
| 2026-11-22 | Demo kit for the faculty: three demo users (`make seed`), a web database viewer (`make db-viewer`) and a demo script (docs/21). |
| 2026-11-22 | Second run on the owner's machine with PostgreSQL 16 in Docker and the browser test: every step passed. |
| 2026-11-22 | First run on the owner's machine (Ubuntu, Python 3.12): all steps passed except PostgreSQL, which was not run. |
| 2026-11-22 | Added pages and user-flow doc, database guide, and a check script for the owner's machine. GitHub now runs the real API and the real pages in a browser: 18 API checks and 8 browser checks pass. |
| 2026-11-22 | Combined home, sign-in and sign-up page added and connected to the account API. |
| 2026-11-22 | Database migrations (Alembic) and user accounts added (PR #9, 310 tests pass in CI). 37 roadmap goals logged as GitHub issues. |
| 2026-11-21 | Project structure, tooling and split documentation pushed in pull request #8. First GitHub Actions run: lint passed, 289 tests passed, mypy reported one finding (fixed). |
| 2026-11-20 | Documentation reorganised: short README for readers. All other documents moved into `docs/` as numbered topic files with an index (`docs/README.md`). Code moved into the planned folder layout (core, db, domain, providers, api/v1, schemas) and tests into `backend/tests`. Imports checked statically; 245 tests pass. API and database tests still never run. |
| 2026-11-18 | Step 4 built: key features field, fact checking of generated text, Gemini and Groq providers with basic-text fallback, and the generate-copy route. |
