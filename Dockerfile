FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    bash-completion \
    ca-certificates \
    apt-utils \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker @TODO: use a specific version
RUN curl -fsSL https://get.docker.com | sh

# JQ, YQ and Crane
RUN curl -fsSL -o /usr/local/bin/jq https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux64 \
    && chmod +x /usr/local/bin/jq
RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.45.4/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq 
RUN curl -fsSL "https://github.com/google/go-containerregistry/releases/download/v0.20.5/go-containerregistry_Linux_x86_64.tar.gz" > go-containerregistry.tar.gz \
    && tar -xzf go-containerregistry.tar.gz -C /usr/local/bin/ crane \
    && rm go-containerregistry.tar.gz

# Kubectl @TODO: use a specific version
RUN curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x /usr/local/bin/kubectl
RUN kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null

# Helm @TODO: use a specific version
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh
RUN helm completion bash > /etc/bash_completion.d/helm

# User setup
ARG USERNAME="nws"
RUN useradd -m -g users ${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Shell mods (oh-my-bash powerline theme)
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
RUN sed -i 's/OSH_THEME=".*"/OSH_THEME="powerline"/' .bashrc
