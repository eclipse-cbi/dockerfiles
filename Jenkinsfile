pipeline {

  agent {
    label 'docker-build'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 90, unit: 'MINUTES')
  }

  environment {
    REPO_NAME = "eclipsecbi"
    DOCKERTOOLS_PATH = sh(script: "printf ${env.WORKSPACE}/.dockertools", returnStdout: true)
  }

  triggers {
    cron('H H * * */3')
  }

  stages {
    stage('Get dockertools') {
      steps {
        readTrusted './fetch_dockertools'
        sh '''
          ./fetch_dockertools
        '''
      }
    }
    stage('Build images variants from Docker Library') {
      parallel {
        stage("Docker library image set 1") {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              // 3 latest releases + edge (https://hub.docker.com/_/alpine)
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "alpine", ["edge", "3.16", "3.17", "3.18", ])
            }
          }
        }
        stage("Docker library image set 2") {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              // 3 latest releases (https://hub.docker.com/_/debian/)
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "debian", [ "10-slim", "11-slim", "12-slim" ])
              // 3 latest releases + rawhide (https://hub.docker.com/_/fedora/)
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "fedora", ["rawhide", "37", "38", "39" ])
            }
          }
        }
        stage("Docker library image set 3") {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              // 2 latest LTS https://hub.docker.com/_/node)
              buildAndPushLibraryImage("apps/node/Dockerfile", env.REPO_NAME, "node", ["18-alpine", "20-alpine"])
              // 2 latest LTS + all releases since latest LTS
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "ubuntu", ["20.04", "22.04"])
            }
          }
        }
      }
    }
    stage('Build images') {
      parallel {
        stage('Docker image set 1 (incl. adoptopenjdk)') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("apps/hugo/Dockerfile", env.REPO_NAME, "hugo", "0.81.0", ["HUGO_VERSION": "0.81.0", ])
              buildAndPushImage("apps/hugo_extended/Dockerfile", env.REPO_NAME, "hugo_extended", "0.81.0", ["HUGO_VERSION": "0.81.0", ])

              buildAndPushImage("apps/ci-admin/openssh/Dockerfile", env.REPO_NAME, "openssh", "8.8_p1-r1", ["FROM_TAG": "3.15", "OPENSSH_VERSION": "8.8_p1-r1", ])

              buildAndPushImage("apps/adoptopenjdk-alpine/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-alpine-slim", ["FROM_IMAGE": "openjdk8", "FROM_TAG": "alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-alpine/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-openj9-alpine-slim", ["FROM_IMAGE": "openjdk8-openj9", "FROM_TAG": "alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk-alpine/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-alpine-slim", ["FROM_IMAGE": "openjdk11", "FROM_TAG": "alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-alpine/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-openj9-alpine-slim", ["FROM_IMAGE": "openjdk11-openj9", "FROM_TAG": "alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk-alpine-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-alpine-slim", ["FROM_TAG": "openjdk8-alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-alpine-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-openj9-alpine-slim", ["FROM_TAG": "openjdk8-openj9-alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk-alpine-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-alpine-slim", ["FROM_TAG": "openjdk11-alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-alpine-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-openj9-alpine-slim", ["FROM_TAG": "openjdk11-openj9-alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk-debian/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-debian-slim", ["FROM_IMAGE": "openjdk8", "FROM_TAG": "debian-slim", ])
              buildAndPushImage("apps/adoptopenjdk-debian/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-openj9-debian-slim", ["FROM_IMAGE": "openjdk8-openj9", "FROM_TAG": "debian-slim", ])

              buildAndPushImage("apps/adoptopenjdk-debian/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-debian-slim", ["FROM_IMAGE": "openjdk11", "FROM_TAG": "debian-slim", ])
              buildAndPushImage("apps/adoptopenjdk-debian/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-openj9-debian-slim", ["FROM_IMAGE": "openjdk11-openj9", "FROM_TAG": "debian-slim", ])

              buildAndPushImage("apps/adoptopenjdk-debian-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-debian-slim", ["FROM_TAG": "openjdk8-debian-slim", ])
              buildAndPushImage("apps/adoptopenjdk-debian-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-openj9-debian-slim", ["FROM_TAG": "openjdk8-openj9-debian-slim", ])

              buildAndPushImage("apps/adoptopenjdk-debian-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-debian-slim", ["FROM_TAG": "openjdk11-debian-slim", ])
              buildAndPushImage("apps/adoptopenjdk-debian-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-openj9-debian-slim", ["FROM_TAG": "openjdk11-openj9-debian-slim", ])

              /* Temurin */
              buildAndPushImage("apps/eclipse-temurin-alpine/Dockerfile", env.REPO_NAME, "eclipse-temurin", "8-alpine", ["FROM_IMAGE": "eclipse-temurin", "FROM_TAG": "8-alpine", ])
              buildAndPushImage("apps/eclipse-temurin-alpine/Dockerfile", env.REPO_NAME, "eclipse-temurin", "11-alpine", ["FROM_IMAGE": "eclipse-temurin", "FROM_TAG": "11-alpine", ])
              buildAndPushImage("apps/eclipse-temurin-alpine-coreutils/Dockerfile", env.REPO_NAME, "eclipse-temurin-coreutils", "8-alpine", ["FROM_TAG": "8-alpine", ])
              buildAndPushImage("apps/eclipse-temurin-alpine-coreutils/Dockerfile", env.REPO_NAME, "eclipse-temurin-coreutils", "11-alpine", ["FROM_TAG": "11-alpine", ])
              buildAndPushImage("apps/eclipse-temurin-ubuntu/Dockerfile", env.REPO_NAME, "eclipse-temurin", "8-ubuntu", ["FROM_IMAGE": "eclipse-temurin", "FROM_TAG": "8", ])
              buildAndPushImage("apps/eclipse-temurin-ubuntu/Dockerfile", env.REPO_NAME, "eclipse-temurin", "11-ubuntu", ["FROM_IMAGE": "eclipse-temurin", "FROM_TAG": "11", ])
              buildAndPushImage("apps/eclipse-temurin-ubuntu-coreutils/Dockerfile", env.REPO_NAME, "eclipse-temurin-coreutils", "8-ubuntu", ["FROM_TAG": "8-ubuntu", ])
              buildAndPushImage("apps/eclipse-temurin-ubuntu-coreutils/Dockerfile", env.REPO_NAME, "eclipse-temurin-coreutils", "11-ubuntu", ["FROM_TAG": "11-ubuntu", ])
              /* eo Temurin */

              buildAndPushImage("apps/semeru-ubuntu/Dockerfile", env.REPO_NAME, "semeru-ubuntu", "openjdk8-jammy", ["FROM_IMAGE": "ibm-semeru-runtimes", "FROM_TAG": "open-8-jdk-jammy", ])
              buildAndPushImage("apps/semeru-ubuntu-coreutils/Dockerfile", env.REPO_NAME, "semeru-ubuntu-coreutils", "openjdk8-jammy", ["FROM_TAG": "openjdk8-jammy", ])
              buildAndPushImage("apps/semeru-ubuntu/Dockerfile", env.REPO_NAME, "semeru-ubuntu", "openjdk11-jammy", ["FROM_IMAGE": "ibm-semeru-runtimes", "FROM_TAG": "open-11-jdk-jammy", ])
              buildAndPushImage("apps/semeru-ubuntu-coreutils/Dockerfile", env.REPO_NAME, "semeru-ubuntu-coreutils", "openjdk11-jammy", ["FROM_TAG": "openjdk11-jammy", ])
              buildAndPushImage("apps/semeru-ubuntu/Dockerfile", env.REPO_NAME, "semeru-ubuntu", "openjdk17-jammy", ["FROM_IMAGE": "ibm-semeru-runtimes", "FROM_TAG": "open-17-jdk-jammy", ])
              buildAndPushImage("apps/semeru-ubuntu-coreutils/Dockerfile", env.REPO_NAME, "semeru-ubuntu-coreutils", "openjdk17-jammy", ["FROM_TAG": "openjdk17-jammy", ])
            }
          }
        }
        stage('gtk3-wm fedora') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "37-gtk3.24", ["FROM_TAG": "37", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "38-gtk3.24", ["FROM_TAG": "38", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "39-gtk3.24", ["FROM_TAG": "39", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/rawhide/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "rawhide-gtk3", ["FROM_TAG": "rawhide", ])
            }
          }
        }
        stage('gtk3-wm ubuntu') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/ubuntu-metacity/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "20.04-gtk3.24", ["FROM_TAG": "20.04", ])
              buildAndPushImage("gtk3-wm/ubuntu-metacity/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "22.04-gtk3.24", ["FROM_TAG": "22.04", ])
            }
          }
        }
        stage('gtk3-wm debian') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "10-gtk3.24", ["FROM_TAG": "10-slim", ])
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "11-gtk3.24", ["FROM_TAG": "11-slim", ])
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "12-gtk3.24", ["FROM_TAG": "12-slim", ])
            }
          }
        }
      }
    }
  }

  post {
    failure {
      mail to: 'releng-team@eclipse-foundation.org',
        subject: "[CBI] Build Failure ${currentBuild.fullDisplayName}",
        mimeType: 'text/html',
        body: "Project: ${env.JOB_NAME}<br/>Build Number: ${env.BUILD_NUMBER}<br/>Build URL: ${env.BUILD_URL}<br/>Console: ${env.BUILD_URL}/console"
    }
    fixed {
      mail to: 'releng-team@eclipse-foundation.org',
        subject: "[CBI] Back to normal ${currentBuild.fullDisplayName}",
        mimeType: 'text/html',
        body: "Project: ${env.JOB_NAME}<br/>Build Number: ${env.BUILD_NUMBER}<br/>Build URL: ${env.BUILD_URL}<br/>Console: ${env.BUILD_URL}/console"
    }
    cleanup {
      deleteDir() /* clean up workspace */
    }
  }
}

