#!/usr/bin/env python3
"""Recompute the scoreboard in docs/TRACKER.md from the roadmap marks in docs/07-roadmap.md.

    python3 scripts/update_tracker.py

Only the text between the two `scoreboard` markers in TRACKER.md is rewritten, so the numbers
there can never drift from the roadmap. A goal counts 1 when done, 0.5 when partly done and
0 when not started. Goals are not equal in size, so this is a rough guide, not a schedule.
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
START, END = "<!-- scoreboard:start -->", "<!-- scoreboard:end -->"


def read_goals():
    milestone, goals = None, []
    for line in (ROOT / "docs" / "07-roadmap.md").read_text(encoding="utf-8").splitlines():
        m = re.match(r"## Milestone (M\d): (.+?) \(", line)
        if m:
            milestone = f"{m.group(1)} {m.group(2)}"
            continue
        r = re.match(r"\| ([A-Z]\d+) \| (.+?) \| (.+?) \| (.+?) \|\s*$", line)
        if r and milestone:
            status = r.group(4).strip()
            kind = "done" if status.startswith("✅") else "partial" if status.startswith("🟡") else "todo"
            goals.append((milestone, r.group(1), kind))
    return goals


def block(goals):
    total = len(goals)
    n = {k: sum(1 for g in goals if g[2] == k) for k in ("done", "partial", "todo")}
    pct = round((n["done"] + 0.5 * n["partial"]) * 100 / total)
    lines = [
        f"**{total} goals in total: {n['done']} done, {n['partial']} partly done, {n['todo']} not started. "
        f"About {pct}% by goal count.**",
        "",
        "| Milestone | Done | Partly | Not started | Goals |",
        "| --- | --- | --- | --- | --- |",
    ]
    for ms in dict.fromkeys(g[0] for g in goals):
        sub = [g for g in goals if g[0] == ms]
        c = {k: sum(1 for g in sub if g[2] == k) for k in ("done", "partial", "todo")}
        lines.append(f"| {ms} | {c['done']} | {c['partial']} | {c['todo']} | {len(sub)} |")
    lines += ["", "Done: " + ", ".join(g[1] for g in goals if g[2] == "done"),
              "Partly done: " + ", ".join(g[1] for g in goals if g[2] == "partial")]
    return "\n".join(lines)


def main():
    path = ROOT / "docs" / "TRACKER.md"
    text = path.read_text(encoding="utf-8")
    new = re.sub(re.escape(START) + r".*?" + re.escape(END), START + "\n" + block(read_goals()) + "\n" + END, text, flags=re.S)
    path.write_text(new, encoding="utf-8")
    print("Scoreboard updated.")


if __name__ == "__main__":
    main()
