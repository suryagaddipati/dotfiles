#!/bin/bash

# Check if there are staged changes
if ! git diff --cached --quiet; then
    # Get the staged diff
    staged_diff=$(git diff --cached)
    
    # Generate commit message using Claude
    echo "Generating commit message..."
    commit_msg=$(echo "$staged_diff" | ~/.claude/local/claude -p "Look at these staged git changes and create a summarizing git commit title in conventional git commit format. Only respond with the title and no affirmation.")
    
    # Commit with the generated message
    git commit -m "$commit_msg"
    echo "Committed with message: $commit_msg"
else
    echo "No staged changes to commit"
fi
