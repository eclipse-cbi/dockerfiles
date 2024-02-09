ARG FROM_TAG=""
FROM alpine:${FROM_TAG}

# Check on
# https://pkgs.alpinelinux.org/packages?name=openssh&branch=v3.19
ARG OPENSSH_VERSION="9.6_p1-r0"
ENV OPENSSH_VERSION=${OPENSSH_VERSION}

RUN apk --no-cache add openssh=${OPENSSH_VERSION}

COPY scripts/uid_entrypoint /usr/local/bin
RUN chgrp 0 /etc/passwd && chmod g+rw /etc/passwd && \
  chgrp 0 /usr/local/bin/uid_entrypoint && chmod g+rx /usr/local/bin/uid_entrypoint

ENTRYPOINT [ "uid_entrypoint" ]

USER 1001