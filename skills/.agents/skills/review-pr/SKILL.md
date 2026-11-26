---
name: review-pr
description: Review a pull request associated with the current local Git repository, identify actionable issues, and prepare proposed PR comments. Use when asked to review a local PR; post comments only after the user confirms the exact comments.
---

# Review PR

Use `gh` cli to find the PR for the current branch; ask if it is ambiguous. Review the diff and relevant code for actionable bugs, regressions, or risks—not style preferences.

Report findings with severity, file/line, and a proposed comment. Do not change the code. Ask the user to confirm the exact comments before posting. After confirmation, verify the PR is unchanged and post only the approved comments with `gh`; do not approve or request changes unless asked.
