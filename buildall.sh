#!/bin/bash
# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

#IFS=$'\n\t'

push() {
  local f=$1
  local t=$2
  n=0
	until [ $n -ge 5 ]; do
    #docker push eclipsecbi/$f:$t && break
    echo "docker push eclipsecbi/$f:$t"
    break
		echo "Try #$n failed ($f:$t)... sleeping for 15 seconds"
		n=$[$n+1]
		sleep 15
	done
}

build() {
  local f=$1; shift;
  local t=$1; shift;

  local moretags=()
  for tag in "$@"; do
    moretags+=(-t eclipsecbi/$f:$tag)
  done

  docker build --pull --no-cache --rm -t eclipsecbi/$f:$t ${moretags[@]-} -f $f/$t/Dockerfile .
  push $f $t

  for tag in "$@"; do
    push $f $tag
  done
}

tag_latest() {
  local f=$1
  local t=$2
  #docker tag eclipsecbi/$f:$t eclipsecbi/$f:latest
  echo "docker tag eclipsecbi/$f:$t eclipsecbi/$f:latest"
  push $f latest
}

build debian-gtk3-metacity 8-gtk3.14
build debian-gtk3-metacity 9-gtk3.22
build debian-gtk3-metacity sid-gtk3.24 latest

build fedora-gtk3-mutter 28-gtk3.22
build fedora-gtk3-mutter 29-gtk3.24 latest

build hugo 0.42.1 latest

build jenkins-jnlp-agent 3.20
build jenkins-jnlp-agent 3.25
build jenkins-jnlp-agent 3.27 latest

build node 8.11.3 latest

build ssh-client 1.0 latest

build ubuntu-gtk3-metacity 14.04-gtk3.10
build ubuntu-gtk3-metacity 16.04-gtk3.18
build ubuntu-gtk3-metacity 18.04-gtk3.22
build ubuntu-gtk3-metacity 18.10-gtk3.24 latest
