# MY AI-ASSISTED WORKFLOW

**Philosophy: Maximum Parallel Compute from the Cloud**

## Core Principle

Never wait sequentially when you can execute in parallel. This development environment is architected around one fundamental belief: **AI's true power lies in its ability to handle multiple contexts simultaneously**. Instead of traditional serial workflows where you wait for one task to complete before starting another, this setup enables massive parallelization of cognitive tasks by leveraging cloud AI compute.

The goal is simple: **Pull maximum compute from the cloud by running parallel flows**.

## Architecture Overview

This dotfiles repository creates a development environment where:

- **Multiple AI agents** handle different domains concurrently
- **Tmux worktrees** enable parallel branch development
- **FZF pickers** provide instant context switching
- **Git + AI integration** processes multiple operations simultaneously
- **Neovim + Claude** maintains parallel context streams

Every tool is designed to maximize throughput, minimize wait times, and enable true parallel development workflows.

---

## Parallel Git Workflows with AI Integration

### AI-Powered Commit Generation

Instead of manually crafting commit messages, leverage AI to generate them while you continue coding:

```bash
# Location: git-commands/git-ai-commit
# Automatically stages changes and generates commit message
git ai-commit

# Location: git-commands/git-ai-commit-staged  
# Generates commit for already staged changes
git ai-commit-staged
```

**Parallel Pattern**: While AI generates the commit message, you can:
- Continue editing files in another tmux window
- Review other changes in parallel
- Start the next feature in a different worktree

### Git + Claude Helper Functions

```bash
# Location: bash_functions/claude-functions.bash
run_claude() {
    local prompt="$1"
    local output_format="${2:-text}"
    local allowed_tools="${3:-}"
    
    # Execute Claude with specific constraints
    claude -p "$prompt" --output-format "$output_format" --allowedTools "$allowed_tools"
}
```

**Usage Pattern**: Run multiple git operations in parallel:
```bash
# Terminal 1: AI analyzes the diff
run_claude "analyze this git diff for potential issues" &

# Terminal 2: Continue development
git checkout -b feature/new-feature

# Terminal 3: AI generates documentation
run_claude "create documentation for these changes" &
```

---

## Neovim Claude Integration for Parallel Context Management

### Core Claude Code Integration

```lua
-- Location: lua/plugins/claude-code.lua
-- Key bindings for parallel AI operations
```

**Primary Keybindings for Parallel Workflows:**

```vim
<leader>cc    " Toggle Claude Code interface
<leader>cf    " Focus Claude Code panel
<leader>cb    " Add current buffer to Claude context
<leader>cs    " Send visual selection to Claude (parallel analysis)
<leader>ca    " Accept Claude diff
<leader>cd    " Deny Claude diff
```

### Git + Claude Unified Workflow

**Parallel Hunk Processing:**
```vim
<leader>ga    " Add current hunk to Claude context
<leader>gA    " Add entire buffer to Claude context  
<leader>gi    " Send hunk to Claude for explanation
<leader>gI    " Send entire diff to Claude for review
```

**Parallel Pattern Example:**
1. `<leader>ga` - Send current hunk to Claude for review
2. `]h` - Jump to next hunk while Claude analyzes the first
3. `<leader>ga` - Send second hunk to Claude 
4. Continue editing while Claude processes both hunks in parallel

### Multi-Buffer Parallel Analysis

```vim
" Send multiple buffers to Claude simultaneously
:ClaudeCodeAdd file1.js
:ClaudeCodeAdd file2.ts  
:ClaudeCodeAdd file3.py

" Now Claude has context of all three files for parallel analysis
```

---

## Specialized AI Agents for Domain Parallelism

The system includes specialized agents that can run concurrently, each handling different aspects of your workflow:

### Agent Ecosystem

**Location: `claude-global-settings/agents/`**

1. **vim-expert.md** - Advanced editor optimization and guidance
2. **backstage-expert.md** - Service discovery and component management
3. **jira-expert.md** - Sprint planning and issue management  
4. **github-expert.md** - Repository and PR workflows
5. **code-search-expert.md** - Advanced pattern searching
6. **flow-master.md** - Cross-platform workflow orchestration
7. **slack-expert.md** - Team communication automation

### Parallel Agent Usage Pattern

Instead of using one agent at a time, leverage multiple agents concurrently:

```bash
# Terminal 1: Vim expert optimizes your editor config
/vim-expert "optimize my keybindings for speed"

# Terminal 2: Code search expert finds patterns
/code-search "find all TODO comments across the codebase"

# Terminal 3: GitHub expert analyzes PR status
/github-expert "show all PRs waiting for my review"

# Terminal 4: Continue coding while agents work
```

### Agent Specialization Benefits

