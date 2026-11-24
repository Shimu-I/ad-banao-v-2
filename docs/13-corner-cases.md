# Corner cases

Things that can go wrong, grouped by module, with how we handle each.

These are grouped by module. The most important rule across all of them is to return one of three outcomes: Verified, Issue found, or Cannot verify.

## Product and brand input

- Missing fields such as price, description or brand guidelines. Block generation or warn clearly.
- Conflicting data between description, specs and price. Ask the user to resolve it.
- Price formats vary: "1,299", "1299.00", "৳1,299", "BDT 1299", "$12.99".
- Multiple currencies, or a price that changed after the profile was created.
- Discounts: original price, sale price and "50% off" must be mathematically consistent.
- Variants (sizes, colors, bundles) with different prices.
- Product images that are low-resolution, blurry, watermarked, cropped or on a busy background.
- Multiple products in one image, or the wrong image uploaded.
- Very long descriptions, special characters, emojis, or mixed Bangla and English text.
- Duplicate products uploaded under different names.
- Brand guidelines in a PDF with no machine-readable colors or fonts.
- Brands with several logo versions (light, dark, icon-only).

## AI text generation

- The LLM invents a price, discount, feature, warranty or "best seller" claim.
- Superlatives such as "best", "#1", "cheapest" or "guaranteed results".
- Health, safety or medical claims for food, cosmetics or supplements.
- Comparative claims against competitors with no evidence.
- Output too long for the ad format's character limits.
- Wrong or mixed language, or poor-quality Bangla output.
- Generic, repetitive output when the product has little data.
- Different results on every run, so verification cannot assume stable output.
- Prompt injection: a product description containing text like "ignore previous instructions".
- Offensive or culturally inappropriate wording.

## Template-based visual creation

- Text overflows its box, especially long product names or Bangla text.
- Product photo has the wrong aspect ratio and cropping cuts off the product.
- Low contrast between text and a busy photo background.
- Transparent PNGs, CMYK images or unusual file formats.
- Fonts that do not support Bangla or special characters and render as boxes.
- Different platform sizes (Facebook, Instagram story, banner) breaking the layout.
- Large images exceeding free server memory.

## Price and product detail verification

- A price appears in several places and only some are wrong.
- The price appears both in the image and in the caption, so both must be checked.
- "From ৳999" or "up to 50% off" is not an exact price and needs special rules.
- Equivalent formatting ("1,299" vs "1299") must not be flagged.
- Correct number but wrong currency symbol.
- Unit mismatches such as 500g vs 0.5kg or 1L vs 1000ml.
- Shortened product names that are still correct.
- Phone numbers, dates, offer deadlines and URLs in the ad that are not in the product data.
- Expired promotion dates.

## OCR text checking

- Stylized, curved, rotated, outlined or very small text.
- Text over gradients or photos.
- Bangla and mixed-script text, where Tesseract is weaker.
- Misreads such as "0" vs "O", "1" vs "l", an unrecognized "৳", or dropped decimal points.
- OCR picks up text printed on the product packaging, not the ad text. Separate the template layer from the photo layer.
- OCR reads nothing. The system must say "Cannot verify", never "Passed".
- Spell-check flags brand names, product names and Bangla-English transliterations as errors.
- **Mitigation:** because the ad is built from layers, the exact text placed is already known. Compare OCR output to that known text and use OCR mainly to confirm the render worked.

## Unsupported claim detection

- A true claim is phrased differently from the product data and gets falsely flagged.
- A false claim sounds similar to a supported one and is missed.
- Implied claims such as "doctor recommended", "eco-friendly" or "premium quality".
- Subjective opinions and factual claims need separate handling.
- Numbers and statistics in the ad, such as "3x faster" or "99% satisfaction".
- Negation: "not available in black" misread as "available in black".
- The verifier LLM hallucinates or gives inconsistent verdicts on repeated runs.
- A claim needs outside knowledge that is not in the profile. Mark "Cannot verify" instead of guessing.
- Legal or regulated claims that vary by country.

## Product image integrity

- Similar-looking images of different products scoring high on CLIP similarity.
- The same product photographed from another angle scoring low.
- Lighting, background or resizing changes lowering the similarity score.
- A photo edited before upload, so the "original" is not the true original.
- Small packaging changes (a color or label change) that CLIP does not notice.
- One similarity threshold that works for some products but not others.
- **Mitigation:** if the pipeline never regenerates the product photo, verify integrity with a hash of the original file and a check that the ad's photo layer points to it. This is far more reliable than CLIP.

## Brand consistency

