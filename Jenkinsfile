pipeline {

  agent {
    label 'docker-build'
  }

  options { 
    buildDiscarder(logRotator(numToKeepStr: '5'))
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
              // 4 latest releases
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "alpine", ["3.8", "3.9", "3.10", "3.11", ])
              // 2 latest major
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "centos", ["6", "7", "8", ])
            }
          }
        }
        stage("Docker library image set 2") {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              // 3 latest releases
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "debian", ["8-slim", "9-slim", "10-slim", "sid-slim", ])
              // 4 latest releases
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "fedora", ["28", "29", "30", "31", "rawhide", ])
            }
          }
        }
        stage("Docker library image set 3") {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              // 2 latest LTS + latest release (lts or)
              buildAndPushLibraryImage("apps/node/Dockerfile", env.REPO_NAME, "node", ["10-alpine", "12-alpine", "13-alpine"])
              // 2 latest LTS + all releases since latest LTS
              buildAndPushLibraryImage("distros/Dockerfile", env.REPO_NAME, "ubuntu", ["16.04", "18.04", "18.10", "19.04", "19.10", ])
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
              buildAndPushImage("apps/hugo/Dockerfile", env.REPO_NAME, "hugo", "0.42.1", ["HUGO_VERSION": "0.42.1", ])
              buildAndPushImage("apps/hugo/Dockerfile", env.REPO_NAME, "hugo", "0.58.3", ["HUGO_VERSION": "0.58.3", ])
              buildAndPushImage("apps/openssh-client/Dockerfile", env.REPO_NAME, "ssh-client", "1.0")

              buildAndPushImage("apps/adoptopenjdk/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-alpine-slim", ["FROM_IMAGE": "openjdk8", "FROM_TAG": "alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk8-openj9-alpine-slim", ["FROM_IMAGE": "openjdk8-openj9", "FROM_TAG": "alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-alpine-slim", ["FROM_IMAGE": "openjdk11", "FROM_TAG": "alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk/Dockerfile", env.REPO_NAME, "adoptopenjdk", "openjdk11-openj9-alpine-slim", ["FROM_IMAGE": "openjdk11-openj9", "FROM_TAG": "alpine-slim", ])

              buildAndPushImage("apps/adoptopenjdk-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-alpine-slim", ["FROM_TAG": "openjdk8-alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk8-openj9-alpine-slim", ["FROM_TAG": "openjdk8-openj9-alpine-slim", ])
              
              buildAndPushImage("apps/adoptopenjdk-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-alpine-slim", ["FROM_TAG": "openjdk11-alpine-slim", ])
              buildAndPushImage("apps/adoptopenjdk-coreutils/Dockerfile", env.REPO_NAME, "adoptopenjdk-coreutils", "openjdk11-openj9-alpine-slim", ["FROM_TAG": "openjdk11-openj9-alpine-slim", ])
            }
          }
        }
        stage('gtk3-wm fedora') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "28-gtk3.22", ["FROM_TAG": "28", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "29-gtk3.24", ["FROM_TAG": "29", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "30-gtk3.24", ["FROM_TAG": "30", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "31-gtk3.24", ["FROM_TAG": "31", ])
              buildAndPushImage("gtk3-wm/fedora-mutter/Dockerfile", env.REPO_NAME, "fedora-gtk3-mutter", "rawhide-gtk3", ["FROM_TAG": "rawhide", ])
            }
          }
        }
        stage('gtk3-wm ubuntu') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/ubuntu-metacity/16.04/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "16.04-gtk3.18", ["FROM_TAG": "16.04", ])
              buildAndPushImage("gtk3-wm/ubuntu-metacity/18.04/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "18.04-gtk3.18", ["FROM_TAG": "18.04", ])
              buildAndPushImage("gtk3-wm/ubuntu-metacity/18.04/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "18.10-gtk3.18", ["FROM_TAG": "18.10", ])
              buildAndPushImage("gtk3-wm/ubuntu-metacity/18.04/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "19.04-gtk3.18", ["FROM_TAG": "19.04", ])
              buildAndPushImage("gtk3-wm/ubuntu-metacity/18.04/Dockerfile", env.REPO_NAME, "ubuntu-gtk3-metacity", "19.10-gtk3.18", ["FROM_TAG": "19.10", ])
            }
          }
        }
        stage('gtk3-wm centos+debian') {
          steps {
            withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
              buildAndPushImage("gtk3-wm/centos-mutter/Dockerfile", env.REPO_NAME, "centos-gtk3-mutter", "7-gtk3.22", ["FROM_TAG": "7", ])
              buildAndPushImage("gtk3-wm/centos-mutter/Dockerfile", env.REPO_NAME, "centos-gtk3-mutter", "8-gtk3.22", ["FROM_TAG": "8", ])

              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "8-gtk3.14", ["FROM_TAG": "8-slim", ])
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "9-gtk3.22", ["FROM_TAG": "9-slim", ])
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "10-gtk3.24", ["FROM_TAG": "10-slim", ])
              buildAndPushImage("gtk3-wm/debian-metacity/Dockerfile", env.REPO_NAME, "debian-gtk3-metacity", "sid-gtk3", ["FROM_TAG": "sid-slim", ])
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