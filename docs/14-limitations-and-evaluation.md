# Limitations, claims and evaluation

What the product cannot do, what is safe to claim, and how it will be evaluated.

The project reduces review effort and flags likely issues. It does not guarantee correctness.

**Project limitations**

- AI verification cannot guarantee 100% accuracy.
- Creative quality is subjective.
- Product similarity does not prove product identity.
- Sales performance cannot be guaranteed.
- Free API usage has restrictions.
- Human approval remains necessary.
- The editor covers basic edits only and is not a full design tool.
- Free AI writing is weaker in Bangla than in English.
- The browser preview may differ slightly from the exported image. The exported image is the one that is verified.

**Safe to claim**

- Creates the product description, ad text and image ad from one form.
- Reduces manual review effort.
- Detects price, text and unsupported-claim errors.
- Protects the original product photo.
- Checks the ad again after every edit.
- Explains every issue it finds.

**Do not claim**

- That it guarantees accuracy or detects every false claim.
- That generated descriptions are guaranteed accurate. They are checked against the entered facts, not guaranteed.
- That it predicts sales or ad performance.
- That it replaces human approval.

**Evaluation plan**

1. Create 30 to 50 test ads with deliberately injected errors (wrong price, typo, fake claim, off-brand color).
2. Edit some of the ads by hand to add errors, such as a wrong price, an off-brand color or a swapped photo, to test that the check after an edit catches them.
3. Generate descriptions from the same inputs and look for invented facts.
4. Run the verifier and record what it catches, what it misses, and what it falsely flags.
5. Report the "Cannot verify" rate alongside accuracy.
6. Compare review time with and without the tool.
