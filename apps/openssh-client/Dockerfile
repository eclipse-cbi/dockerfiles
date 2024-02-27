FROM eclipsecbi/alpine

RUN apk --no-cache add \
    openssh-client

COPY scripts/uid_entrypoint /usr/local/bin
RUN chgrp 0 /etc/passwd && chmod g+rw /etc/passwd && \
  chgrp 0 /usr/local/bin/uid_entrypoint && chmod g+rx /usr/local/bin/uid_entrypoint

ENTRYPOINT [ "uid_entrypoint" ]

USER 10001