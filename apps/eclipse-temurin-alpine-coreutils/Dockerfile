#*******************************************************************************
# Copyright (c) 2018 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html,
# or the MIT License which is available at https://opensource.org/licenses/MIT.
# SPDX-License-Identifier: EPL-2.0 OR MIT
#*******************************************************************************
ARG FROM_TAG=""
FROM eclipse-temurin:${FROM_TAG}

# Workaround for https://github.com/AdoptOpenJDK/openjdk-docker/issues/75
# java.lang.NullPointerException
#         at sun.awt.FontConfiguration.getVersion(FontConfiguration.java:1264)
RUN ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1

RUN apk add --no-cache \
  bash \
  coreutils \
  curl \
  dumb-init \
  git \
  gnupg \
  jq \
  openssh-client \
  rsync \
  ttf-dejavu \
  unzip \
  wget \
  zip