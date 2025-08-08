# Sync Approved PRs to Done

Find all approved GitHub PRs and automatically move corresponding Jira tickets to "Done" status using the flow-master agent.

## MANDATORY: Use Flow-Master Agent
**THIS COMMAND MUST USE THE `flow-master` AGENT - NO EXCEPTIONS**

## Execution Steps

1. **REQUIRED: Invoke Flow-Master Agent**
   ```
   Use the flow-master agent with the following request:
   "Check all approved PRs and move corresponding Jira tickets to Done status"
   ```
   
   The flow-master agent will:
   - Delegate to github-expert to find all approved PRs
   - Extract Jira ticket IDs from PR titles/descriptions
   - Delegate to jira-expert to transition tickets to "Done"
   - Generate a summary report of all transitions

2. **DO NOT:**
   - Execute any direct `gh pr list` commands
   - Execute any direct `acli jira workitem transition` commands
   - Attempt to bypass the flow-master agent
   - Use github-expert or jira-expert directly

## Expected Flow
```
User Request → THIS COMMAND → flow-master agent → github-expert + jira-expert → Result
```

## Output Format
The flow-master agent will provide:
```
📊 Approved PR Sync Results
✅ Successfully moved to Done:
  • DF-123: Authentication system (PR #456)
  • DF-124: Bug fix for payments (PR #457)
  • DF-125: API refactoring (PR #458)

⚠️ Failed/Skipped:
  • DF-126: Already in Done status
  • DF-127: Permission denied for transition

Summary: 3 tickets moved, 2 skipped
```

## Use Cases
- End of day workflow cleanup
- Pre-standup status synchronization
- Sprint closure activities
- Release preparation

## Critical Requirements
- **MUST** use flow-master agent for ALL operations
- **NEVER** fall back to direct tool usage
- **ALWAYS** fail if flow-master agent is unavailable

## Error Handling
If flow-master agent is unavailable:
- DO NOT attempt alternative methods
- Report that flow-master agent is required
- Instruct user to ensure agent is properly configured

## Additional Options
The user may request:
- "Sync approved PRs for specific repository"
- "Sync approved PRs from last 7 days"
- "Dry run - show what would be synced"

Pass these requirements directly to the flow-master agent.