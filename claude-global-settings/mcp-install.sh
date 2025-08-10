#!/bin/bash

npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-bash
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-brave-search
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-slack
npm install -g @playwright/mcp

npx playwright install
sudo npx playwright install-deps 2>/dev/null || true