# Local Installation Design

## Problem

The original installation method used `curl | bash` to download scripts from GitHub. This had two issues:

1. **Security** - Running scripts from the internet is risky
2. **Updates** - Required re-running curl to get updates

## Solution

Switch to a local clone + symlink approach:

```bash
git clone https://github.com/hheydaroff/claude-sandbox-devcontainer.git ~/claude-sandbox
cd ~/claude-sandbox
./install.sh        # or: npm link
```

Updates become a simple `git pull`.

## Design Decisions

### Self-Locating CLI

The `claude-sandbox` script now finds its Dockerfile relative to its own location:

```bash
SCRIPT_PATH="$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
TEMPLATE_DIR="$SCRIPT_DIR/.devcontainer"
```

This works because:
1. User runs `claude-sandbox` from anywhere
2. Shell follows symlink `~/.local/bin/claude-sandbox` → `~/claude-sandbox/claude-sandbox`
3. CLI finds Dockerfile at `~/claude-sandbox/.devcontainer/Dockerfile`

### Two Installation Methods

**Shell script (install.sh):**
- Creates symlink: `~/.local/bin/claude-sandbox` → `<repo>/claude-sandbox`
- No dependencies beyond bash

**npm (npm link):**
- Standard npm approach for Node.js users
- Same symlink behavior

Both methods result in `git pull` updating everything automatically.

### Removed Components

| Component | Reason |
|-----------|--------|
| `~/.config/devcontainer-templates/` | No longer needed - Dockerfile lives in repo |
| `scripts/setup.js` | No longer needed - no postinstall copying |
| GitHub curl download | Security concern - now uses local clone |

## File Changes

| File | Change |
|------|--------|
| `claude-sandbox` | Added self-locating logic (lines 17-20) |
| `install.sh` | Rewritten as simple symlink installer |
| `package.json` | Removed postinstall script |
| `scripts/setup.js` | Deleted |

## Usage

**Installation:**
```bash
git clone https://github.com/hheydaroff/claude-sandbox-devcontainer.git ~/claude-sandbox
cd ~/claude-sandbox
./install.sh
```

**Usage:**
```bash
cd /any/project
claude-sandbox              # Initialize devcontainer
claude-sandbox -o           # Initialize and open VS Code
claude-sandbox --help       # Show options
```

**Update:**
```bash
cd ~/claude-sandbox && git pull
```

**Uninstall:**
```bash
rm ~/.local/bin/claude-sandbox
rm -rf ~/claude-sandbox
```