- **Context Switching Cost**: Zero - each agent maintains its domain expertise
- **Parallel Processing**: Multiple cognitive tasks handled simultaneously
- **Expertise Depth**: Domain-specific knowledge without generalist dilution
- **Workflow Continuity**: Never blocked waiting for AI analysis

---

## Tmux Worktree System for Parallel Development

### Core Worktree Functions

**Location: `bash_functions/tmux-worktree.bash`**

```bash
twc feature-auth    # Create worktree + tmux window
tws feature-auth    # Switch to worktree window  
twd feature-auth    # Delete worktree + window
twl                 # List worktrees with tmux status
twsync              # Sync tmux windows with worktrees
twi                 # Interactive FZF worktree switcher
```

### Parallel Development Architecture

**Core Concept:**
- **Tmux Sessions** = Git repositories/projects
- **Tmux Windows** = Git worktrees (branches)  
- **Navigation** = Alt+1-9 for instant switching

### Maximum Parallel Workflow

```bash
# Set up parallel development streams
twc feature-auth        # Window 1: Authentication feature
twc feature-payments    # Window 2: Payment system
twc bugfix-login       # Window 3: Login bug fix
twc docs-update        # Window 4: Documentation

# Now work on all four streams in parallel:
# Alt+1: Write auth code
# Alt+2: Design payment flow  
# Alt+3: Debug login issue
# Alt+4: Update docs

# AI assists all streams simultaneously
```

### Worktree Benefits for Parallel Compute

1. **Zero Switch Cost**: Instant branch switching via Alt+number
2. **Persistent Context**: Each worktree maintains its state
3. **Parallel Testing**: Run tests in one worktree while coding in another
4. **AI Context Preservation**: Claude maintains separate context per worktree

---

## FZF Pickers for Instant Parallel Selection

### Neovim FZF Integration

**Location: `lua/plugins/fzf-pickers/tmux.lua`**

```lua
-- Tmux window picker
function M.tmux_windows()
    -- Instantly switch between tmux windows with preview
end

-- Tmux session picker  
function M.tmux_sessions()
    -- Switch between different projects/repositories
end

-- Code project picker
function M.code_projects()
    -- Instantly jump to any project in ~/code/
    -- Creates tmux session if needed
end
```

### Bash FZF Functions

**Location: `bash_functions/fzf-functions.bash`**

```bash
# Git operations with FZF
fgb    # Pick git branch
fgl    # Pick from git log
fgf    # Pick git file

# System operations
fkill  # Pick process to kill
fcd    # Pick directory to navigate
fgrep  # Pick from grep results with context

# Tmux operations  
ft     # Pick tmux session
```

### Parallel Selection Patterns

**Multi-Selection for Batch Operations:**
```bash
# Select multiple files for batch processing
git ls-files | fzf -m | xargs -I {} claude "analyze {}"

# Select multiple tmux sessions for parallel monitoring
tmux list-sessions | fzf -m | while read session; do
    tmux capture-pane -t "$session" -p > "log_$session.txt" &
done
```

**Instant Context Switching:**
```bash
# Jump between projects while maintaining parallel AI contexts
<leader>cp    # Code project picker
# AI continues processing in background across all projects
```

---

## Slash Commands for Parallel Analysis

### Available Commands

**Location: `claude-global-settings/commands/`**

1. **`/catch-me-up`** - Comprehensive repository analysis
2. **`/create-pr-jira`** - Automated PR creation with ticket sync
3. **`/explain-hunk`** - Code change explanation
4. **`/sync-approved-prs`** - PR synchronization automation
5. **`/team-update`** - Aggregate team status generation

### Parallel Command Execution

**Morning Standup Automation:**
```bash
# Run all status commands in parallel
/catch-me-up &           # Analyze current repository state
/sync-approved-prs &     # Check PR status across projects  
/team-update &           # Generate team status summary

# Continue working while commands execute
nvim src/main.py
```

**Code Review Workflow:**
```bash
# Parallel review process
/explain-hunk &          # AI explains current changes
/create-pr-jira &        # Auto-generate PR with ticket link

# Review continues while AI processes
git diff HEAD~1..HEAD    # Review changes manually
```

---

## Real-World Parallel Workflow Patterns

### Morning Synchronization Ritual

```bash
# 1. Parallel project status (runs in background)
for project in ~/code/*; do
    (cd "$project" && /catch-me-up > "status_$(basename $project).txt") &
done

# 2. While status checks run, start coding immediately
t main-project           # Jump to primary project
nvim                     # Start editing

# 3. AI processes all project statuses while you code
# 4. Review aggregated status when convenient
```

### Feature Development Cycle

```bash
# 1. Create parallel development streams
twc feature-frontend     # Frontend changes
twc feature-backend      # Backend changes  
twc feature-tests        # Test updates

# 2. Parallel AI assistance
# Alt+1: Frontend - Claude reviews React components
# Alt+2: Backend - Claude analyzes API design
# Alt+3: Tests - Claude generates test cases

# 3. All streams progress simultaneously
# No waiting, no blocking, maximum throughput
```

