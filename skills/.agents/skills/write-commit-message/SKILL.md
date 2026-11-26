---
name: write-commit-message
description: Suggest a commit message based on the current repository's conventions. Use when asked to propose a commit message or run /write-commit-message.
---

# Write Commit Message

Check the staged diff and recent commit-message style. If nothing is staged, ask what to commit; don't stage changes yourself. Suggest a few fitting messages and mark the best one as the default. Ask the user to confirm or edit it. Commit only after explicit confirmation, using the confirmed message. Don't include unrelated changes.
