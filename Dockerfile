FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    WORKSPACE=/workspace \
    USER=aidev \
    UID=1001 \
    GID=1001

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
    zip \
    zsh \
    neovim \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (required for some CLI tools) - needs root
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Python, Gradle, and Kotlin - needs root
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    gradle \
    kotlin \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -g ${GID} ${USER} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/zsh ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

# Switch to non-root user for installations
USER ${USER}
WORKDIR /home/${USER}

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/${USER}/.cargo/bin:${PATH}"

# Install sd (search and replace tool) via cargo
RUN cargo install sd

# Install zprezto
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git /home/${USER}/.zprezto \
    && rm -f /home/${USER}/.zshenv /home/${USER}/.zshrc \
    && ln -s /home/${USER}/.zprezto/runcoms/zlogin /home/${USER}/.zlogin \
    && ln -s /home/${USER}/.zprezto/runcoms/zlogout /home/${USER}/.zlogout \
    && ln -s /home/${USER}/.zprezto/runcoms/zpreztorc /home/${USER}/.zpreztorc \
    && ln -s /home/${USER}/.zprezto/runcoms/zprofile /home/${USER}/.zprofile \
    && ln -s /home/${USER}/.zprezto/runcoms/zshenv /home/${USER}/.zshenv \
    && ln -s /home/${USER}/.zprezto/runcoms/zshrc /home/${USER}/.zshrc

# Install uv (fast Python package installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install AI CLI tools via npm (requires sudo for global install)
RUN sudo npm install -g @google/gemini-cli@nightly \
    @anthropic-ai/claude-code \
    @charmland/crush \
    opencode-ai

# Clone neovim config from dot-configs repo
RUN git clone https://github.com/jkaraskiewicz/dot-configs.git /home/${USER}/.dot-configs \
    && mkdir -p /home/${USER}/.config \
    && ln -s /home/${USER}/.dot-configs/neovim/dot_config/nvim /home/${USER}/.config/nvim

# Create workspace directory (requires sudo as it's at root level)
RUN sudo mkdir -p ${WORKSPACE} && sudo chown ${USER}:${USER} ${WORKSPACE}

# Set working directory
WORKDIR ${WORKSPACE}

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD zsh -c 'echo "healthy"' || exit 1

# Default command
CMD ["/bin/zsh"]
