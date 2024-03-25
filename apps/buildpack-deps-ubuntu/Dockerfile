ARG BUILDPACK_TAG=""
FROM buildpack-deps:${BUILDPACK_TAG}

ARG BUILDKIT_VERSION=v0.12.2
ARG GO_CONTAINER_REG_VERSION=v0.16.1
ARG JSONNET_VERSION=0.20.0

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends eatmydata && \
    eatmydata apt-get install -y --no-install-recommends \
      coreutils \
      rsync \
      jq \
      bc \
      make \
      parallel \
      zip \
      unzip \
    && eatmydata apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz | tar zxv \
  && mv bin/buildctl /usr/local/bin/buildctl 
RUN curl -sSL https://github.com/google/go-containerregistry/releases/download/${GO_CONTAINER_REG_VERSION}/go-containerregistry_Linux_x86_64.tar.gz | tar zxv \
  && mv crane /usr/local/bin 
RUN curl -sSL https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz | tar zxv \
  && mv jsonnet* /usr/local/bin 

RUN rm -rf /tmp/* 

WORKDIR /