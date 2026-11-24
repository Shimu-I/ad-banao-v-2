# Project tracker

The one-page view: what we are building, how far we are, what is next, what Claude can do alone and what needs a person. The detailed log, test reports and decisions are in [PROGRESS.md](PROGRESS.md). The goals themselves are in [07-roadmap.md](07-roadmap.md). Who does what in the team: [23-team-roles.md](23-team-roles.md).

Last updated: 2026-11-24 (Asia/Dhaka)

## Mission

AdBanao turns the details and photo a business enters **once** into a finished **image ad**, the **product description** and the ad text. Every part is **checked** (Verified, Issue found or Cannot verify), the ad stays **editable**, every edit is **checked again**, and a **human approves** before export.

The first working version (MVP) is done when one person can: fill one form, get an ad image with description and text, edit it, see the checks, fix issues, approve and export. Today the foundation exists. The product itself does not yet.

## Scoreboard

<!-- scoreboard:start -->
**38 goals in total: 6 done, 5 partly done, 27 not started. About 22% by goal count.**

| Milestone | Done | Partly | Not started | Goals |
| --- | --- | --- | --- | --- |
| M0 Foundation | 6 | 2 | 1 | 9 |
| M1 Ad engine | 0 | 0 | 7 | 7 |
| M2 Verification | 0 | 0 | 6 | 6 |
| M3 Interface | 0 | 3 | 8 | 11 |
| M4 Ship | 0 | 0 | 5 | 5 |

Done: F1, F2, F3, F4, F7, F9
Partly done: F5, F6, U2, U3, U11
<!-- scoreboard:end -->

Goals are not equal in size. The goals still ahead (ad engine, verification, the screens) are the largest, so the real share finished is smaller than the percentage suggests.

**What a user can do today:** create an account, sign in and out, edit a profile on real pages (home, sign in and sign up, profile). An admin can sign in on a separate page and see users and activity. Brands and products exist in the API only. **No ad can be made yet.**

## The first update (what the faculty asked for)

| Requirement | State | Evidence |
| --- | --- | --- |
| Repository setup | Done | GitHub repo, short README, `docs/`, CI, templates, every change a merged pull request |
| Database setup | Done | 8 tables, migrations 0001 to 0004, passed on SQLite and PostgreSQL on the owner's PC (before the admin migrations) |
| User sign-up, sign-in and profile | Done | Pages, API and database, passed on the owner's PC (2026-11-22) and in GitHub Actions |
| Project management setup | **Half done** | 38 goals and 5 milestones on GitHub. Jira board and GitHub Projects board not created, teammates not added |

## Tests: who has run what

| What | GitHub Actions | Owner's PC | Not tested |
| --- | --- | --- | --- |
| Backend logic and API (366 tests) | Passes | Passed 2026-11-22 (before the admin work) | |
| Migrations 0001 to 0002 on PostgreSQL | | Passed 2026-11-22 | |
| Migrations 0003 and 0004 (admin) | Pass on SQLite | **Not run yet** | PostgreSQL |
| Sign-up, sign-in, profile in a real browser | Passes | Passed 2026-11-22 | Phones, Safari, Firefox |
| Admin console and admin sign-in (API and browser) | Pass | **Not run yet** | |
| Gemini or Groq with a real key | | | **Never tried** |
| Hosted database (Supabase or Neon) | | | **Never tried** |
| Photo upload from a browser | API only | API only | Through a page (no page yet) |
| Bangla text on screen | Looked at in screenshots | | Read by a native speaker |

## Next up, in order

