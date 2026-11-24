# Team roles for the first update

Five people, equal workload, and not everyone touches code or GitHub. This page says who does what, what each person hands in, who presents what, and how the work already done is shared out so that **each person can explain and show their own part**.

**Fill in the names first.**

| Role | Name | Works in |
| --- | --- | --- |
| A. Project manager (Jira) | | Jira, Docs |
| B. Planner and requirements analyst | | Docs, Jira (read) |
| C. UI and UX designer | | Figma or Docs, browser |
| D. **Database lead** and backend developer | | GitHub, terminal |
| E. Frontend, testing and CI developer | | GitHub, terminal, browser |

## The first update

The faculty asked for four things. Each has one lead and one supporter.

| Faculty requirement | Status | Lead | Supporter |
| --- | --- | --- | --- |
| Project management setup | **Half done.** 38 goals and five milestones exist on GitHub. The Jira board is **not** set up yet | A | B |
| Repository setup | Done and merged. Folder structure, short README, `docs/`, CI, templates | E | D |
| Database setup | Done. Schema, migrations, PostgreSQL and SQLite, tests. Passed on the owner's PC. Explained as a story in [24-database-story.md](24-database-story.md) | D | B |
| User sign-up, sign-in and profile (full stack) | Done. Pages, API and database work together. Passed on the owner's PC | D (API) and E (pages) | C (look and feel) |

Also built beyond the four: an admin console with its own sign-in (email, password, secret word). It passed GitHub's checks and has **not** been run on the owner's PC yet.

## How this follows the first update

The faculty's four requirements decide who leads what. A leads project management, E leads repository setup, D leads database setup, and D and E together lead sign-up, sign-in and profile. B and C do not lead one of the four, because the four are mostly technical and management work. Their work sits inside them: B writes the stories and acceptance tests for sign-up, sign-in and profile and checks the database against the requirements, and C reviews how the sign-in, sign-up and profile pages look and read. If your faculty counts planning and design as separate items, B and C are those items.

## Equal workload

Every person has the same shape of work: a main deliverable, a review of someone else's work, a demo slot and a one-page summary. The hours are a planning estimate, **about 20 hours each**. Adjust them to your deadline.

| Person | Main deliverable | Reviews | Demo slot | Hours |
| --- | --- | --- | --- | --- |
| A | Jira board, sprint plan, sprint report | B's traceability table | 1.5 min | 20 |
| B | User stories, traceability table, acceptance test results | A's sprint scope | 2 min | 20 |
| C | Style guide, design review of the built pages, wireframes for next update | E's page fixes | 2 min | 20 |
| D | Database and sign-in explained and shown live | E's CI results | 2.5 min | 20 |
| E | Test report, CI explained, demo setup | D's database run | 2 min | 20 |

## What each person does

### A. Project manager (Jira)

No code. No GitHub account needed beyond read access.

| Task | Hours | Hand in |
| --- | --- | --- |
| Create the Jira project (Scrum). Five epics named like the milestones M0 to M4 in [07-roadmap.md](07-roadmap.md). Workflow: To Do, In Progress, In Review, Done | 2 | Board screenshot |
| Import the goals from [jira-import.csv](jira-import.csv) (38 rows, made from the roadmap). Check the statuses against [PROGRESS.md](PROGRESS.md) and group them under the epics by the `M0` to `M4` label | 3 | The board with all goals |
| Plan Sprint 1 = the first update. Add one task per row in this page's tables, assigned to the right person | 3 | Sprint 1 screenshot |
| Run three short stand-ups and keep notes: what was done, what is next, what is blocked | 3 | Meeting log |
| Keep a risk and issue list. Start from [13-corner-cases.md](13-corner-cases.md), [14-limitations-and-evaluation.md](14-limitations-and-evaluation.md) and the open items in PROGRESS.md | 2 | Risk list |
| Put the Jira key in each pull request title once Jira exists (for example `ADB-12: ...`) so the board and GitHub match | 2 | Linked examples |
| Sprint report: done versus not done, using PROGRESS.md as the truth | 3 | Sprint report |
| Present the project management part | 2 | Demo slot |

The Jira import file is made by `python3 scripts/export_jira_csv.py` and has not been tried on a live Jira site. If the import maps a column wrongly, fix it in the import screen. Jira and GitHub issues must tell the same story, and Jira is the board you show.

### B. Planner and requirements analyst

No code. Reads the docs and tests the running system as a user.

| Task | Hours | Hand in |
| --- | --- | --- |
| One-page brief: the problem, who it is for, what the first update covers. Start from [01-project-overview.md](01-project-overview.md) and [02-features-and-requirements.md](02-features-and-requirements.md) | 3 | One page |
| User stories with "Given, When, Then" checks for: sign up, sign in, sign out, edit profile, change password, wrong password, admin sign-in | 5 | Story list |
| Traceability table: each story to its page, its API route, its database table and its test. Start from [18-pages-and-user-flow.md](18-pages-and-user-flow.md) and [19-database.md](19-database.md) | 4 | Table |
| Review the corner cases for sign-in and profile in [13-corner-cases.md](13-corner-cases.md) and add any that are missing | 3 | List of additions |
| Run the acceptance tests by hand on the running demo, with the three demo users, and record pass or fail with a screenshot | 3 | Test results |
| Rehearse the demo with a stopwatch using [21-faculty-demo.md](21-faculty-demo.md) | 2 | Timed script |

### C. UI and UX designer

No code. Works from screenshots and the running pages.

