# Dotfiles Philosophy

Optimized configuration for bash, git, tmux, and neovim based on systematic design principles.

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
just full-install    # Complete setup with dependencies
```

## Shortcut Philosophy

Instead of memorizing individual shortcuts, understand the underlying system:

### **Spatial Logic**
Everything uses **vim-style directional movement**:
- `h` = left
- `j` = down  
- `k` = up
- `l` = right

This works the same in tmux panes, neovim splits, and bash vi-mode.

### **Immediacy Principle**
More frequent actions = fewer keystrokes:
```
Alt+key         # Instant (no prefix) - most frequent
Ctrl+key        # Common operations  
,key            # Editor actions (leader comma)
Prefix+key      # Complex operations (Ctrl-Space in tmux)
```

### **Four Mental Models**

#### **1. Navigate** (Move between contexts)
```
Alt+h/j/k/l     # Tmux panes (instant)
Ctrl+h/j/k/l    # Neovim splits
Alt+1-9         # Tmux windows (instant)
Tab/Shift+Tab   # Neovim buffers
```

#### **2. Manipulate** (Create/change/destroy)
```
# Split contexts:
Ctrl-Space s/v  # Tmux split horizontal/vertical
# Manage contexts:
Ctrl-Space x    # Kill tmux pane
,bd             # Delete neovim buffer
```

#### **3. Find** (Search and discover)
```
,f              # Find files
,g              # Grep text
,b              # Find buffers
,h              # Recent files
grp pattern ext # Multi-extension search (bash)
```

#### **4. Execute** (Run actions)
```
,w              # Save
,q              # Quit
t session       # Smart tmux session
g status        # Git status
```

### **Pattern Recognition**

Once you understand the patterns, you can predict shortcuts:
- **Alt+** = "I want this NOW" (no prefix needed)
- **h/j/k/l** = "directional movement" (works everywhere)  
- **,** = "editor action" (only in neovim)
- **Ctrl-Space** = "complex tmux operation"

## Essential Commands

```bash
just install        # Install dotfiles with backup
just status         # Check installation status  
just backup         # Backup existing configs
just update         # Update from git
```

## Core Tools Integration

### **Terminal (Bash)**
```bash
g                   # git
t [session]         # smart tmux session
ll                  # detailed listing
grp pattern ext     # multi-extension search
```

### **Session Manager (Tmux)**
```bash
# Prefix: Ctrl-Space
# Navigate: Alt+h/j/k/l (instant)
# Windows: Alt+1-9 (instant)
# Sessions: Alt+s (instant)
```

### **Editor (Neovim)**
```bash
# Leader: ,
# Navigate: Ctrl+h/j/k/l
# Buffers: Tab/Shift+Tab
# Files: ,f ,g ,b ,h ,t
# Actions: ,w ,q ,ac
```

## Requirements

```bash
sudo apt install git tmux neovim curl fzf ripgrep xclip
```

For implementation details see [CLAUDE.md](CLAUDE.md).