### Code Review Parallelization

```bash
# 1. Review multiple PRs simultaneously
gh pr list | head -5 | while read pr; do
    (gh pr view "$pr" | claude "review this PR") &
done

# 2. Continue development while reviews process
git checkout feature-branch
nvim src/new-feature.js

# 3. AI completes all reviews in parallel
# 4. Batch process review feedback
```

### Debugging Session Optimization

```bash
# 1. Parallel log analysis
tail -f app.log | claude "find error patterns" &
tail -f database.log | claude "analyze slow queries" &

# 2. Code investigation while logs process
rg "ERROR" --type js | claude "explain these errors" &

# 3. Continue debugging while AI processes all logs
nvim src/problematic-module.js
```

### Multi-Project Management

```bash
# 1. Set up project sessions in parallel
for project in frontend backend mobile; do
    t "$project" &         # Create tmux session
done

# 2. Parallel AI monitoring
for project in frontend backend mobile; do
    (cd ~/code/$project && /catch-me-up) &
done

# 3. Instant switching between projects
# Alt+s -> project picker
# Zero context loss, AI maintains all project states
```

---

## Performance Optimizations for Maximum Parallel Compute

### Neovim Performance

```lua
-- Lazy loading for instant startup
-- Location: lua/plugins/
-- All plugins load only when needed
-- Sub-100ms startup time enables rapid context switching
```

### Tmux Optimization

```bash
# Persistent sessions maintain context
# No repeated startup costs
# Background processes continue running
# Alt+number shortcuts for zero-friction navigation
```

### Git Worktree Efficiency

```bash
# .worktrees/ directory structure
# Separate working directories per branch
# No git checkout delays
# Parallel git operations across worktrees
```

### AI Context Management

```bash
# Multiple Claude contexts maintained simultaneously
# Each tmux window can have independent AI assistance
# Background AI processing while you continue coding
# Parallel analysis of multiple code sections
```

---

## Practical Examples: 10x Developer Workflows

### Example 1: Review 10 PRs in Parallel

```bash
# 1. Get PR list and start parallel reviews
gh pr list --limit 10 | while read pr; do
    echo "Reviewing $pr" 
    (gh pr view "$pr" --json body,title,files | 
     claude "comprehensive code review") > "review_$pr.md" &
done

# 2. Continue feature development while reviews run
nvim src/my-feature.js

# 3. All 10 reviews complete in parallel
# Time: 2 minutes instead of 20 minutes serial
```

### Example 2: Documentation Generation While Coding

```bash
# 1. Start documentation generation in background
find src/ -name "*.js" | xargs -I {} claude "generate JSDoc for {}" &

# 2. Continue coding immediately  
nvim src/new-module.js

# 3. AI generates docs for entire codebase while you code
# No interruption to development flow
```

### Example 3: Test Suite + Development Parallel Flow

```bash
# 1. Continuous test running in background
twc feature-development    # Main development window
twc test-runner           # Test execution window

# Alt+1: Write code
# Alt+2: Monitor tests (auto-running)
# AI provides feedback on both streams simultaneously
```

### Example 4: Multi-Repository Dependency Analysis

```bash
# 1. Analyze dependencies across all repositories
for repo in ~/code/*; do
    (cd "$repo" && 
     claude "analyze dependencies and suggest updates") > "deps_$(basename $repo).md" &
done

# 2. Continue primary development
# 3. Review all dependency analyses when complete
# Parallel execution instead of serial waiting
```

---

## Key Performance Metrics

**Traditional Serial Workflow:**
- PR Review: 20 minutes for 10 PRs (2 min each)
- Code Analysis: 30 minutes for 10 files (3 min each)  
- Documentation: 60 minutes for project (1 hour total)

**Parallel AI Workflow:**
- PR Review: 2 minutes for 10 PRs (all parallel)
- Code Analysis: 3 minutes for 10 files (all parallel)
- Documentation: 5 minutes for project (background generation)

**Result: 10x throughput improvement through parallelization**

---

## Philosophy in Practice

This workflow embodies the principle that **AI's computational capacity should be maximized, not under-utilized**. Every tool, keybinding, and process is designed to:

1. **Eliminate Wait Times**: Never block on AI responses
2. **Maximize Parallel Streams**: Run multiple AI contexts simultaneously  
3. **Preserve Context**: Maintain multiple development streams without loss
4. **Enable Flow State**: Remove friction from context switching
5. **Amplify Human Cognition**: Let AI handle routine analysis while you create

The result is a development environment where **human creativity is amplified by parallel AI compute**, creating a multiplicative effect rather than just additive assistance.