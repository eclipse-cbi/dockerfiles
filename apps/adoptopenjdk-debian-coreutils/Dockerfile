#*******************************************************************************
# Copyright (c) 2018 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html,
# or the MIT License which is available at https://opensource.org/licenses/MIT.
# SPDX-License-Identifier: EPL-2.0 OR MIT
#*******************************************************************************
ARG FROM_TAG=""
FROM eclipsecbi/adoptopenjdk:${FROM_TAG}

RUN apt-get update && apt-get install -y --no-install-recommends \
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