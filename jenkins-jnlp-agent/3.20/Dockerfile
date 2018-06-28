FROM adoptopenjdk/openjdk8:jdk8u172-b11-alpine@sha256:381f39209dbe8ed9a785fe4e9a51423d196a365d45933372ef2229963255595a

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /etc/passwd
### end

RUN apk --no-cache add \
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

COPY jenkins-jnlp-agent/known_hosts /home/jenkins/.ssh/known_hosts

RUN chmod 775 /home/jenkins && \
  chmod 770 /home/jenkins/.ssh && \
  chmod 664 /home/jenkins/.ssh/known_hosts

ENTRYPOINT [ "uid_entrypoint", "jenkins-slave"]
ENV HOME=/home/jenkins
WORKDIR /home/jenkins
USER 10001