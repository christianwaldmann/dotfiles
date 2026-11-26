---
name: update-dependencies
description: Inspect and maintain dependencies in the current Git repository. Use when asked to triage Renovate/Dependabot pull requests, decide whether dependency updates are safe to merge, investigate failing dependency checks, or update dependencies in this repository.
---

# Update Dependencies

Work only in the current repository. If it is unclear which repository is current, ask.

- Check open Renovate or Dependabot PRs, their diffs, and CI. Read release notes for major or risky updates.
- If a dependency PR fails, diagnose it and make only a related fix. Run the relevant checks; ask before pushing a fix.
- Never merge, approve, or enable auto-merge. Report which PRs look ready, why, and include their direct links so the user can decide.
- If there are no bot PRs and a direct update was requested, use the repo's package manager. Avoid major upgrades unless asked.
- Preserve unrelated work. Never reset, force-push, or approve PRs on the user's behalf.
