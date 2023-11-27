@Library('releng-pipeline@main') _

pipeline {
  agent {
    kubernetes {
      yaml loadOverridableResource(
        libraryResource: 'org/eclipsefdn/container/agent.yml'
      )
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 90, unit: 'MINUTES')
  }

  environment {
    HOME = '${env.WORKSPACE}'
    NAMESPACE = 'eclipsecbi'
    CREDENTIALS_ID = 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9'
  }

  triggers {
    cron('H H * * */3')
  }

  stages {
    stage('Build Library Image') {
      steps {
        buildLibraryImage('alpine', ['edge', '3.16', '3.17', '3.18'])
        buildLibraryImage('debian', ['10-slim', '11-slim', '12-slim'])
        buildLibraryImage('fedora', ['rawhide', '37', '38', '39'])
        buildLibraryImage('ubuntu', ['20.04', '22.04'])
        buildLibraryImage('node', ['18-alpine', '20-alpine'], 'apps/node/Dockerfile')
      }
    }
    stage('Build Images hugo') {
      steps {
        buildImage('hugo', '0.81.0', 'apps/hugo/Dockerfile', ['HUGO_VERSION': '0.81.0'])
        buildImage('hugo_extended', '0.81.0', 'apps/hugo_extended/Dockerfile', ['HUGO_VERSION': '0.81.0'])
      }
    }
    stage('Build Image openssh') {
      steps {
        buildImage('openssh', '8.8_p1-r1', 'apps/ci-admin/openssh/Dockerfile', ['FROM_TAG': '3.15', 'OPENSSH_VERSION': '8.8_p1-r1'])
      }
    }
    stage('Build Images adoptopenjdk') {
      steps {
        // alpine 
        buildImage('adoptopenjdk', 'openjdk8-alpine-slim', 'apps/adoptopenjdk-alpine/Dockerfile', ['FROM_IMAGE': 'openjdk8', 'FROM_TAG': 'alpine-slim'])
        buildImage('adoptopenjdk', 'openjdk8-openj9-alpine-slim', 'apps/adoptopenjdk-alpine/Dockerfile', ['FROM_IMAGE': 'openjdk8-openj9', 'FROM_TAG': 'alpine-slim'])
        buildImage('adoptopenjdk', 'openjdk11-alpine-slim', 'apps/adoptopenjdk-alpine/Dockerfile', ['FROM_IMAGE': 'openjdk11', 'FROM_TAG': 'alpine-slim'])
        buildImage('adoptopenjdk', 'openjdk11-openj9-alpine-slim', 'apps/adoptopenjdk-alpine/Dockerfile', ['FROM_IMAGE': 'openjdk11-openj9', 'FROM_TAG': 'alpine-slim'])

        buildImage('adoptopenjdk-coreutils', 'openjdk8-alpine-slim', 'apps/adoptopenjdk-alpine-coreutils/Dockerfile', ['FROM_TAG': 'openjdk8-alpine-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk8-openj9-alpine-slim', 'apps/adoptopenjdk-alpine-coreutils/Dockerfile', ['FROM_TAG': 'openjdk8-openj9-alpine-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk11-alpine-slim', 'apps/adoptopenjdk-alpine-coreutils/Dockerfile', ['FROM_TAG': 'openjdk11-alpine-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk11-openj9-alpine-slim', 'apps/adoptopenjdk-alpine-coreutils/Dockerfile', ['FROM_TAG': 'openjdk11-openj9-alpine-slim'])

        // debian 
        buildImage('adoptopenjdk', 'openjdk8-debian-slim', 'apps/adoptopenjdk-debian/Dockerfile', ['FROM_IMAGE': 'openjdk8', 'FROM_TAG': 'debian-slim'])
        buildImage('adoptopenjdk', 'openjdk8-openj9-debian-slim', 'apps/adoptopenjdk-debian/Dockerfile', ['FROM_IMAGE': 'openjdk8-openj9', 'FROM_TAG': 'debian-slim'])
        buildImage('adoptopenjdk', 'openjdk11-debian-slim', 'apps/adoptopenjdk-debian/Dockerfile', ['FROM_IMAGE': 'openjdk11', 'FROM_TAG': 'debian-slim'])
        buildImage('adoptopenjdk', 'openjdk11-openj9-debian-slim', 'apps/adoptopenjdk-debian/Dockerfile', ['FROM_IMAGE': 'openjdk11-openj9', 'FROM_TAG': 'debian-slim'])

        buildImage('adoptopenjdk-coreutils', 'openjdk8-debian-slim', 'apps/adoptopenjdk-debian-coreutils/Dockerfile', ['FROM_TAG': 'openjdk8-debian-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk8-openj9-debian-slim', 'apps/adoptopenjdk-debian-coreutils/Dockerfile', ['FROM_TAG': 'openjdk8-openj9-debian-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk11-debian-slim', 'apps/adoptopenjdk-debian-coreutils/Dockerfile', ['FROM_TAG': 'openjdk11-debian-slim'])
        buildImage('adoptopenjdk-coreutils', 'openjdk11-openj9-debian-slim', 'apps/adoptopenjdk-debian-coreutils/Dockerfile', ['FROM_TAG': 'openjdk11-openj9-debian-slim'])
      }
    }
    stage('Build Images eclipse-temurin') {
      steps {
        buildImage('eclipse-temurin', '8-alpine', 'apps/eclipse-temurin-alpine/Dockerfile', ['FROM_IMAGE': 'eclipse-temurin', 'FROM_TAG': '8-alpine'], )
        buildImage('eclipse-temurin', '11-alpine', 'apps/eclipse-temurin-alpine/Dockerfile', ['FROM_IMAGE': 'eclipse-temurin', 'FROM_TAG': '11-alpine'])
        buildImage('eclipse-temurin-coreutils', '8-alpine', 'apps/eclipse-temurin-alpine-coreutils/Dockerfile', ['FROM_TAG': '8-alpine'])
        buildImage('eclipse-temurin-coreutils', '11-alpine', 'apps/eclipse-temurin-alpine-coreutils/Dockerfile', ['FROM_TAG': '11-alpine'])
        buildImage('eclipse-temurin', '8-ubuntu', 'apps/eclipse-temurin-ubuntu/Dockerfile', ['FROM_IMAGE': 'eclipse-temurin', 'FROM_TAG': '8'])
        buildImage('eclipse-temurin', '11-ubuntu', 'apps/eclipse-temurin-ubuntu/Dockerfile', ['FROM_IMAGE': 'eclipse-temurin', 'FROM_TAG': '11'])
        buildImage('eclipse-temurin-coreutils', '8-ubuntu', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '8-ubuntu'])
        buildImage('eclipse-temurin-coreutils', '11-ubuntu', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '11-ubuntu'])
      }
    }
    stage('Build Images semeru') {
      steps {
        buildImage('semeru-ubuntu', 'openjdk8-jammy', 'apps/semeru-ubuntu/Dockerfile', ['FROM_IMAGE': 'ibm-semeru-runtimes', 'FROM_TAG': 'open-8-jdk-jammy'])
        buildImage('semeru-ubuntu-coreutils', 'openjdk8-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'openjdk8-jammy'])
        buildImage('semeru-ubuntu', 'openjdk11-jammy', 'apps/semeru-ubuntu/Dockerfile', ['FROM_IMAGE': 'ibm-semeru-runtimes', 'FROM_TAG': 'open-11-jdk-jammy'])
        buildImage('semeru-ubuntu-coreutils', 'openjdk11-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'openjdk11-jammy'])
        buildImage('semeru-ubuntu', 'openjdk17-jammy', 'apps/semeru-ubuntu/Dockerfile', ['FROM_IMAGE': 'ibm-semeru-runtimes', 'FROM_TAG': 'open-17-jdk-jammy'])
        buildImage('semeru-ubuntu-coreutils', 'openjdk17-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'openjdk17-jammy'])
      }
    }
    stage('Build Images gtk3-wm') {
      steps {
        buildImage('fedora-gtk3-mutter', '37-gtk3.24', 'gtk3-wm/fedora-mutter/Dockerfile', ['FROM_TAG': '37'])
        buildImage('fedora-gtk3-mutter', '38-gtk3.24', 'gtk3-wm/fedora-mutter/Dockerfile', ['FROM_TAG': '38'])
        buildImage('fedora-gtk3-mutter', '39-gtk3.24', 'gtk3-wm/fedora-mutter/Dockerfile', ['FROM_TAG': '39'])
        buildImage('fedora-gtk3-mutter', 'rawhide-gtk3', 'gtk3-wm/fedora-mutter/rawhide/Dockerfile', ['FROM_TAG': 'rawhide'])

        buildImage('ubuntu-gtk3-metacity', '20.04-gtk3.24', 'gtk3-wm/ubuntu-metacity/Dockerfile', ['FROM_TAG': '20.04'])
        buildImage('ubuntu-gtk3-metacity', '22.04-gtk3.24', 'gtk3-wm/ubuntu-metacity/Dockerfile', ['FROM_TAG': '22.04'])

        buildImage('debian-gtk3-metacity', '10-gtk3.24', 'gtk3-wm/debian-metacity/Dockerfile', ['FROM_TAG': '10-slim'])
        buildImage('debian-gtk3-metacity', '11-gtk3.24', 'gtk3-wm/debian-metacity/Dockerfile', ['FROM_TAG': '11-slim'])
        buildImage('debian-gtk3-metacity', '12-gtk3.24', 'gtk3-wm/debian-metacity/Dockerfile', ['FROM_TAG': '12-slim'])
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

def buildLibraryImage(String name, List<String> versions, String dockerfile='distros/Dockerfile') {
  def latestVersion = versions.last()
  versions.each { version ->
    String distroName = name + ':' + version
    buildImage(name, version, dockerfile, ['DISTRO': distroName], version == latestVersion)
  }
}

def buildImage(String name, String version, String dockerfile, Map<String, String> buildArgs = [:], boolean latest = false) {
  String distroName = env.REPO_NAME + '/' + name + ':' + version
  println '############ buildImage ' + distroName + ' ############'
  def containerBuildArgs = buildArgs.collect{ k, v -> '--opt build-arg:' + k + '=' + v }.join(' ')

  container('containertools') {
    containerBuild(
      credentialsId: env.CREDENTIALS_ID,
      name: env.REPO_NAME + '/' + name,
      version: version,
      dockerfile: dockerfile,
      buildArgs: containerBuildArgs,
      push: env.GIT_BRANCH == 'master',
      latest: latest
    )
  }
}
