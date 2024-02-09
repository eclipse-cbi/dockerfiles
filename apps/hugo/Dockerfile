FROM alpine AS builder

RUN apk add --no-cache \
  curl

ARG HUGO_VERSION=0.42.1
ENV HUGO_VERSION=${HUGO_VERSION}
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz | tar xvz

FROM alpine

COPY --from=builder hugo /usr/local/bin/hugo

USER 10001