def buildAndPushLibraryImage(String dockerfile, String repo, String distroImage, List<String> tags, Map<String, String> buildArgs = [:]) {
  def latestTag = tags.last()
  tags.each { tag ->
    if (tag == latestTag) {
      buildAndPushImage(dockerfile, repo, distroImage, tag, true, ["DISTRO": "${distroImage}:${tag}"] + buildArgs)
    } else {
      buildAndPushImage(dockerfile, repo, distroImage, tag, ["DISTRO": "${distroImage}:${tag}"] + buildArgs)
    }
  }
}

def buildAndPushImage(String dockerfile, String repo, String image, String tag, Map<String, String> buildArgs = [:]) {
  buildAndPushImage(dockerfile, repo, image, tag, false, buildArgs)
}

def buildAndPushImage(String dockerfile, String repo, String image, String tag, boolean latest, Map<String, String> buildArgs = [:]) {
  def dockerBuildArgs = buildArgs.collect{ k, v -> "--opt \"build-arg:${k}=${v}\"" }.join(" ")
  sh """
    if [ "\${GIT_BRANCH}" = "master" ]; then
      \${DOCKERTOOLS_PATH}/dockerw build  "${repo}/${image}" "${tag}" "${dockerfile}" "." "true" "${latest}" ${dockerBuildArgs}
    else
      \${DOCKERTOOLS_PATH}/dockerw build  "${repo}/${image}" "${tag}" "${dockerfile}" "." "false" "${latest}" ${dockerBuildArgs}
    fi
  """
}