- Colors that are close but not exact because of compression, anti-aliasing or lighting.
- Brands with many colors, gradients or transparency.
- A logo that is correctly placed but resized, distorted or too small.
- Logo detection failing on low-resolution, rotated or partly hidden logos.
- Font detection from an image is unreliable, so check fonts at render time instead.
- Tone-of-voice rules (formal vs casual) that are hard to measure.
- Sub-brands, seasonal campaigns and co-branded ads.

## Quality evaluation

- Contrast ratio passes but the text is still hard to read (thin fonts, busy background).
- The CTA is present but visually hidden, or several CTAs compete.
- Accessibility for color-blind users and small mobile screens.
- Scores differ from human opinion, and "good" varies by industry.
- Over-trusting a numeric score. Show reasons, not just a number.

## Reports, fixing and export

- Many issues found at once. Prioritize by severity: critical, warning, suggestion.
- An auto-fix introduces a new error. Re-verify after every fix.
- A false positive blocks a correct ad. Offer "override with reason".
- An ad is edited after approval. Invalidate the approval and re-run verification.
- Export in the wrong size, resolution or format for the platform.
- Report wording that is unclear to non-technical users.
- Keep version history and an audit trail of what was approved.

## Users and workflow

- Multiple users editing the same product or ad at once.
- Agencies with many client brands. Keep each brand's data isolated.
- A user deletes a product that existing ads still use.
- A user ignores all warnings and publishes anyway. Record it; the human decides.
- Very large batches of ads.

## Free-resource and infrastructure limits

- Gemini or Groq rate limit hit mid-process. Add retries, queueing and clear messages.
- Free API terms or limits change without notice. Keep the LLM layer swappable.
- Free-tier provider may use submitted data. Avoid confidential data.
- Backend sleeps after inactivity, so the first request is slow or times out.
- CLIP or PyTorch exceeds free RAM. Use smaller models or run locally.
- Free database storage fills up with images.
- Concurrent users overload the free server. Limit demo access.
- Internet outage during a live demo. Prepare a recorded fallback and cached results.

## Legal, ethical and trust

- Users upload copyrighted images or other brands' logos.
- Ads for restricted products such as alcohol, tobacco, medicine or adult content.
- Regional advertising rules. The tool should flag issues, not give legal advice.
- Users treating "verified" as a guarantee. Use wording like "no issues detected".
- Weaker performance for Bangla and other non-English content.

## Evaluating the project itself

- No ground-truth dataset exists. Build 30 to 50 test ads with known injected errors.
- A test set that is too easy makes results look better than they are.
- Measuring only accuracy. Also report false positives, false negatives and the "Cannot verify" rate.
- No baseline. Compare against manual review time.
- A small test sample. State this honestly.

## Product description generation

- The description invents specs, origin, ingredients or certifications that the user never entered.
- The description repeats the ad headline word for word, or contradicts it.
- The entered key features themselves contain unsupported or regulated claims, such as health benefits.
- The description is too long or too short for the place it will be used.
- Mixed Bangla and English output, or poor Bangla.
- The free AI service hits its limit mid-form. Fall back to basic template text and label it as basic.
- Regenerating gives different text. Keep earlier versions and never overwrite text the user edited by hand.
- The user edits the description by hand. Check it again.

## Editing on top of the ad

- The user changes the price text to a wrong value or makes a typo. Flag it right after the edit.
- The user deletes or hides the price, the call to action or the logo.
- Edited text overflows its box, overlaps another layer or runs off the image.
- The photo is stretched, squashed or cropped so the product is cut off. Lock the aspect ratio and warn on cropping.
- The photo is replaced with a different product's photo. Check it against the product profile and flag the difference.
- Colors are changed to off-brand ones, or text contrast drops after a color change.
- A font is chosen that cannot show Bangla letters. Offer only tested fonts.
- Undo returns the ad to an approved version. The approval is valid again only if the content is identical.
- The same ad is open in two tabs. Last save wins in the MVP, so warn about it.
- Resizing to another platform moves or distorts items. Re-run the layout and the checks.
- The browser preview differs from the server image. The server image is final.
- A very long edit session creates many versions. Limit and compress the history.

## Guided interface and onboarding

- The user leaves the form half-filled. Save a draft automatically.
- It is unclear which fields are required. Show what is missing and why, in plain words.
- Small phone screens make editing hard. Use large touch targets and simple controls.
- Reports use technical words. Write in plain language and offer Bangla.
- The user ignores warnings. Allow it, and record it.
- The user does not know what to type in "key features". Show an example next to the field.
