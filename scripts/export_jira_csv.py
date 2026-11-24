#!/usr/bin/env python3
"""Turn the roadmap (docs/07-roadmap.md) into a CSV that Jira can import.

    python3 scripts/export_jira_csv.py            # writes docs/jira-import.csv

One row per goal. Columns: Summary, Description, Issue Type, Status, Labels, Priority.
The milestone (M0 to M4) is in Labels, so after the import you can group by label or move the
issues into five epics. Status is Done, In Progress or To Do from the roadmap marks.
Re-run after the roadmap changes. This file has not been tried against a live Jira site.
"""

import csv
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATUS = {"✅": "Done", "🟡": "In Progress"}


def rows():
    milestone = None
    for line in (ROOT / "docs" / "07-roadmap.md").read_text(encoding="utf-8").splitlines():
        m = re.match(r"## Milestone (M\d): (.+)", line)
        if m:
            milestone = (m.group(1), m.group(2).strip())
            continue
        r = re.match(r"\| ([A-Z]\d+) \| (.+?) \| (.+?) \| (.+?) \|\s*$", line)
        if r and milestone:
            gid, goal, done_when, status = r.groups()
            mark = next((k for k in STATUS if status.startswith(k)), "")
            yield {
                "Summary": f"[{gid}] {goal}",
                "Description": f"Milestone {milestone[0]}: {milestone[1]}\n\nDone when: {done_when}\n\nNotes from the roadmap: {status}",
                "Issue Type": "Task",
                "Status": STATUS.get(mark, "To Do"),
                "Labels": milestone[0],
                "Priority": "Medium",
            }


def main() -> None:
    data = list(rows())
    out = ROOT / "docs" / "jira-import.csv"
    with out.open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=["Summary", "Description", "Issue Type", "Status", "Labels", "Priority"])
        w.writeheader()
        w.writerows(data)
    print(f"Wrote {len(data)} goals to {out.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
