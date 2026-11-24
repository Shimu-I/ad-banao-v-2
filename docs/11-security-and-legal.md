# Security, privacy and legal

Controls for accounts, uploads, secrets, privacy and legal wording.

| Area | Control |
| --- | --- |
| Authentication | Provider-managed sign-in, JWT, short-lived tokens. No hand-written password storage |
| Authorisation | Every query filtered by owner. Tests prove user A cannot read user B's brand, product or ad |
| Uploads | Size limit, type check by content (not file name), pixel limit, original bytes stored under a hash name, never executed or served from the app directory |
| Injection | Parameterised queries only (SQLAlchemy). User text sent to the AI is quoted as data. Prompt-injection phrases are flagged |
| Secrets | Environment variables only. `.env` ignored. Secret scanning on GitHub |
| Rate limiting | Per-user limits on generation and upload |
| Transport | HTTPS only in staging and production. CORS limited to the frontend origin |
| Dependencies | Dependabot updates, `pip-audit` and `npm audit` in CI |
| Privacy | Plain notice that free AI providers may use submitted data. Do not upload confidential material on free tiers. Data export and account deletion planned before public launch |
| Legal | The tool flags issues and is not legal advice. Wording is "no issues detected", not "guaranteed compliant". Users confirm they own the images and logos they upload. Restricted products (alcohol, tobacco, medicine) get a warning |
| Audit | Approvals, overrides and who did them are recorded |

## Admin access

- Admins sign in on a separate page with email, password and a secret word (hash stored, never returned). The admin area only accepts sessions made there. A normal sign-in by an admin does not open it. All failure cases give one identical message. Failed admin sign-ins are logged; wrong guesses are not rate limited yet.
- Roles are stored only in the database. Sign-up, profile update and every other user-facing route ignore a `role` field (tested).
- Admin routes return 401 when signed out and 403 for normal users (tested for every route).
- `ADMIN_EMAILS` works only in development and test. In production an admin is made with `make admin EMAIL=...` on the server, or by another admin.
- Suspending ends the person's sessions at once. You cannot suspend or demote yourself, or the last active admin.
- Admin actions are written to the activity log with the admin's identity.
- CSV downloads neutralise spreadsheet formulas. Details: [22-admin.md](22-admin.md).
