# Claude Code Sandbox DevContainer

A ready-to-use VS Code DevContainer for running [Claude Code](https://claude.ai/code) in an isolated, sandboxed environment.

## Features

- **Isolated execution** — Claude runs inside a container, can't access your host filesystem
- **AWS Bedrock support** — Pre-configured for EU region (eu-central-1)
- **Atlassian MCP** — Jira/Confluence integration auto-configured
- **Docker-in-Docker** — Claude can run Docker commands via socket mount
- **GitHub CLI included** — Easy Git authentication with `gh auth login`
- **One-command setup** — `clauded` alias for `--dangerously-skip-permissions`

## Quick Start

### Option 1: Use the install script

```bash
# Install the template and CLI tool
curl -fsSL https://raw.githubusercontent.com/hheydaroff/claude-sandbox-devcontainer/main/install.sh | bash

# Then in any project folder
cd /path/to/your/project
claude-sandbox
```

### Option 2: Manual setup

Copy the `.devcontainer/` folder to your project:

```bash
git clone https://github.com/hheydaroff/claude-sandbox-devcontainer.git
cp -r claude-sandbox-devcontainer/.devcontainer /path/to/your/project/
```

### Open in VS Code

1. Open your project folder in VS Code
2. `Cmd+Shift+P` → "Dev Containers: Reopen in Container"
3. Wait for container to build

### Run Claude

```bash
# Set AWS credentials (required for Bedrock)
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

# Run Claude with full permissions
clauded
```

## What's Included

```
.devcontainer/
├── devcontainer.json      # VS Code container configuration
├── Dockerfile             # Ubuntu 22.04 + Node.js 20 + Docker CLI + GitHub CLI
└── claude-settings.json   # Claude Code Bedrock configuration
```

**Container includes:** curl, git, python3, Node.js 20, Docker CLI, GitHub CLI (gh)

## Configuration

### AWS Bedrock Models (Default)

| Model | ID |
|-------|-----|
| Opus 4.5 | `eu.anthropic.claude-opus-4-5-20251101-v1:0` |
| Sonnet 4.5 | `eu.anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Haiku 4.5 | `eu.anthropic.claude-haiku-4-5-20251001-v1:0` |

### Customizing

Edit `.devcontainer/claude-settings.json` to change:
- AWS region
- Default models
- Add custom environment variables

Edit `.devcontainer/devcontainer.json` to:
- Add VS Code extensions
- Mount additional directories
- Change container environment

### Git Authentication

Use GitHub CLI for easy HTTPS authentication (recommended):

```bash
# One-time setup inside container
gh auth login
# Select: GitHub.com → HTTPS → Login with a web browser

# Then git commands just work
git push origin main  # No password prompts!
```

### SSH Access (Optional)

The template does **not** mount SSH keys for security reasons — private keys could be exfiltrated if prompt injection succeeds. If you need git-over-SSH, use agent forwarding instead:

1. Ensure SSH agent is running on host: `ssh-add -l`
2. Add to `.devcontainer/devcontainer.json`:

```json
"mounts": [
  // ... existing mounts ...
  "source=${localEnv:SSH_AUTH_SOCK},target=/ssh-agent,type=bind"
],
"containerEnv": {
  // ... existing env vars ...
  "SSH_AUTH_SOCK": "/ssh-agent"
}
```

This forwards signing requests to your host agent without exposing key files to the container.

## Security Model

```
┌─────────────────────────────────────────┐
│  Your Host Machine                      │
│  ┌───────────────────────────────────┐  │
│  │  DevContainer (Isolated)          │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Claude Code                │  │  │
│  │  │  --dangerously-skip-perms   │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  Can access:                      │  │
│  │  ✅ /workspace (your project)     │  │
│  │  ✅ Docker socket                 │  │
│  │  ✅ Git config (read-only)        │  │
│  │                                   │  │
│  │  Cannot access:                   │  │
│  │  ❌ Rest of host filesystem       │  │
│  │  ❌ Host processes                │  │
│  │  ❌ Other containers              │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) 4.x+
- [VS Code](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- AWS account with Bedrock access (for Claude API)

## Troubleshooting

### "claude: not found"
The PATH wasn't set correctly. Run:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Container won't start
Ensure Docker Desktop is running:
```bash
open -a Docker  # macOS
```

### AWS credentials error
Make sure you've exported both:
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
```

## License

MIT License - See [LICENSE](LICENSE)

## Contributing

Contributions welcome! Please open an issue or PR.
