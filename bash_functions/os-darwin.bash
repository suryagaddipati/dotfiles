#!/bin/bash

# macOS-specific PATH additions
export PATH="$PATH:/opt/homebrew/bin"

if [ -d "$HOME/Library/Application Support/Coursier/bin" ]; then
    export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
fi
