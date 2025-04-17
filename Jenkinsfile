@Library('releng-pipeline@main') _

pipeline {
  agent any 

  options {
    skipDefaultCheckout()
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
    stage('Checkout Workspace') {
      steps {
        checkout scm
        stash(name: 'workspace', includes: '**')
      }
    }
    stage('Run Builds') {
      parallel {
        stage('Build buildpack-deps') {
          steps {
            buildImage('buildpack-deps', 'noble', 'apps/buildpack-deps-ubuntu/Dockerfile', ['BUILDPACK_TAG': 'noble-scm'], true)
          }
        }
        stage('Build Images hugo') {
          steps {
            buildImage('hugo', '0.110.0', 'apps/hugo/Dockerfile', ['HUGO_VERSION': '0.110.0'])
            buildImage('hugo_extended', '0.110.0', 'apps/hugo_extended/Dockerfile', ['HUGO_VERSION': '0.110.0'])
            buildImage('hugo_extended', '0.144.2', 'apps/hugo_extended/Dockerfile', ['HUGO_VERSION': '0.144.2'])
          }
        }
        stage('Build Image openssh') {
          steps {
            buildImage('openssh', '9.9_p2-r0', 'apps/ci-admin/openssh/Dockerfile', ['FROM_TAG': '3.21', 'OPENSSH_VERSION': '9.9_p2-r0'])
          }
        }
        stage('Build Images eclipse-temurin') {
          steps {
            buildImage('eclipse-temurin-coreutils', '11-alpine', 'apps/eclipse-temurin-alpine-coreutils/Dockerfile', ['FROM_TAG': '11-alpine'])
            buildImage('eclipse-temurin-coreutils', '17-alpine', 'apps/eclipse-temurin-alpine-coreutils/Dockerfile', ['FROM_TAG': '17-alpine'])
            buildImage('eclipse-temurin-coreutils', '21-alpine', 'apps/eclipse-temurin-alpine-coreutils/Dockerfile', ['FROM_TAG': '21-alpine'])
            buildImage('eclipse-temurin-coreutils', '11-ubuntu', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '11']) // eclipse-temurin:11 => ubuntu 22.04
            buildImage('eclipse-temurin-coreutils', '17-ubuntu', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '17']) // eclipse-temurin:17 => ubuntu 22.04
            buildImage('eclipse-temurin-coreutils', '17-ubuntu2404', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '17-noble']) // eclipse-temurin:17-noble => ubuntu 24.04
            buildImage('eclipse-temurin-coreutils', '21-ubuntu2404', 'apps/eclipse-temurin-ubuntu-coreutils/Dockerfile', ['FROM_TAG': '21-noble']) // eclipse-temurin:21-noble => ubuntu 24.04
          }
        }
        stage('Build Images semeru') {
          steps {
            buildImage('semeru-ubuntu-coreutils', 'openjdk11-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'open-11-jdk-jammy'])
            buildImage('semeru-ubuntu-coreutils', 'openjdk17-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'open-17-jdk-jammy'])
            buildImage('semeru-ubuntu-coreutils', 'openjdk21-jammy', 'apps/semeru-ubuntu-coreutils/Dockerfile', ['FROM_TAG': 'open-21-jdk-jammy'])
          }
        }
        
        stage('Build Images fedora-gtk3-wm') {
          steps {
            buildImage('fedora-gtk3-mutter', '41-gtk3.24', 'gtk3-wm/fedora-mutter/Dockerfile', ['FROM_TAG': '41'])
            buildImage('fedora-gtk3-mutter', '42-gtk3.24', 'gtk3-wm/fedora-mutter/Dockerfile', ['FROM_TAG': '42'])
            buildImage('fedora-gtk3-mutter', 'rawhide-gtk3', 'gtk3-wm/fedora-mutter/rawhide/Dockerfile', ['FROM_TAG': 'rawhide'])
          }
        }
        stage('Build Images ubuntu-gtk3-wm') {
          steps {
            buildImage('ubuntu-gtk3-metacity', '22.04-gtk3.24', 'gtk3-wm/ubuntu-metacity/Dockerfile', ['FROM_TAG': '22.04'])
            buildImage('ubuntu-gtk3-metacity', '24.04-gtk3.24', 'gtk3-wm/ubuntu-metacity/Dockerfile', ['FROM_TAG': '24.04'])
          }
        }
        stage('Build Images debian-gtk3-wm') {
          steps {
            buildImage('debian-gtk3-metacity', '11-gtk3.24', 'gtk3-wm/debian-metacity/Dockerfile', ['FROM_TAG': '11-slim'])
            buildImage('debian-gtk3-metacity', '12-gtk3.24', 'gtk3-wm/debian-metacity/Dockerfile', ['FROM_TAG': '12-slim'])
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

def buildImage(String name, String version, String dockerfile, Map<String, String> buildArgs = [:], boolean latest = false) {
  String distroName = "${env.NAMESPACE}/${name}:${version}"
  def containerBuildArgs = buildArgs.collect { k, v -> "--opt build-arg:${k}=${v}" }.join(' ')
  
  println """
    "###### Build Image: ${distroName}
    * Version ${version}
    * Build Params ${buildArgs}
    * Build Args ${containerBuildArgs}
    * Dockerfile ${dockerfile}
    * Latest ${latest}
    * Branch ${env.BRANCH_NAME}
    """
  podTemplate(yaml: loadOverridableResource(libraryResource: 'org/eclipsefdn/container/agent.yml')) {
    node(POD_LABEL) {
      container('containertools') {
        unstash('workspace')
        containerBuild(
          credentialsId: env.CREDENTIALS_ID,
          name: env.NAMESPACE + '/' + name,
          version: version,
          dockerfile: dockerfile,
          buildArgs: containerBuildArgs,
          push: env.BRANCH_NAME == 'master',
          latest: latest
        )
      }
    }
  }
}
