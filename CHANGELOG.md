# Changelog

All notable changes are listed here. Format: [Keep a Changelog](https://keepachangelog.com),
versions follow [Semantic Versioning](https://semver.org).

## [Unreleased]

### Fixed
- The Bangla headline on the home page is smaller so it no longer overflows or shifts the hero layout.
- The home page nav bar stays at the top while scrolling.
- The home page footer no longer says nothing is saved (accounts are real; only the ad creation page is a prototype).
- Sign-in and sign-up card no longer changes layout when an error message appears: space for the message is reserved. A network failure now shows the short translated message.
- The database viewer port can be changed with `ADMINER_PORT` when 8080 is already in use.

### Added
- "How to start" guide on the ad creation page, with a "Don't show this again" option and a "How to start" button to open it again.
- The run guide now lives in `docs/26-run-adbanao.md` (moved from the project root).
- ADR 0007: the AI proposes the design, our code renders and checks it.
- AI and ad engine plan (`docs/25-ai-and-ad-engine-plan.md`).
- Project tracker (`docs/TRACKER.md`) and `scripts/update_tracker.py`.
- Project documents, backend skeleton and database models.
- Product and brand profiles: input, price and unit cleanup, photo validation, readiness report.
- Grounded product description and ad text generation with fact checking and basic-text fallback.
- Documentation set in `docs/` (17 topic files and an index), decision records, CI workflow, Makefile and developer tooling.

### Added
- User accounts: sign up, sign in, sign out, profile read and update, password change (`/auth/*`, `/users/me`).
- Alembic migrations with an initial schema (`make migrate`).

### Added
- Admin sign-in page with email, password and secret word (migration 0004), `make admin-secret`, gradients on the sign-in and sign-up page.
- Admin console: user roles, account suspension, activity log (migration 0003), `/admin/*` API, CSV downloads, `frontend/admin.html` (light/dark, desktop/phone, English/Bangla), `make admin`, demo admin user, admin end-to-end checks.

### Fixed
- Type error in price validation message (mypy).

### Changed
- README shortened for readers. All other documentation moved into `docs/`.
- Code moved into `core`, `db`, `domain`, `providers`, `api/v1` and `schemas`. Tests moved to `backend/tests`.
