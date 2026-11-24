#!/usr/bin/env python3
"""Create GitHub milestones, labels and one issue per roadmap goal (docs/07-roadmap.md).

Safe to re-run: existing milestones, labels and issues (matched by "[ID]" in the title) are skipped.
Needs the GitHub CLI (`gh`) signed in with access to the repository.

    python3 scripts/create_github_issues.py OWNER/REPO [--dry-run]
"""

import json
import re
import subprocess
import sys
import time
from pathlib import Path

MILESTONES = {
    "F": ("M0 Foundation", "Repository, backend, database, quality gates, accounts", "0052cc"),
    "A": ("M1 Ad engine", "Scene, fonts, renderer, templates, editing API", "5319e7"),
    "V": ("M2 Verification", "Price, OCR, claims, brand and photo checks, approval, export", "d93f0b"),
    "U": ("M3 Interface", "Frontend, home page, editor, check panel", "0e8a16"),
    "S": ("M4 Ship", "Evaluation, deployment, security, release", "fbca04"),
}
DONE = {"F1", "F2", "F3", "F4"}  # merged earlier


def gh(*args: str, stdin: str | None = None) -> str:
    r = subprocess.run(["gh", *args], input=stdin, capture_output=True, text=True)
    if r.returncode:
        raise RuntimeError(r.stderr.strip() or r.stdout.strip())
    return r.stdout


def parse(roadmap: Path) -> list[tuple[str, str, str]]:
    rows = []
    for line in roadmap.read_text().splitlines():
        m = re.match(r"\|\s*([FAVUS]\d+)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|\s*(.+?)\s*\|$", line)
        if m:
            gid, goal, done_when = m.group(1), m.group(2).replace("**", ""), m.group(3)
            rows.append((gid, goal, done_when))
    return rows


def main() -> None:
    repo = sys.argv[1]
    dry = "--dry-run" in sys.argv
    rows = parse(Path(__file__).resolve().parents[1] / "docs" / "07-roadmap.md")
    print(f"{len(rows)} goals found")
    if dry:
        for gid, goal, _ in rows:
            print(f"  [{gid}] {goal}")
        return

    have_ms = {m["title"]: m["number"] for m in json.loads(gh("api", f"repos/{repo}/milestones?state=all&per_page=100"))}
    for key, (title, desc, color) in MILESTONES.items():
        if title not in have_ms:
            out = gh("api", f"repos/{repo}/milestones", "-f", f"title={title}", "-f", f"description={desc}")
            have_ms[title] = json.loads(out)["number"]
        try:
            gh("api", f"repos/{repo}/labels", "-f", f"name=goal:{key}", "-f", f"color={color}", "-f", f"description={title}")
        except RuntimeError:
            pass  # already exists

    existing = {
        m.group(1)
        for i in json.loads(gh("api", f"repos/{repo}/issues?state=all&per_page=100", "--paginate").replace("][", ","))
        if (m := re.match(r"\[([FAVUS]\d+)\]", i["title"]))
    }
    for gid, goal, done_when in rows:
        if gid in existing:
            continue
        ms_title = MILESTONES[gid[0]][0]
        body = (
            f"**Goal {gid}.** {goal}\n\n**Done when:** {done_when}\n\n"
            "One goal, one pull request. Details: docs/07-roadmap.md"
        )
        out = gh(
            "api", f"repos/{repo}/issues", "-f", f"title=[{gid}] {goal}", "-f", f"body={body}",
            "-F", f"milestone={have_ms[ms_title]}", "-f", f"labels[]=goal:{gid[0]}",
        )
        number = json.loads(out)["number"]
        if gid in DONE:
            gh("api", "-X", "PATCH", f"repos/{repo}/issues/{number}", "-f", "state=closed")
        print(f"#{number} [{gid}] {goal}")
        time.sleep(0.5)


if __name__ == "__main__":
    main()
