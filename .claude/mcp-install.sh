#!/bin/bash

# MCP Server Installation Script for Claude Code
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing MCP servers for Claude Code...${NC}"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo -e "${YELLOW}npm not found. Installing via mise...${NC}"
    if command -v mise &> /dev/null; then
        mise install node@20
        eval "$(mise activate bash)"
    else
        echo -e "${RED}Error: mise not found. Please install mise first.${NC}"
        exit 1
    fi
fi

# Install MCP servers globally
echo -e "${YELLOW}Installing MCP servers...${NC}"

# Core servers for development
echo -e "${BLUE}Installing filesystem server...${NC}"
npm install -g @modelcontextprotocol/server-filesystem

echo -e "${BLUE}Installing git server...${NC}"
npm install -g @modelcontextprotocol/server-git

echo -e "${BLUE}Installing bash server...${NC}"
npm install -g @modelcontextprotocol/server-bash

echo -e "${BLUE}Installing SQLite server...${NC}"
npm install -g @modelcontextprotocol/server-sqlite

echo -e "${BLUE}Installing PostgreSQL server...${NC}"
npm install -g @modelcontextprotocol/server-postgres

# Optional servers (comment out if not needed)
echo -e "${BLUE}Installing Brave Search server...${NC}"
npm install -g @modelcontextprotocol/server-brave-search

echo -e "${BLUE}Installing GitHub server...${NC}"
npm install -g @modelcontextprotocol/server-github

echo -e "${BLUE}Installing Slack server...${NC}"
npm install -g @modelcontextprotocol/server-slack

echo -e "${BLUE}Installing Playwright server...${NC}"
npm install -g @playwright/mcp

echo -e "${YELLOW}Installing Playwright browsers and dependencies...${NC}"
npx playwright install
echo -e "${YELLOW}Installing system dependencies for Playwright...${NC}"
if command -v sudo > /dev/null; then
    sudo npx playwright install-deps || echo -e "${YELLOW}Note: Some system dependencies may require manual installation${NC}"
else
    echo -e "${YELLOW}Note: sudo not available. You may need to install system dependencies manually:${NC}"
    echo "  sudo apt-get install libevent-2.1-7t64 libavif16"
fi

echo -e "${GREEN}✓ MCP servers installed successfully!${NC}"

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Configure API keys in ~/.claude/.mcp.json if needed"
echo "2. Update server paths in .mcp.json to match your setup"
echo "3. Run 'claude mcp list' to verify servers are recognized"

echo -e "${BLUE}Available MCP servers:${NC}"
echo "- filesystem: Access local files and directories"
echo "- git: Git repository operations" 
echo "- bash: Execute bash commands"
echo "- sqlite: SQLite database operations"
echo "- postgres: PostgreSQL database operations"
echo "- brave-search: Web search via Brave API"
echo "- github: GitHub repository operations"
echo "- slack: Slack workspace integration"
echo "- playwright: Browser automation and web interaction"