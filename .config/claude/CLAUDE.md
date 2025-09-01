# Global Claude Code Configuration

This file provides global guidance to Claude Code (claude.ai/code) for all development sessions across any project.

## Core Development Principles

**CRITICAL RULES:**
- NEVER EVER WRITE CODE COMMENTS unless explicitly requested
- Always use the vim-expert agent when users ask to open files
- Prioritize concise, direct responses (fewer than 4 lines unless detail requested)
- Minimize output tokens while maintaining helpfulness

### Language-Specific Preferences
- **Python**: 4-space indentation, type hints, pytest for testing
- **JavaScript/TypeScript**: 2-space indentation, modern ES6+, jest/vitest
- **Go**: gofmt compliance, table-driven tests
- **Rust**: cargo fmt, clippy warnings addressed
- **Shell scripts**: shellcheck compliance, POSIX compatibility where possible


## Specialized Agents

### Available Expert Agents
When encountering specific domain tasks, delegate to specialized agents for optimal results:

#### **vim-expert** 🟣
**Use when:** File operations, vim/neovim configuration, editor optimization, complex keybindings, **CODE VALIDATION**
**Triggers:** "where is", "which file", "open file", "find file", "show me", vim motions, text objects, **after generating any code**
**Expertise:** Advanced vim mastery, plugin recommendations, performance optimization, file location, **LSP integration for error detection**
**Example:** "I need to improve my vim text selection workflow" → Use vim-expert
**CRITICAL:** Always use vim-expert after generating code to check LSP errors and warnings

#### **github-expert** 🟣  
**Use when:** GitHub operations, pull requests, issues, workflows, repository management
**Triggers:** GitHub CLI operations, PR creation/management, issue tracking, workflow automation
**Expertise:** gh CLI, GitHub Actions, repository automation, collaborative development
**Example:** "Create a PR and link it to the current issue" → Use github-expert

#### **flow-master** 🟢
**Use when:** Complete development workflows between GitHub and Jira
**Triggers:** PR-to-Jira integration, workflow orchestration, team communication automation
**Expertise:** End-to-end workflow management, GitHub-Jira synchronization, team coordination
**Example:** "Create a PR, link to Jira ticket, and notify the team" → Use flow-master

#### **jira-expert** 🟣
**Use when:** Jira ticket management, project tracking, issue operations
**Triggers:** Ticket creation/updates, sprint management, project coordination
**Expertise:** Jira API, ticket workflows, project management, team coordination
**Example:** "Update the sprint status and assign tickets" → Use jira-expert

#### **slack-expert** 🟣
**Use when:** Slack workspace management, channel operations, team communication
**Triggers:** Message posting, channel management, team notifications, Slack automation
**Expertise:** Slack API, workspace management, automated notifications, team communication
**Example:** "Send a deployment notification to the team channel" → Use slack-expert

#### **backstage-expert** 🟣
**Use when:** Service catalog management, component discovery, data platform operations
**Triggers:** Component queries, service discovery, dataset management, platform workflows
**Expertise:** Backstage CLI, service catalog, data platform integration, Spotify developer portal
**Example:** "Find all components owned by the data-platform squad" → Use backstage-expert

#### **code-search-expert** 🟣
**Use when:** Advanced code searching, pattern analysis, refactoring opportunities
**Triggers:** Complex search queries, code pattern detection, security audits, architectural analysis
**Expertise:** codesearch CLI, regex patterns, boolean logic, code analysis across large codebases
**Example:** "Find all deprecated API usages across the codebase" → Use code-search-expert

### Agent Delegation Strategy
- **Proactive delegation**: Use agents when their expertise matches the task domain
- **Expert knowledge**: Agents have specialized knowledge beyond general capabilities
- **Tool access**: Agents have access to domain-specific tools and APIs
- **Efficiency**: Reduces context switching and improves task completion speed

## AI Assistant Guidelines

### Response Style
- **Concise and direct**: Answer the specific question asked
- **Action-oriented**: Prefer doing over explaining unless explanation requested
- **Context-aware**: Understand existing patterns and conventions
- **Security-minded**: Never suggest insecure practices

### Tool Usage Patterns
- **Always read files** before editing to understand context
- **Use search tools** (grep, find) to understand codebase structure
- **Leverage todo lists** for complex multi-step tasks
- **Batch operations** when possible for efficiency

### Code Generation & Validation Protocol
**MANDATORY WORKFLOW:**
1. **Generate code** using standard tools (Edit, Write, MultiEdit)
2. **IMMEDIATELY delegate to vim-expert** to validate the generated code
3. **Check LSP diagnostics** for errors, warnings, and type issues
4. **Fix any issues** identified by LSP before considering the task complete
5. **Re-validate** after fixes to ensure clean code

**Why this matters:**
- LSP provides real-time syntax and semantic analysis
- Catches type errors, undefined variables, import issues
- Validates against project-specific linting rules
- Ensures code integrates properly with existing codebase
- Prevents broken code from being committed

**Implementation:**
```
After any code generation:
→ Use vim-expert agent
→ Ask to "check LSP diagnostics for errors and warnings"
→ Address any issues found
→ Re-check until clean
```

### Error Handling
- **Graceful fallbacks**: Provide alternatives when primary approach fails
- **Clear diagnostics**: Explain what went wrong and why
- **Recovery paths**: Suggest specific steps to resolve issues

## Environment Detection

### Operating System Adaptations
- **macOS**: Use brew for package management, understand Darwin specifics
- **Linux**: Prefer apt/yum based on distribution, handle permissions carefully
- **Cross-platform**: Use mise for consistent tool versions across systems

### Development Context Recognition
- **Git repositories**: Understand branch structure, commit patterns, team workflows
- **Containerized environments**: Docker/Podman awareness, volume mount patterns
- **Cloud platforms**: AWS/GCP/Azure CLI tool familiarity
- **CI/CD systems**: GitHub Actions, GitLab CI, Jenkins pattern recognition

