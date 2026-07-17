[![Build Status](https://ci.eclipse.org/cbi/buildStatus/icon?job=dockerfiles%2Fmaster)](https://ci.eclipse.org/cbi/job/dockerfiles/job/master/)

# CBI dockerfiles
Various Dockerfiles for building stuff @ Eclipse

# Usage

## Apps

| Docker image | Usage / Notes |
| ------------ | ------------- |
| buildpack-deps-ubuntu | Based on [buildpack-deps](https://hub.docker.com/_/buildpack-deps/) image. Used by GitLab CI templates (add link!). See also https://github.com/eclipse-cbi/dockerfiles/pull/37#issue-2205902199 |
| eclipse-temurin-<alpine/ubuntu>-coreutils | |
| semeru-ubuntu-coreutils | This image is used as the base image for all Jenkins controller docker images. See also https://github.com/eclipse-cbi/jiro-masters/blob/master/jiro.libsonnet#L28. |
| hugo | |
| hugo-extended | Used by [hugo-eclipsefdn-website-boilerplate](https://gitlab.eclipse.org/eclipsefdn/it/webdev/hugo-eclipsefdn-website-boilerplate). |
| openssh | |
| docker-kubectl | This image is used for building and deploying Docker images. |

## GTK3-WM

| Docker image | Usage / Notes |
| ------------ | ------------- |
| debian-gtk3-mutter | |
| fedora-gtk3-mutter | |
| ubuntu-gtk3-mutter | |
