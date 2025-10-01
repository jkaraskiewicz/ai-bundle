# AI Development Environment

A containerized development environment for AI experimentation with modern CLI tools, language support, and pre-configured workflows.

## Features

- **Search & Replace Tools**: ripgrep, fd-find, sd
- **AI CLI Tools**: gemini-cli, claude-code, crush, opencode
- **Languages**: Python (with uv/uvx), Rust/Cargo, Kotlin, Gradle
- **Editor**: Neovim with custom config from [dot-configs](https://github.com/jkaraskiewicz/dot-configs)
- **Shell**: Zsh with zprezto
- **Security**: Non-root user (aidev) with passwordless sudo
- **Persistence**: Mounted workspace, home directory, gitconfig, and SSH keys

## Quick Start

```bash
# Clone the repository
git clone https://github.com/jkaraskiewicz/ai-bundle.git
cd ai-bundle

# Copy environment template (optional)
cp .env.example .env
# Add your API keys if needed

# Start the container
docker-compose up -d

# Access the environment
docker-compose exec ai-dev zsh
```

## Pre-built Images

Images are automatically built on every commit via GitHub Actions and published to:
```
ghcr.io/jkaraskiewicz/ai-bundle:master
```

To use the pre-built image, simply run `docker-compose up -d` without building locally.

## Volume Mounts

- `./workspace` → `/workspace` - Your project files
- `./home` → `/home/aidev` - User home directory (persists tool configs)
- `./.gitconfig.template` → `~/.gitconfig` (read-only)
- `~/.ssh` → `~/.ssh` (read-only) - SSH keys for git operations

## Tools Installed

| Category | Tools |
|----------|-------|
| Search | ripgrep, fd-find, sd |
| AI CLI | @google/gemini-cli, @anthropic-ai/claude-code, @charmland/crush, opencode-ai |
| Languages | Python 3 + uv, Rust + Cargo, Kotlin, Gradle |
| Editor | Neovim |
| Shell | Zsh + zprezto |

## License

MIT
