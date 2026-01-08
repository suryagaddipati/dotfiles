---
description: Create a git commit and push to remote
---

Create a git commit following these guidelines:

1. Run git status and git diff to see all changes
2. Analyze the changes and create commits with one logical change per commit:
   - Create multiple commits if changes span multiple concerns
   - Each commit should be a single logical change
   - Summarizes the nature of changes (feature/fix/refactor/docs/etc)
   - Focuses on "why" rather than "what"
   - Follows this repository's commit message style
3. Stage relevant files (avoid committing secrets or .env files)
4. Create the commit (respect the attribution settings in settings.json)
5. Push to the remote repository with appropriate upstream tracking
6. Report the final status

Follow all git safety protocols: never skip hooks, never force push to main/master, and check authorship before amending.
