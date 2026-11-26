---
name: create-pr
description: Prepare a pull request title and description for the current branch, then open a prefilled GitHub browser form without submitting it. Use when asked to create or draft a PR.
---

# Create PR

- Check the repository, current branch, base branch, working tree, and existing PRs.
- Review the committed changes against the base branch. Follow the repository's PR template and conventions.
- Draft an accurate, concise title and description that explain the change and relevant testing.
- Open the prefilled form with `gh pr create --web`, passing the title, body, and base. Let `gh` push the branch if needed.
- Stop at the browser preview. Never submit the form or create the PR; let the user review and submit it.