| # | Goal | Why this one | Who can do it |
| --- | --- | --- | --- |
| 1 | Finish the first update | Create the Jira and GitHub boards, add teammates, rename the branch to `main` and protect it ([09-development-process.md](09-development-process.md)) | **A person** (owner) |
| 2 | Owner runs `./scripts/check_my_machine.sh --postgres --browser` and sends the report | Proves the admin work on a real PC | **A person** |
| 3 | F8 API foundations, after you decide on [25-ai-and-ad-engine-plan.md](25-ai-and-ad-engine-plan.md) | Small, fixes the shut-down model, everything later depends on it | Claude alone. A person supplies free keys |
| 4 | A1 to A7 ad engine | The core of the product | Claude writes and tests; a person judges how the ads look |
| 5 | V1 to V6 verification | The reason the product exists | Claude writes and tests; a person judges accuracy |
| 6 | U1 and U4 to U10 the React app | Everything a user sees | Claude writes; a person runs and tests (see below) |
| 7 | S1 to S5 evaluation, deployment, security, release | Ship | Mixed |

One goal at a time, each as a pull request with CI, then merge and pull.

## What Claude can do alone, and what needs a person

| Area | Claude alone | Needs a person |
| --- | --- | --- |
| Backend code, database changes, migrations | Write, test in CI, merge | Run it once on a real PC and PostgreSQL |
| Ad rendering (A1 to A7) | Code, unit tests, sample images | Look at the sample ads and say whether they look professional. Check Bangla fonts |
| Verification (V1 to V6) | Code, a test set with known good and bad ads, measurements | Judge the wording of messages, decide the false-alarm level you accept, approve the final rules |
| OCR (V2) | Code and a CI setup with Tesseract | Check how well it reads Bangla on real ad images |
| React app (U1, U4 to U10) | Write the code. GitHub can build and run browser tests. Claude's own sandbox cannot install packages, so it cannot run the app | Run it on your PC and phone, try it as a user, say what feels wrong |
| AI text (F6) | Code and fake-provider tests are done | **Get a free Gemini or Groq key**, put it in `.env`, try it, judge the writing quality |
| Hosted database | Config and docs | **Create the Supabase or Neon account**, give the connection string through `.env` only |
| GitHub and Jira | Open pull requests, issues, merge, close | **Create boards, add collaborators, rename and protect the branch, accept invitations** |
| Deployment (S2, S3) | Dockerfiles, config, scripts | Create the hosting account, add secrets, own the domain |
| Security review (S4) | Check list, fixes, tests | Final sign-off. Rate limiting and password reset need decisions |
| Name and legal | | **Check the AdBanao name for trademark and domain** |
| Approvals | | Every approval is yours. A chat "approve" is a direction, not a review of the code |

## Human test list (things Claude cannot judge or reach)

- [ ] Run the machine check with PostgreSQL and the browser; send `my-test-report.txt`
- [ ] Walk through the admin console on your PC ([22-admin.md](22-admin.md), Try it): admin sign-in with the secret word, suspend and reactivate a user, CSV download opens in a spreadsheet
- [ ] Open the pages on a phone and in a second browser
- [ ] Ask a Bangla reader to read the pages and the admin page and mark wrong or unnatural text
- [ ] Put a real Gemini or Groq key in `.env`, call generate-copy, and judge the writing
- [ ] Try a hosted PostgreSQL (Supabase or Neon)
- [ ] Run the Adminer queries in [24-database-story.md](24-database-story.md) and report any that fail
- [ ] Read the wording of error and warning messages (price, photo, sign-in) as a user

## Blocked or waiting on a person

| Item | Waiting on |
| --- | --- |
| Jira board, GitHub Projects board | Owner and the project manager |
| Teammates as collaborators | Owner |
| Default branch rename and protection | Owner (GitHub settings) |
| Real AI key, hosted database | Owner |
| Trademark and domain check for AdBanao | Owner |

## Known gaps

No limit on wrong sign-in guesses. No password reset by email. No consistent error format or request IDs (F8). The default Gemini model in code (`gemini-2.0-flash`) was shut down by Google on 2026-06-01, so a real Gemini call would fail until F8.1. Details and the goal that closes each one: "Known gaps" in [PROGRESS.md](PROGRESS.md).

## Activity log

Every merged step, in date order, with test results: the **History** table in [PROGRESS.md](PROGRESS.md). Update it and this page in the same pull request as the work.
