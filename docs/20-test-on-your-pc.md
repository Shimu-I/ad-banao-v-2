# Test it on your own computer

Goal: run the checks on your Linux machine and send the result back, so the project status rests on a real run and not on guesses.

The automated checks in GitHub (see [PROGRESS.md](PROGRESS.md)) already pass. They run on a GitHub machine with SQLite. What nobody has done yet is run it **on your machine** and **against a real PostgreSQL**. This guide does that.

## The short way: one command

You need `git`, `python3` (3.11 or newer, with `python3-venv`) and an internet connection. Docker is needed only for the PostgreSQL check.

```bash
git clone https://github.com/Shimu-I/ad-banao.git adbanao
cd adbanao
git checkout step-01-repo-setup        # until the default branch is renamed to main

./scripts/check_my_machine.sh --postgres --browser
```

It takes a few minutes the first time. It prints PASS or FAIL for each step and writes **`my-test-report.txt`**. The report holds no passwords and no keys. **Send me that file** (attach it in the chat) and I will read the result and fix anything that failed.

Already cloned? Run `git pull` first.

| Option | What it adds | Needs |
| --- | --- | --- |
| *(none)* | Install, lint, 300+ automated tests, create tables with migrations, run the real server and try it | Python |
| `--postgres` | Repeat the migration and server check on a real PostgreSQL, and test downgrade and upgrade again | Docker |
| `--browser` | Open a real browser, sign up, sign in, edit the profile, sign out | Downloads a browser (about 150 MB) |

## What each step checks

| Step | What a PASS means |
| --- | --- |
| Python found, virtual environment, packages | Your machine can run the project at all |
| Lint (ruff) | The code follows the project's style rules |
| Automated tests (pytest) | All tests pass on your Python version and operating system |
| Create tables with migrations | The migration builds the schema from nothing |
| API check | The real server starts and a user can sign up, see and edit a profile, sign out and in, create a brand and a product (price `৳1,299` becomes `1299.00`, unit `0.5kg` becomes `500 g`), upload a photo, and a PDF pretending to be a photo is refused |
| PostgreSQL steps | The same things work on PostgreSQL, not only SQLite |
| Browser | The real home page forms talk to the real server |

## If something fails

- The line says which log to look at, and the report includes its last 40 lines. Send me the report. You do not need to understand it.
- "Port 8000 already in use": stop whatever uses it (`lsof -i :8000`) and run again.
- "Permission denied" on Docker: add yourself to the docker group (`sudo usermod -aG docker $USER`), log out and in, or put `sudo` before the command.
- Package install fails: check your internet connection and that `python3-venv` is installed (`sudo apt install python3-venv`).

## The longer way: try it by hand

This also ticks your checklist in [PROGRESS.md](PROGRESS.md). Use two terminals.

```bash
# one time
python3 -m venv .venv && source .venv/bin/activate
pip install -r backend/requirements-dev.txt
cp .env.example .env              # then edit it, see below
make migrate                      # creates the tables

# terminal 1: the API
make run                          # http://localhost:8000/docs

# terminal 2: the pages
cd frontend && python3 -m http.server 5173
```

Then:

1. Open http://localhost:5173/ . Click **Get Started**, create an account, and see "Your account is ready".
2. The header now shows **Profile** and **Sign out**. Open Profile, change your business name, save, reload the page. It should still be there.
3. Sign out. Open http://localhost:5173/profile.html . You should be sent to the sign-in screen.
4. Open http://localhost:8000/docs . Try `POST /brands`, then `POST /products` with price `৳1,299` and unit `0.5kg`, then `POST /products/{id}/image` with a real photo, then `GET /products/{id}/readiness`.
5. Try bad input on purpose: price `12,99`, and a PDF as the photo. The messages should be clear.

### Use PostgreSQL

```bash
make db-up                         # Docker starts PostgreSQL
```

In `.env` set:

```text
DATABASE_URL=postgresql://adbanao:adbanao@localhost:5432/adbanao
```

Then `make migrate` and `make run` as above. To look inside: `docker compose exec db psql -U adbanao -d adbanao -c "\dt"`. More in [19-database.md](19-database.md).

### Use a real AI key (optional)

Get a free key from Google AI Studio (Gemini) or Groq. Put it in `.env` as `GEMINI_API_KEY=` or `GROQ_API_KEY=`. Restart the server. Create a product with key features and call `POST /products/{id}/generate-copy`. Check that the text uses only your facts and that `source` says `gemini` or `groq`, not `basic`. **Never paste a key into the chat or commit `.env`.**

## What this will still not tell us

- Bangla text rendering and OCR (not built yet).
- Phones and other browsers. The browser test uses Chromium only.
- Heavy use, or many users at once.
