FROM adoptopenjdk/openjdk8:jdk8u172-b11-alpine-slim@sha256:be98cdae8a15ee9568441d9782134216e48fd13c60865d367a6e80ba410342a2

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /etc/passwd
### end

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    openssh-client \
    wget \
    zip

# https://github.com/jenkinsci/remoting/blob/master/CHANGELOG.md 
# 3.25 => Release date: July 31, 2018 => Weekly 2.138 / LTS 2.121.3
ARG REMOTING_VERSION=3.25

# https://github.com/jenkinsci/docker-jnlp-slave/
# 3.26-1 is latest (no 3.25 to match remoting)
ARG JNLP_AGENT_SCRIPT_VERSION=3.26-1

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${REMOTING_VERSION}/remoting-${REMOTING_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

ADD https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/${JNLP_AGENT_SCRIPT_VERSION}/jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 555 /usr/local/bin/jenkins-slave && chgrp 0 /usr/local/bin/jenkins-slave

RUN mkdir -p /home/jenkins/.jenkins && \
  mkdir -p /home/jenkins/agent

ENTRYPOINT [ "uid_entrypoint", "jenkins-slave"]
ENV HOME=/home/jenkins
ENV JENKINS_AGENT_WORKDIR=/home/jenkins/agent
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
ENV JAVA_TOOL_OPTIONS=
WORKDIR /home/jenkins

USER 10001