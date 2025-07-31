#!/bin/bash

if ! git diff --cached --quiet; then
    staged_diff=$(git diff --cached)
    commit_msg=$(echo "$staged_diff" | ~/.claude/local/claude -p "Look at these staged git changes and create a summarizing git commit title in conventional git commit format. Only respond with the title and no affirmation.")
    git commit -m "$commit_msg"
    echo "Committed with message: $commit_msg"
else
    echo "No staged changes to commit"
fi
