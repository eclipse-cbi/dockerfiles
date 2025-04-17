FROM alpine AS builder

RUN apk add --no-cache \
  curl

ARG HUGO_VERSION=0.110.0
ENV HUGO_VERSION=${HUGO_VERSION}
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar xvz

# the GLIBC installation below only works up to alpine:3.18
FROM alpine:3.18

COPY --from=builder hugo /usr/local/bin/hugo

# Install glibc: This is required for HUGO-extended (including SASS) to work.
# https://github.com/dettmering/hugo-build/blob/6c68088f1dc2f1fcccc7edffba9e78dcc4b2fc93/Dockerfile

ENV GLIBC_VERSION 2.35-r1

RUN set -x && \
  apk add --update wget ca-certificates libstdc++ gcompat

# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
# &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
# &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
# &&  rm "glibc-$GLIBC_VERSION.apk" \
# &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
# &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
# &&  rm "glibc-bin-$GLIBC_VERSION.apk" \
# &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
# &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
# &&  rm "glibc-i18n-$GLIBC_VERSION.apk"

# RUN apk --no-cache add gcompat

USER 10001
