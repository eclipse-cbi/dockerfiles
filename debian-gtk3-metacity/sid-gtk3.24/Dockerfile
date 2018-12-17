FROM debian:sid-slim@sha256:aba719caa1074f30e390a21104b47814aa996eb8be42c1cc9a3cec73b04e8a73

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
ENTRYPOINT [ "uid_entrypoint" ]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtk-3-0=3.24.2-3 \
      tigervnc-standalone-server \
      tigervnc-common \
      metacity \
      x11-xserver-utils \
      libgl1-mesa-dri \
      xfonts-base \
      xfonts-scalable \
      xfonts-100dpi \
      xfonts-75dpi \
      fonts-liberation \
      fonts-liberation2 \
      fonts-freefont-ttf \
      fonts-dejavu \
      fonts-dejavu-core \
      fonts-dejavu-extra \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/vnc
ENV DISPLAY :0

RUN mkdir -p ${HOME}/.vnc \
  && echo "123456" | vncpasswd -f > ${HOME}/.vnc/passwd \
  && chmod 600 ${HOME}/.vnc/passwd

# Create a custom vnc xstartup file
RUN echo "#!/bin/sh\n[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n[ -r ${HOME}/.Xresources ] && xrdb ${HOME}/.Xresources\nXvnc \$DISPLAY -geometry 1440x900 -depth 16 -dpi 100 -PasswordFile ${HOME}/.vnc/passwd &\nsleep 2\nxsetroot -solid grey\nvncconfig -iconic &\nxhost +\nmetacity --replace --sm-disable --display=\$DISPLAY &" \
    > ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup.sh

USER 10001