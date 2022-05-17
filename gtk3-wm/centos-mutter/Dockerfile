ARG FROM_TAG=""
FROM eclipsecbi/centos:${FROM_TAG}
ARG FROM_TAG

# CentOS 8 mirrors moved to vault.centos.org after EOL on Dec 31st, 2021
RUN if [[ "${FROM_TAG}" == "8" ]]; then sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
  && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*; fi

RUN yum -y install \
      gtk3 \
      tigervnc-server \
      tigervnc \
      mutter \
      xorg-x11-server-utils \
      mesa-libGL \
      xorg-x11-fonts-misc \
      xorg-x11-fonts-75dpi \
      xorg-x11-fonts-Type1 \
      xorg-x11-fonts-100dpi \
      liberation-fonts \
      gnu-free-fonts-common \
      dejavu-fonts-common \
    && yum clean all

ENV HOME=/home/vnc
ENV DISPLAY :0

RUN mkdir -p ${HOME}/.vnc && chmod -R 775 ${HOME} \
  && echo "123456" | vncpasswd -f > ${HOME}/.vnc/passwd \
  && chmod 600 ${HOME}/.vnc/passwd

# Create a custom vnc xstartup file
COPY scripts/xstartup_mutter.sh ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup.sh

USER 10001