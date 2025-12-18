# dev-browser Skill for Claude Code

A lightweight browser automation skill for Claude Code that **only loads when invoked** - no context bloat.

Based on [Sawyer Hood's dev-browser](https://github.com/SawyerHood/dev-browser) project.

## Why This Over MCP?

| Approach | Context Impact | Always Running? |
|----------|----------------|-----------------|
| Chrome DevTools MCP | Heavy (screenshots, DOM) | Yes |
| Playwright MCP | Medium | Yes |
| **dev-browser skill** | **None until invoked** | **No** |

Skills are on-demand - they only load into context when you trigger them. MCP servers add tool definitions to every request.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dev-browser-skill-installer/main/install.sh | bash
```

Or manually:

```bash
# 1. Install bun (if not installed)
curl -fsSL https://bun.sh/install | bash

# 2. Clone and set up
git clone --depth 1 https://github.com/SawyerHood/dev-browser /tmp/dev-browser
mkdir -p ~/.claude/skills
mv /tmp/dev-browser/skills/dev-browser ~/.claude/skills/dev-browser
rm -rf /tmp/dev-browser

# 3. Install dependencies
cd ~/.claude/skills/dev-browser
bun install
bunx playwright install chromium

# 4. Restart Claude Code
```

## Usage

### When to use browser automation

**Skip it for:**
- Checking if server is running (`curl localhost:3000`)
- Verifying API responses
- Checking static HTML content

**Use it for:**
- Testing interactive flows (clicks, forms, navigation)
- Verifying client-side JavaScript behavior
- Testing auth flows / cookies / sessions
- Taking screenshots for visual verification

### Starting the browser server

When you need browser automation:

```bash
cd ~/.claude/skills/dev-browser && ./server.sh &
```

Wait for the "Ready" message before running scripts.

### Trigger phrases

The skill activates when you say things like:
- "go to localhost:3000"
- "click on the login button"
- "fill out the form"
- "take a screenshot"
- "test the website"

### Example workflow

```
You: Start the dev browser and go to localhost:9191

Claude: [Starts server, navigates to URL, reports what it sees]

You: Click on the "Users" link

Claude: [Clicks, reports new page state]

You: Take a screenshot

Claude: [Saves screenshot to tmp/screenshot.png]
```

## How it works

1. **Server** launches a persistent Chromium browser
2. **Pages persist** between script executions (cookies, localStorage, DOM state)
3. **ARIA snapshots** provide LLM-friendly element discovery (no screenshots needed for navigation)
4. **Disconnect without losing state** - pages survive client disconnections

## Headless mode

For CI or when you don't need to see the browser:

```bash
cd ~/.claude/skills/dev-browser && ./server.sh --headless &
```

## Troubleshooting

### "Cannot find package '@/client.js'"

Scripts must run from the skill directory:
```bash
cd ~/.claude/skills/dev-browser && bun x tsx your-script.ts
```

### Server won't start

Check if port 9222 is in use:
```bash
lsof -i :9222
```

Kill any existing process and retry.

### Chromium not found

Re-run the Playwright install:
```bash
cd ~/.claude/skills/dev-browser && bunx playwright install chromium
```

## Credits

- Original project: [SawyerHood/dev-browser](https://github.com/SawyerHood/dev-browser)
- License: MIT
