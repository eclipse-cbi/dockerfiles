ARG FROM_TAG=""
FROM debian:${FROM_TAG}

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
      libgtk-3-0 \
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

RUN mkdir -p ${HOME}/.vnc && chmod -R 775 ${HOME} \
  && echo "123456" | vncpasswd -f > ${HOME}/.vnc/passwd \
  && chmod 600 ${HOME}/.vnc/passwd

# Create a custom vnc xstartup file
COPY scripts/xstartup_metacity.sh ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup.sh

USER 10001