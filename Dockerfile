FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    WORKSPACE=/workspace

# Install system dependencies and tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ripgrep \
    fd-find \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . $HOME/.cargo/env \
    && echo 'source $HOME/.cargo/env' >> ~/.bashrc

ENV PATH="/root/.cargo/bin:${PATH}"

# Install sd (search and replace tool) via cargo
RUN cargo install sd

# Install Node.js (required for some CLI tools)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Python and pip (required for some tools)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.cargo/bin/uv /usr/local/bin/ \
    && mv /root/.cargo/bin/uvx /usr/local/bin/

# Install AI CLI tools via npm
RUN npm install -g @google/gemini-cli@nightly \
    @anthropic-ai/claude-code \
    @charmland/crush \
    opencode-ai

# Create workspace directory
RUN mkdir -p ${WORKSPACE}

# Set working directory
WORKDIR ${WORKSPACE}

# Default command
CMD ["/bin/bash"]
