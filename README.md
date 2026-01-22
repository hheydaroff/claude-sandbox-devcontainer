# Claude Code Sandbox DevContainer

A ready-to-use VS Code DevContainer for running [Claude Code](https://claude.ai/code) in an isolated, sandboxed environment.

## Features

- **Isolated execution** — Claude runs inside a container, can't access your host filesystem
- **Multiple auth methods** — Supports Claude subscription, Anthropic API key, or AWS Bedrock
- **Docker-in-Docker** — Claude can run Docker commands (auto-detected)
- **GitHub CLI included** — Easy Git authentication with `gh auth login`
- **Configurable** — Save preferences, override per-project with CLI flags

## Quick Start

### 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/hheydaroff/claude-sandbox-devcontainer/main/install.sh | bash
```

The installer will ask you:
- **Authentication method**: Claude subscription, Anthropic API key, or AWS Bedrock
- **AWS region** (if using Bedrock)

Your choices are saved to `~/.config/claude-sandbox/config` for future use.

### 2. Initialize a project

```bash
cd /path/to/your/project
claude-sandbox
```

### 3. Open in VS Code

1. Open your project folder in VS Code
2. `Cmd+Shift+P` → "Dev Containers: Reopen in Container"
3. Wait for container to build

### 4. Authenticate and run Claude

Depending on your auth method:

**Claude Pro/Max subscription:**
```bash
claude login
clauded
```

**Anthropic API key:**
```bash
export ANTHROPIC_API_KEY="your-key"
clauded
```

**AWS Bedrock:**
```bash
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
clauded
```

## CLI Options

```bash
claude-sandbox [options]

Options:
  -f, --force        Overwrite existing .devcontainer
  -o, --open         Open in VS Code after setup
  -p, --provider     Auth provider: subscription, api-key, bedrock
  -r, --region       AWS region (for Bedrock)
  -m, --mount        Add extra mount path (can be used multiple times)
  --no-docker        Disable Docker socket mount
  --reconfigure      Re-run configuration prompts
  -h, --help         Show help
```

### Examples

```bash
# Use saved defaults
claude-sandbox

# Override auth method for this project
claude-sandbox --provider subscription

# Use Bedrock with specific region
claude-sandbox --provider bedrock --region eu-central-1

# Add extra folder mount
claude-sandbox --mount /path/to/shared/data

# Disable Docker access
claude-sandbox --no-docker

# Change saved settings
claude-sandbox --reconfigure
```

## Configuration

Settings are stored in `~/.config/claude-sandbox/config`:

```bash
CLAUDE_PROVIDER=subscription  # or api-key, bedrock
AWS_REGION=us-east-1          # only for bedrock
DOCKER_ENABLED=true           # auto-detected
```

## What's Generated

The `claude-sandbox` command creates a `.devcontainer/` folder with:

```
.devcontainer/
├── devcontainer.json      # VS Code container configuration
├── Dockerfile             # Ubuntu 22.04 + Node.js 20 + Docker CLI + GitHub CLI
└── claude-settings.json   # Claude settings (Bedrock only)
```

## Git Authentication

Use GitHub CLI for easy HTTPS authentication:

```bash
# One-time setup inside container
gh auth login
# Select: GitHub.com → HTTPS → Login with a web browser

# Then git commands just work
git push origin main
```

## SSH Access (Optional)

The template does **not** mount SSH keys for security reasons — private keys could be exfiltrated if prompt injection succeeds. If you need git-over-SSH, use agent forwarding instead:

1. Ensure SSH agent is running on host: `ssh-add -l`
2. Add to `.devcontainer/devcontainer.json`:

```json
"mounts": [
  "source=${localEnv:SSH_AUTH_SOCK},target=/ssh-agent,type=bind"
],
"containerEnv": {
  "SSH_AUTH_SOCK": "/ssh-agent"
}
```

## MCP Integrations

To add MCP servers (Atlassian, GitHub, etc.), run inside the container:

```bash
# Atlassian (Jira/Confluence)
claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/mcp

# See available MCPs
claude mcp list
```

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
│  │  ✅ Docker socket (if enabled)    │  │
│  │  ✅ Git config (read-only)        │  │
│  │  ✅ Extra mounts (if specified)   │  │
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
- One of:
  - Claude Pro/Max subscription
  - Anthropic API key
  - AWS account with Bedrock access

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

### Authentication errors

**Subscription:** Run `claude login` and follow the prompts.

**API Key:** Make sure you've exported:
```bash
export ANTHROPIC_API_KEY="your-key"
```

**Bedrock:** Make sure you've exported both:
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
```

## License

MIT License - See [LICENSE](LICENSE)

## Contributing

Contributions welcome! Please open an issue or PR.
