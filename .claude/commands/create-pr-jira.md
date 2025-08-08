# Create PR with Jira Integration

Create a GitHub Pull Request with automatic Jira ticket integration using the flow-master agent.

## MANDATORY: Use Flow-Master Agent
**THIS COMMAND MUST USE THE `flow-master` AGENT - NO EXCEPTIONS**

## Execution Steps

1. **Extract Jira Ticket Information**
   - Check current git branch name for ticket ID (e.g., `feature/DF-123-description`)
   - If not found in branch name, ask user to provide ticket ID

2. **REQUIRED: Invoke Flow-Master Agent**
   ```
   Use the flow-master agent with the following request:
   "Create PR for [TICKET-ID] with Jira integration"
   ```
   
   The flow-master agent will:
   - Delegate to github-expert for PR creation
   - Delegate to jira-expert for ticket status update
   - Orchestrate the complete workflow

3. **DO NOT:**
   - Execute any direct `gh` commands
   - Execute any direct `acli jira` commands
   - Attempt to bypass the flow-master agent
   - Use github-expert or jira-expert directly

## Expected Flow
```
User Request → THIS COMMAND → flow-master agent → github-expert + jira-expert → Result
```

## Output Format
The flow-master agent will provide:
- PR creation confirmation with URL
- Jira ticket status update confirmation
- Bidirectional linking confirmation
- Any errors from the orchestrated workflow

## Critical Requirements
- **MUST** use flow-master agent for ALL operations
- **NEVER** fall back to direct tool usage
- **ALWAYS** fail if flow-master agent is unavailable

## Error Handling
If flow-master agent is unavailable:
- DO NOT attempt alternative methods
- Report that flow-master agent is required
- Instruct user to ensure agent is properly configured