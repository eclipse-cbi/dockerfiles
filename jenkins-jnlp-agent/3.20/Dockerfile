FROM adoptopenjdk/openjdk8:jdk8u172-b11-alpine-slim

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
### end

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    openssh-client \
    wget

# https://github.com/jenkinsci/remoting/blob/master/CHANGELOG.md 
# 3.20 => 2.121.1 LTS
ARG REMOTING_VERSION=3.20 

# https://github.com/jenkinsci/docker-jnlp-slave/
# 3.19-1 is latest (no 3.20 to match remoting)
ARG JNLP_AGENT_SCRIPT_VERSION=3.19-1

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