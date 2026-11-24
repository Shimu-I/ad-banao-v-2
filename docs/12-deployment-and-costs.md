# Deployment and costs

Environments, releases, monitoring, the shipping checklist, and what free and paid resources cover.

## Deployment and operations

| Topic | Plan |
| --- | --- |
| Environments | Local (venv or Docker Compose), staging (free tiers, auto-deploy from `main`), production (tagged releases) |
| Configuration | Twelve-factor: all settings from environment variables, one `.env.example` |
| Database | Migrations run as a deploy step. Backups enabled on the provider |
| Releases | `vMAJOR.MINOR.PATCH` tags. Changelog per release. Rollback by redeploying the previous tag |
| Monitoring | Sentry for errors. Structured logs with request IDs. Health endpoints for database and AI providers |
| Free-tier limits | Backend sleeps when idle. Mitigation: a health ping and a clear "waking up" message. AI rate limits: caching, retry, fallback to basic text |
| When to pay | After evaluation (S1) and real users: cloud OCR first, then paid LLM, then always-on backend |
| Support | Issue templates. A short "known limitations" page in the product |

**Shipping checklist (S5):** all goals done, evaluation published with honest limits, security checklist complete, backup and restore tested, name and domain checked, privacy notice and terms written, demo script rehearsed, `v1.0.0` tagged.

## Cost and resources: free versus paid

The full MVP can be built on free resources. Paid upgrades are needed only for real users, better Bangla support and data privacy. All prices below are approximate, written from memory and not checked against current pricing pages, so verify before budgeting.

## What free resources cover

| Area | Free tool | What it covers |
| --- | --- | --- |
| Frontend hosting | Vercel or Netlify free tier | Demo site |
| Backend hosting | Render free tier | FastAPI API (sleeps when idle, slow first request) |
| Database | Supabase or Neon free tier | Product and brand profiles, reports |
| Image storage | Supabase Storage or Cloudinary free tier | Product photos and exported ads |
| LLM | Gemini and Groq free tiers | Product description, ad text and claim checking (rate limited) |
| OCR | Tesseract | Text reading (weak on Bangla and stylized fonts) |
| Vision | OpenCV, open-source CLIP | Color checks, similarity, hash comparison |
| Heavy models | Hugging Face Spaces or a local machine | CLIP and PyTorch |
| Ad image rendering | Pillow templates | Photo plus text layers in every size |
| Ad editor | Open-source canvas library | In-browser editing of the ad |

**Free resources can deliver:** the full MVP for a demo, a project submission and a handful of test users.

**Free resources cannot deliver:**

- Reliable use by many real users, because of rate limits and sleeping servers
- Strong Bangla OCR and text quality
- Logo recognition and packaging-change detection
- Confidential business data handling, since free providers may use submitted data

## What paid resources add

| Upgrade | Approx. cost | What you gain |
| --- | --- | --- |
| Paid LLM API (Gemini, OpenAI, Anthropic) | About $5 to $50 per month at low volume, scaling with usage | Higher limits, better claim checking, better Bangla, data privacy terms |
| Always-on backend (Render, Railway, Fly.io) | About $7 to $25 per month | No sleeping, more RAM and CPU |
| Paid database and storage | About $0 to $25 per month | More storage, backups |
| GPU or model hosting (Hugging Face, Modal, Replicate) | Pay per use, about $0.50 to $2 per hour for a GPU | Heavier vision models, logo detection |
| Cloud OCR (Google Vision, AWS Textract) | About $1.50 per 1,000 pages after a free allowance | Much better OCR, including Bangla |
| Domain and email | About $10 to $15 per year | A real product URL |

A realistic paid setup for a small pilot (always-on backend, paid LLM API, cloud OCR and a domain) is roughly $30 to $100 per month, depending on volume.

## Recommended upgrade order

1. **Now:** build everything on free resources and prove the verification works with the test set.
2. **First paid upgrades:** cloud OCR (biggest accuracy gain, especially for Bangla), then a paid LLM API (better claim detection and descriptions), then an always-on backend.
3. **Wait until there are users:** GPU hosting and trained logo detection.
