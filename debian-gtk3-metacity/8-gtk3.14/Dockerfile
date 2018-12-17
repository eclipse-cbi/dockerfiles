FROM debian:8.11-slim@sha256:61b250599a61111b174d937808305d1b06942c5d12acda6be9ef3612895e2450

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
ENTRYPOINT [ "uid_entrypoint" ]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtk-3-0=3.14.5-1+deb8u1 \
      tightvncserver \
      metacity \
      x11-xserver-utils \
      libgl1-mesa-dri \
      xfonts-base \
      xfonts-scalable \
      xfonts-100dpi \
      xfonts-75dpi \
      fonts-liberation \
      fonts-freefont-ttf \
      fonts-dejavu \
      fonts-dejavu-core \
      fonts-dejavu-extra \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

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