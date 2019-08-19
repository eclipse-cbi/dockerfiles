#!/bin/bash
# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

SCRIPT_FOLDER="$(dirname "$(readlink -f "${0}")")"
DOCKERTOOLS_PATH="${DOCKERTOOLS_PATH:-"${SCRIPT_FOLDER}/.dockertools"}"

build() {
  "${DOCKERTOOLS_PATH}/dockerw" build_and_push "eclipsecbi/${1}" "${2}" "${1}/${2}/Dockerfile" "${SCRIPT_FOLDER}"
  if [[ "${3:-}" = "latest" ]]; then
    tag_latest "${1}" "${2}"
  fi
}

tag_latest() {
  local f=$1
  local t=$2
  "${DOCKERTOOLS_PATH}/dockerw" tag_alias "eclipsecbi/${f}" "${t}" "latest"
  "${DOCKERTOOLS_PATH}/dockerw" push_if_changed "eclipsecbi/${f}" "latest" "${1}/${2}/Dockerfile"
}

if [[ -d "${DOCKERTOOLS_PATH}" ]]; then
  git -C "${DOCKERTOOLS_PATH}" fetch -f --no-tags --progress --depth 1 https://github.com/eclipse-cbi/dockertools.git +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" checkout -f "$(git -C "${DOCKERTOOLS_PATH}" rev-parse refs/remotes/origin/master)"
else 
  git init "${DOCKERTOOLS_PATH}"
  git -C "${DOCKERTOOLS_PATH}" fetch --no-tags --progress --depth 1 https://github.com/eclipse-cbi/dockertools.git +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" config remote.origin.url https://github.com/eclipse-cbi/dockertools.git
  git -C "${DOCKERTOOLS_PATH}" config --add remote.origin.fetch +refs/heads/master:refs/remotes/origin/master
  git -C "${DOCKERTOOLS_PATH}" config core.sparsecheckout true
  git -C "${DOCKERTOOLS_PATH}" config advice.detachedHead false
  git -C "${DOCKERTOOLS_PATH}" checkout -f "$(git -C "${DOCKERTOOLS_PATH}" rev-parse refs/remotes/origin/master)"
fi

build debian-gtk3-metacity 8-gtk3.14
build debian-gtk3-metacity 9-gtk3.22
build debian-gtk3-metacity sid-gtk3.24 latest

build fedora-gtk3-mutter 28-gtk3.22
build fedora-gtk3-mutter 29-gtk3.24
build fedora-gtk3-mutter 30-gtk3.24 latest

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
