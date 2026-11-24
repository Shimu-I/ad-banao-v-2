# AdBanao

**Create smarter. Verify better. Advertise confidently.**

## Summary

AdBanao turns the details and photo a business enters once into a finished **image ad**, a **product description** and ad text. The ad stays **editable**. AdBanao then checks it for wrong prices, invented claims and typos, and checks again after every edit. A person approves it before it is exported.

## The problem we are solving

| Problem today | How AdBanao solves it |
| --- | --- |
| AI ad tools change the product's look or packaging | The original photo is never regenerated. A hash proves it was not altered |
| AI invents prices, discounts and benefits | Text is written only from the facts the user entered, then fact-checked |
| Description, ad text and design are made in separate tools | One form creates all three |
| An edited ad is never checked again | Every edit is saved as a version and checked again. An edit cancels any earlier approval |
| AI scores are black boxes | Every result has a reason. If it cannot tell, it says "Cannot verify" |
| Businesses still review every ad by hand | Common errors are caught first. A human only approves |

## Features

- One form for product, price, features, photo and brand details
- Product description, headline, tagline and button text, grounded in the entered facts
- Image ad from templates in several sizes, with the original photo untouched
- Ad editor: move, resize, change text, colors, fonts, template, size or photo, with undo
- Checks for prices, text (OCR), unsupported claims, brand rules and photo integrity
- Plain-language report with one-click fixes
- Human approval, then export of the image and report
- English and Bangla

## Tech stack

| Part | Technology |
| --- | --- |
| Backend | Python, FastAPI, SQLAlchemy, Pydantic |
| Database | PostgreSQL (SQLite for quick local use) |
| Ad rendering and checks | Pillow, Tesseract OCR, OpenCV |
| AI writing | Gemini and Groq free tiers, with a basic-text fallback |
| Frontend (planned) | React, TypeScript, Vite, Tailwind CSS, shadcn/ui, Konva |
| Tooling | pytest, Ruff, GitHub Actions, Docker |

Reasons for each choice: [docs/03-tech-stack.md](docs/03-tech-stack.md).

## Status

Early development. Sign-up, sign-in, profile and admin pages work, and an ad creation page exists as a clickable prototype with sample data. No ad can be generated yet. To run it: [docs/26-run-adbanao.md](docs/26-run-adbanao.md). What is done and tested: [docs/PROGRESS.md](docs/PROGRESS.md).

## Quick start (Linux)

```bash
sudo apt install -y python3-venv libraqm-dev tesseract-ocr tesseract-ocr-ben
make setup
source .venv/bin/activate
make test
make run        # http://localhost:8000/docs
```

Add your own free Gemini or Groq key to `.env` for AI writing. Never commit `.env`. Run `make help` for all commands.

## Documentation

All documentation is in [docs/](docs/). Start with [docs/README.md](docs/README.md), which lists every file in reading order.
