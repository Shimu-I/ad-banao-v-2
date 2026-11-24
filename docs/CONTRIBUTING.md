# Contributing and workflow

This project is built one small goal at a time. Each goal is one branch and one pull request. The goals are listed in the [roadmap](07-roadmap.md). The full process, standards and CI are in [09-development-process.md](09-development-process.md).

## Roles

| Role | Who | Responsibility |
| --- | --- | --- |
| Product owner | You | Decides priorities, approves each plan, tests each goal, records faculty suggestions |
| Developer (pair) | Claude | Proposes the plan for each goal, writes code and tests, updates docs, reports what was and was not tested |
| Reviewer | You, with CI | Reads the pull request summary, checks CI is green, merges |

## Your routine

```bash
git checkout main
git pull                                  # always start from the latest main
git checkout -b feat/<goal-id>-name       # one branch per goal
# ...work, or receive files from Claude and copy them in...
git add -A
git commit -m "feat: short clear message"
git push -u origin feat/<goal-id>-name
# open the pull request on GitHub, wait for green checks, merge
git checkout main && git pull
```

## Branches and commits

- `main` always holds working code. No direct pushes: use a pull request.
- Branch names: `feat/<goal-id>-short-name`, or `fix/`, `docs/`, `chore/` for small work. Example: `feat/f6-run-for-real`.
- Commit messages: short, imperative, with a type prefix: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`, `ci:`.

## Pull requests

1. One goal, one purpose. Fill in the pull request template.
2. State what was tested and, plainly, anything that was not.
3. Update [PROGRESS.md](PROGRESS.md) in the same pull request: status, tests run, and anything the owner tested.
4. Check [FACULTY_SUGGESTIONS.md](FACULTY_SUGGESTIONS.md) for anything that affects the goal.
5. Merge after CI is green, then pull `main` before the next goal.

## Setting up a new repository (one time)

1. Create an empty repository named `adbanao` on GitHub (no README, so there are no conflicts).
2. In **Settings, Branches**, protect `main`: require a pull request and require status checks once CI exists (after F5).
3. Turn on **secret scanning** and **Dependabot alerts**.
4. Add the repository to Claude's GitHub access so Claude can push branches and open pull requests, or keep it push and pull only on your side and copy in the files Claude sends. Both work with the routine above.

## Secrets

Never commit API keys or `.env`. Use `.env.example` to document required variables.