| Task | Hours | Hand in |
| --- | --- | --- |
| One-page style guide from the built home page: colors in light and dark, fonts, spacing, buttons, the result colors (green, red, amber, always with an icon and a word) | 4 | Style guide |
| Design review of home, sign in and sign up, profile, admin sign-in and admin dashboard against your mockups. Check light, dark, desktop, phone, English and Bangla. List each difference with a screenshot | 6 | Defect list |
| Read every on-screen text in Bangla and mark anything wrong or unnatural | 3 | Text corrections |
| Accessibility check: contrast, keyboard use, focus outline, text size on a phone | 3 | Checklist |
| Wireframes for the next update: brand and product form, and the ad editor (see [08-ui-and-home-page.md](08-ui-and-home-page.md)) | 4 | Wireframes |

Known differences from the admin mockup, so you do not report them as new: no "Pending" status (accounts are Active or Suspended), Analytics and Settings are placeholders marked "Soon", a simpler sidebar picture, the home page logo instead of a leaf.

### D. Database lead and backend developer

Uses GitHub and a terminal. **In charge of the database**: nothing about the schema changes without D's approval, and D keeps [19-database.md](19-database.md) and [24-database-story.md](24-database-story.md) true. The rules D enforces are at the end of the story page.

| Task | Hours | Hand in |
| --- | --- | --- |
| Own the database. Learn [24-database-story.md](24-database-story.md) and [19-database.md](19-database.md) well enough to tell the story of one user across all eight tables without notes, and say which tables are not used by a page yet. Draw one diagram in your own words | 4 | Diagram and the story told aloud |
| Run the migrations on SQLite and PostgreSQL, including downgrade and upgrade again, and keep the output | 3 | Run log |
| Explain sign-up, sign-in and sessions: scrypt hashing, the session cookie, the token stored only as a hash. Show it live in Adminer | 4 | Notes and live demo |
| Explain ownership: every brand belongs to a user, other users get "not found". Run `make test` and show the result | 3 | Test output |
| Explain the admin side: roles, suspension, activity log, and the admin sign-in with the secret word ([22-admin.md](22-admin.md)) | 3 | Notes |
| Fix any backend problems the other four find, through pull requests | 3 | Merged pull requests |

### E. Frontend, testing and CI developer

Uses GitHub, a terminal and the browser.

| Task | Hours | Hand in |
| --- | --- | --- |
| Set up the project on your PC and run `./scripts/check_my_machine.sh --postgres --browser` ([20-test-on-your-pc.md](20-test-on-your-pc.md)) | 3 | `my-test-report.txt` |
| Explain how the pages talk to the API: home, sign in and sign up, profile, admin sign-in and dashboard | 4 | Notes |
| Run and explain the browser tests (`scripts/e2e_auth.py`, `scripts/e2e_admin_page.py`) | 3 | Run output |
| Explain the GitHub Actions pipeline and the pull request routine: lint, tests, end-to-end, merge | 4 | Notes and a green run |
| Fix the small page problems that C reports, through pull requests | 3 | Merged pull requests |
| Prepare the demo machine: seed users, three browsers, Adminer open, and a backup plan if Docker fails | 3 | Checklist |

## Accounts each person needs

| Tool | A | B | C | D | E |
| --- | --- | --- | --- | --- | --- |
| Jira | admin | member | member | member | member |
| GitHub (collaborator on `Shimu-I/ad-banao`) | read | read | read | write | write |
| The project docs | edit | edit | edit | edit | edit |

Only D and E push code. A, B and C can read everything on GitHub without writing to it.

## Demo order (10 minutes)

| Time | Who | Shows |
| --- | --- | --- |
| 0:00 | A | Jira board, the five milestones, Sprint 1 and what is done |
| 1:30 | B | Stories and the traceability table, then the acceptance results |
| 3:30 | C | The designs next to the built pages in light, dark, desktop and phone |
| 5:30 | D | Sign-up in the page, new row in the database, the three demo users, one user cannot see another's data |
| 8:00 | E | `my-test-report.txt`, the green GitHub Actions run |

The details of D's live steps are in [21-faculty-demo.md](21-faculty-demo.md).

## Order of work

| Day | What happens | Depends on |
| --- | --- | --- |
| 1 | E gets the project running and sends the test report. A creates the Jira project. B reads the docs. C opens every page and takes screenshots | Nothing |
| 2 | A imports the goals. B writes the stories. C writes the defect list. D runs migrations | E's setup |
| 3 | E and D fix what C and B found. A plans Sprint 1 with everyone's tasks | C's and B's lists |
| 4 | B runs the acceptance tests. Everyone prepares their slot. Cross-reviews | The fixes |
| 5 | Full rehearsal with a stopwatch, then the sprint report | Everything |

## Saying it honestly

The code, tests and documents so far were produced by the project owner working with an AI assistant (Claude). Say that plainly to the faculty. What matters is that each of you can **explain your own part, run it, and answer questions about it**. If someone asks about a part that is not yours, say whose it is.

Likely questions, by role:

| Role | Questions to be ready for |
| --- | --- |
| A | Why these five milestones? What is blocked, and what is the biggest risk? |
| B | Which requirement does this screen satisfy? What did you test and what failed? |
| C | Why this color and layout? How does it work in Bangla and on a phone? |
| D | Why store a hash and not the password? What stops one user reading another's data? |
| E | What do the automated checks cover? What is not tested yet? |

## Not done yet (be honest about these)

- The Jira board and the GitHub Projects board.
- Your teammates as collaborators on the repository.
- The admin console has not been run on the owner's PC.
- No real Gemini or Groq key tried, and no hosted database (Supabase or Neon).
- No password reset by email, and no limit on wrong sign-in attempts.
