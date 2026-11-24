# Project overview

What AdBanao is, the problem it solves, who it is for, and how it compares with existing tools.

## The idea in one paragraph

A small business fills in **one form**: product name, price and offer, key features, a photo, brand colors and logo, language, and ad size. AdBanao then produces three things from those same facts: a **finished image ad**, a **product description**, and **ad text** (headline, tagline, button text). The ad is made of **editable layers**, so the user can change it after it is generated. An **independent verification engine** checks the ad and the text against the entered facts, and checks again after every edit. A human approves, and the ad and a verification report are exported.

## The problem

| Problem today | What AdBanao does |
| --- | --- |
| AI ad tools can change the product's look or packaging | The original photo is never regenerated. It is placed untouched, and a hash proves it |
| AI invents prices, discounts and benefits | Text is generated only from entered facts, then checked. Invented numbers and unsupported claims are flagged |
| Description, ad text and design are made in separate tools | One form creates all three from the same facts |
| An edited ad is never checked again | Every edit becomes a new version and is checked again. An edit cancels any earlier approval |
| AI scores are black boxes | Every result has a reason. The system says "Cannot verify" instead of guessing |
| Businesses still review every ad by hand | Common errors are caught first, and a human only approves |

## Users

| Persona | Needs | What matters in the product |
| --- | --- | --- |
| Small shop owner (primary) | A good-looking ad in minutes, no design skill, often Bangla and English | Guided form, plain words, phone-friendly, Bangla support |
| Marketing freelancer or agency | Many brands, consistency, proof for the client | Brand isolation, reports, export |
| Reviewer or approver | Fast confidence before publishing | Clear green, yellow, red results with reasons |

## In scope for version 1.0

1. One-form product and brand input.
2. Grounded description and ad text generation (Gemini or Groq, with basic-text fallback).
3. Image ad renderer with templates in several sizes.
4. Ad editor with versions and undo.
5. Verification: prices and details, OCR, unsupported claims, brand rules, photo integrity.
6. Explainable report with one-click fixes.
7. Human approval and export.
8. User accounts and ownership of data.
9. An engaging home page and a guided four-screen interface.

## Out of scope for version 1.0 (kept on the later list)

AI-generated product imagery, video ads, bulk generation, team accounts with roles, trained logo detection, packaging-change detection, publishing directly to ad platforms.

## Success measures

| Measure | Target for v1.0 | How measured |
| --- | --- | --- |
| Catches injected errors (wrong price, typo, fake claim, off-brand color, swapped photo) | Reported honestly on a 30 to 50 ad test set, with false positives and "Cannot verify" rate | Goal S1 |
| Time from empty form to approved ad | Under 5 minutes for a new user | Usability test with 5 people |
| Original photo preserved | 100%. Hash of placed photo equals hash of upload | Automated test |
| Approval validity | An edited ad can never be exported as approved | Automated test |

## Problems this solves, and what it cannot solve

AdBanao fully solves wrong prices, typos, separate writing and unchecked edits, mostly solves photo changes and invented claims, and cannot solve sales prediction.

| Existing limitation | Can AdBanao solve it? | How |
| --- | --- | --- |
| Wrong prices or product details | Yes | Ads are generated from structured data, then checked against it. This is the strongest feature. |
| Typos and wrong text in the final image | Yes | OCR on the exported ad, compared with the known text. |
| Writing the description and the ad separately | Yes | One form creates the product description, ad text and image ad from the same facts. |
| Edited ads are never checked again | Yes | Every edit is saved as a version and checked again, and an edit cancels any earlier approval. |
| Black-box AI scores | Yes | Every verdict has a reason, and the app says "Cannot verify" instead of guessing. |
| Enterprise tools are expensive and complex | Yes | A simple, free or low-cost workflow aimed at small businesses. |
| AI changes product look or packaging | Mostly | The photo is never regenerated. A hash check confirms it was not altered or swapped. |
| Invented product benefits | Mostly | Claims in the ad and the description are compared to the entered facts and unsupported ones are flagged. Some subtle cases will be missed. |
| Generic content | Partly | Grounding in product data and brand voice helps, but free LLMs limit creativity. |
| Poor brand consistency | Partly | Colors, fonts and logo placement are checkable. Tone and overall feel are not. |
| Editing needs another design tool | Partly | Basic edits are built in: text, colors, fonts, position, size, template and photo swap. It is not a full design tool. |
| Manual review is still needed | Partly | Common errors are caught first, but a human still approves. |
| Creative scores do not predict sales | No | Nobody can guarantee this. The app gives rule-based quality checks with reasons, not fake performance scores. |

## Competitors and differentiation

AdBanao competes on verification and a simple one-form workflow, not on advanced design tools.

| Competitor | Main limitation or opportunity |
| --- | --- |
| Canva | Primarily design-focused; factual product verification remains important. |
| AdCreative.ai | Creative scores cannot guarantee actual advertising performance. |
| Creatify | AI video and product extraction can introduce inconsistencies. |
| Adobe GenStudio | Comprehensive but enterprise-oriented and potentially complex for smaller businesses. |

**Our differentiation**

- One form creates the product description, ad text and image ad
- Product-grounded ad generation
- Independent factual and visual verification, repeated after every edit
- Unsupported claim detection
- Explainable quality reports
- Original product photo preservation
- Affordable workflow for small businesses

This comparison is based on the project plan and has not been re-checked against the competitors' current features.
