# Risks and open decisions

Known risks with mitigations, the cut line if time runs short, and decisions needed from the owner.

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- | --- |
| R-01 | Code has passed in CI and on the owner's machine, on SQLite and local PostgreSQL. Hosted database and real AI key not yet tried | Low | High | Goal F6 comes before any new feature |
| R-02 | Free AI services change limits, models or terms | High | Medium | Provider interface, fallback chain, basic text, model names as settings |
| R-03 | Bangla quality is weaker in free AI writing and OCR | High | Medium | Label results honestly, bundle Bangla fonts, plan cloud OCR as the first paid upgrade |
| R-04 | Pillow may shape Bangla text incorrectly without the Raqm layout engine | Medium | High | Install `libraqm`, verify with a Bangla rendering test in A2 before building templates |
| R-05 | Browser editor preview differs from the server image | Medium | Medium | Server image is final and is the one verified. Show a "final check" render before approval |
| R-06 | Free backend hosting sleeps, so the first request is slow | High | Low | Waking-up message, health ping, paid tier later |
| R-07 | Scope is large for the time available | High | High | Small goals, strict order, cut line below |
| R-08 | Users treat "Verified" as a guarantee | Medium | High | Wording "no issues detected", human approval always required, limitations page |
| R-09 | Uploaded copyrighted images or logos | Medium | Medium | Ownership confirmation, terms, restricted-product warning |
| R-10 | Name AdBanao may conflict with an existing company or domain | Unknown | Medium | Check before launch (S5) |

## Cut line if time runs short

Keep, in this order: F5 to F9, A1 to A6, V1, V2, V5, V6, U1 to U8, S1, S2, S3, S5. Drop first: A7 (replace photo and resize polish), V3 AI-assisted claims (keep rules only), V4 beyond hash and color checks, U9 beyond basics, S4 beyond the minimum checklist. Dropping something is always recorded in `PROGRESS.md`.

## Decisions needed from you

| # | Question | Recommendation |
| --- | --- | --- |
| 1 | Approve this stack and the 37-goal roadmap, or change them | Approve, then start with F5 |
| 2 | Auth provider: Supabase Auth (less code, ties you to Supabase) or `fastapi-users` (more code, no lock-in) | Supabase Auth if you already use Supabase for the database, otherwise `fastapi-users` |
| 3 | Build the home page early (U1 and U2 right after F5) or in order | Early, because it is visible and motivating |
| 4 | Name check and domain: do it now or at the end | Now, cheaply, before more branding work |
| 5 | Will the new repository be public or private | Private until after faculty review |
