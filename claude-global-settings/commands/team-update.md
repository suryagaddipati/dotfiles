# Generate Team Update

Generate a comprehensive team update message for Slack or other communication channels using the flow-master agent.

## MANDATORY: Use Flow-Master Agent
**THIS COMMAND MUST USE THE `flow-master` AGENT - NO EXCEPTIONS**

## Execution Steps

1. **Determine Update Type**
   - Daily standup format (default)
   - Weekly summary format
   - Sprint completion format
   - Custom format based on user request

2. **REQUIRED: Invoke Flow-Master Agent**
   ```
   Use the flow-master agent with the following request:
   "Generate team update for Slack with current PR and Jira status"
   ```
   
   The flow-master agent will:
   - Delegate to github-expert to gather PR statistics
   - Delegate to jira-expert to gather ticket statistics
   - Synthesize data into formatted team message
   - Provide copy-paste ready content for Slack

3. **DO NOT:**
   - Execute any direct `gh pr list` commands
   - Execute any direct `acli jira workitem search` commands
   - Attempt to bypass the flow-master agent
   - Use github-expert or jira-expert directly

## Expected Flow
```
User Request → THIS COMMAND → flow-master agent → github-expert + jira-expert → Result
```

## Output Formats

### Daily Standup (Default)
```
🚀 **Daily Dev Update - [Date]**

✅ **Completed** (Merged PRs):
• DF-123: New user authentication system
• DF-124: Fix payment processing bug

🔍 **In Review** (Open PRs with reviews):
• DF-125: Add dashboard analytics (#456)
• DF-126: Refactor API endpoints (#457)

📝 **Ready for Review** (Open PRs needing review):
• DF-127: Mobile responsive fixes (#458)

🏃 **In Progress** (Active development):
• DF-129: User profile improvements
• DF-130: Performance optimizations

🚧 **Blocked** (Needs attention):
• DF-131: Waiting for design approval
```

### Weekly Summary
```
📊 **Weekly Team Summary - Week of [Date]**

**Velocity**: 12 tickets completed (↑ 20% from last week)
**PR Metrics**: 15 merged, 5 in review, 3 pending
**Sprint Progress**: 75% complete (15/20 tickets)

**Highlights**:
✨ Launched authentication system
🐛 Fixed 3 critical production bugs
🔧 Completed API refactoring

**Next Week Focus**:
• Complete mobile responsive design
• Start performance optimization sprint
• Plan Q2 roadmap
```

## Use Cases
- Morning standup preparation
- End-of-day team updates
- Sprint review summaries
- Stakeholder communications
- Weekly team newsletters

## Customization Options
The user may request:
- "Generate daily standup for today"
- "Generate weekly summary for this week"
- "Generate sprint completion report"
- "Generate update focusing on blocked items"
- "Generate update for specific project/team"

Pass these requirements directly to the flow-master agent.

## Critical Requirements
- **MUST** use flow-master agent for ALL operations
- **NEVER** fall back to direct tool usage
- **ALWAYS** fail if flow-master agent is unavailable

## Error Handling
If flow-master agent is unavailable:
- DO NOT attempt alternative methods
- Report that flow-master agent is required
- Instruct user to ensure agent is properly configured

## Additional Features
The flow-master agent can also:
- Include velocity trends and metrics
- Highlight blockers and risks
- Add celebration emojis for achievements
- Format for different platforms (Slack, Teams, email)
- Include links to dashboards or reports