# Features and requirements

What the product does (features), and what it must do and how well (requirements).

## Features

The MVP has eleven features, all buildable on free resources. Later features need more time or paid tools.

| # | Feature | What it does | Stage |
| --- | --- | --- | --- |
| 1 | One-form product and brand input | Stores name, price, offer, key features, photo, brand colors, fonts and logo as the source of truth | MVP |
| 2 | Grounded text generation | LLM writes the product description, headline, tagline and button text using only the entered facts | MVP |
| 3 | Image ad creation | Builds the ad as an image from a template, with the original photo untouched, in several sizes | MVP |
| 4 | Ad editor | Edit the generated ad: move, resize, change text, colors, fonts, template, size or photo; versions and undo | MVP |
| 5 | Price and detail verification | Checks every price, discount, unit and detail against the profile | MVP |
| 6 | OCR check | Reads the exported ad and compares it to the known text; catches typos | MVP |
| 7 | Unsupported claim detection | Flags claims in the ad and the description that the entered facts do not support | MVP |
| 8 | Brand consistency check | Compares colors, logo placement and fonts to the brand profile | MVP |
| 9 | Explainable report with fixes | Lists each issue with severity, reason and suggested fix, with one-click fixes where possible | MVP |
| 10 | Approve and export | Human approval, then export of the final image and report | MVP |
| 11 | Guided, user-friendly interface | Four plain-language screens, live checks, draft saving | MVP |
| 12 | Logo detection with a trained model | Finds logos in uploaded or rendered images | Later |
| 13 | Packaging-change detection | Detects subtle changes to product packaging | Later |
| 14 | Advanced quality scoring | Hierarchy and CTA visibility beyond simple rules | Later |
| 15 | Bulk generation and team accounts | Many ads at once; multiple users and brands | Later |
| 16 | AI-generated backgrounds | Optional generated scenes behind the original photo | Later |
| 17 | Video ads | Short video versions of an ad | Later |

## Requirements

## Functional requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| FR-01 | A user can create an account, sign in and sign out | Must |
| FR-02 | A user can create and edit brands (name, colors, fonts, logo, tone) and archive them | Must |
| FR-03 | A user can create and edit products (name, price, original price, unit, key features, specs, allowed claims, photo) | Must |
| FR-04 | Price and unit input in common formats is normalised. Ambiguous input is rejected with a clear message | Must |
| FR-05 | The system shows what is missing before generation and blocks it when required data is absent | Must |
| FR-06 | The system writes the description, headline, tagline and button text in English or Bangla using only entered facts | Must |
| FR-07 | Generated text that invents numbers, currencies, contacts or unsupported claims is rejected. If AI writing is unavailable, labelled basic text is used | Must |
| FR-08 | The system renders an image ad from a template, in at least three sizes, with the original photo untouched | Must |
| FR-09 | The user can edit the ad: move, resize, edit text, change colors and fonts, show or hide layers, switch template or size, replace the photo | Must |
| FR-10 | Every edit creates a version. The user can undo and redo | Must |
| FR-11 | The system verifies prices and details, text (OCR), unsupported claims, brand rules and photo integrity | Must |
| FR-12 | Every check returns Verified, Issue found or Cannot verify, with a reason and severity | Must |
| FR-13 | The system re-checks after every edit and after every fix. An edit cancels any earlier approval | Must |
| FR-14 | The user can apply a one-click fix where one exists | Should |
| FR-15 | A human approves the ad. Only a verified, approved, unmodified version can be exported | Must |
| FR-16 | The user can export the image and the verification report | Must |
| FR-17 | The user can override a check with a written reason. The override is recorded | Should |
| FR-18 | An engaging home page explains the product and lets a visitor try a sample | Should |
| FR-19 | The interface works on a phone and supports Bangla | Must |

## Non-functional requirements

| ID | Quality | Requirement |
| --- | --- | --- |
| NFR-01 | Correctness | A check never reports "Verified" without evidence. No evidence means "Cannot verify" |
| NFR-02 | Integrity | The uploaded product photo is stored byte for byte and never altered |
| NFR-03 | Performance | Ad render under 3 seconds for a normal photo. Text generation shows progress and times out cleanly |
| NFR-04 | Reliability | If an AI service fails or is rate limited, the user still gets a usable result (basic text) and a clear message |
| NFR-05 | Security | OWASP Top 10 reviewed. Uploads validated. Secrets never in the repository. Each user sees only their own data |
| NFR-06 | Privacy | The user is told that free AI providers may use submitted data. No confidential data is promised on free tiers |
| NFR-07 | Maintainability | Type hints, linting, 80% or better test coverage on logic modules, one concern per module |
| NFR-08 | Observability | Structured logs with request IDs, error tracking in staging and production |
| NFR-09 | Accessibility | Keyboard usable, color contrast at WCAG AA, results never rely on color alone |
| NFR-10 | Internationalisation | English and Bangla text, Bangla digits accepted, Bangla fonts bundled |
| NFR-11 | Portability | Runs with one command in Docker. Local development works with a Python virtual environment |
| NFR-12 | Cost | Runs on free tiers for development and demo |
