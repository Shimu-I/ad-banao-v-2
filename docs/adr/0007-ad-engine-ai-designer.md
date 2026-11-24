# ADR 0007: The AI proposes the design, our code renders and checks it

Status: accepted (2026-11-24, by the owner). Details and alternatives: [25-ai-and-ad-engine-plan.md](../25-ai-and-ad-engine-plan.md).

## Context
The product must show AI in the ad, but every ad has to be verifiable. Image models draw text badly and may change the product, and no dependable free image model exists (Google's free tier has none, Hugging Face gives free accounts no credits, Cloudflare allows about 170 images a day). Free text models are good enough.

## Decision
- **Option B.** Templates rendered by Pillow. A text model proposes the design as a scene (JSON): template, brand colors, headline, offer line, badge. Our code validates the scene (schema, allowed templates and colors, contrast, text fits, every number and claim comes from the product data) before rendering.
- If the model fails or its scene is rejected, a rules-based scene is used. The user never sees an error for this.
- The AI never touches the user's photo and never decides price, unit, offer or claim.
- Option C (an AI-drawn background behind the real photo) stays optional and is decided after A4. Option D (the model draws the whole ad) is rejected.
- Own thin provider adapters, with model names and keys as settings. No gateway for now.
- Order: F8, then A1 to A4, then the AI designer, then A5 to A7.

## Consequences
- Free text quotas (Groq first for privacy, Gemini second) limit volume to a few hundred ads a day.
- Free Gemini may use prompts for training, so only product facts are sent, never personal data.
- Open for the owner: free Groq and Gemini keys (needed to confirm model names), the Cloudflare decision after A4.
