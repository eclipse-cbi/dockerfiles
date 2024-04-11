ARG BUILDPACK_TAG=""
FROM buildpack-deps:${BUILDPACK_TAG}

ARG BUILDKIT_VERSION=v0.12.2
ARG GO_CONTAINER_REG_VERSION=v0.17.0
ARG JSONNET_VERSION=0.20.0
ARG TEMURIN_DIST=jammy
ARG TEMURIN_VERSION=21

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null && \
  echo "deb https://packages.adoptium.net/artifactory/deb $TEMURIN_DIST main" | tee /etc/apt/sources.list.d/adoptium.list

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
      apt-transport-https \
      gpg \
      vim \
      "temurin-$TEMURIN_VERSION-jdk" \
    && eatmydata apt-get clean && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/temurin-$TEMURIN_VERSION-jdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

WORKDIR /tmp

RUN curl -sSL https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz | tar zxv \
  && mv bin/buildctl /usr/local/bin/buildctl 
RUN curl -sSL https://github.com/google/go-containerregistry/releases/download/${GO_CONTAINER_REG_VERSION}/go-containerregistry_Linux_x86_64.tar.gz | tar zxv \
  && mv crane /usr/local/bin 
RUN curl -sSL https://github.com/google/go-jsonnet/releases/download/v${JSONNET_VERSION}/go-jsonnet_${JSONNET_VERSION}_Linux_x86_64.tar.gz | tar zxv \
  && mv jsonnet* /usr/local/bin 

RUN rm -rf /tmp/* 

WORKDIR /