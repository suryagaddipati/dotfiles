#!/bin/bash

# Linux-specific PATH additions
if [ -d "$HOME/code/duckdb/build/release" ]; then
    export PATH="$HOME/code/duckdb/build/release:$PATH"
fi
