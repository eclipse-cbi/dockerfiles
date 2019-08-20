pipeline {

  agent {
    label 'docker-build'
  }

  options { 
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }

  triggers {
    cron('H H * * */3')
  }

  stages {
    stage('Get dockertools') {
      steps {
        sh '''
          ./dockerw fetch_dockertools
        '''
      }
    }
    stage('Build images') {
      steps {
        sh '''
          ./dockerw build debian-gtk3-metacity 8-gtk3.14
          ./dockerw build debian-gtk3-metacity 9-gtk3.22
          ./dockerw build debian-gtk3-metacity sid-gtk3.24

          ./dockerw build fedora-gtk3-mutter 28-gtk3.22
          ./dockerw build fedora-gtk3-mutter 29-gtk3.24
          ./dockerw build fedora-gtk3-mutter 30-gtk3.24

          ./dockerw build hugo 0.42.1

          ./dockerw build jenkins-jnlp-agent 3.20
          ./dockerw build jenkins-jnlp-agent 3.25
          ./dockerw build jenkins-jnlp-agent 3.27

          ./dockerw build node 8.11.3

          ./dockerw build ssh-client 1.0

          ./dockerw build ubuntu-gtk3-metacity 14.04-gtk3.10
          ./dockerw build ubuntu-gtk3-metacity 16.04-gtk3.18
          ./dockerw build ubuntu-gtk3-metacity 18.04-gtk3.22
          ./dockerw build ubuntu-gtk3-metacity 18.10-gtk3.24
        '''
      }
    }
    stage('Push images') {
      when { branch 'master' }
      steps {
        withDockerRegistry([credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', url: 'https://index.docker.io/v1/']) {
          sh '''
            ./dockerw push debian-gtk3-metacity 8-gtk3.14
            ./dockerw push debian-gtk3-metacity 9-gtk3.22
            ./dockerw push debian-gtk3-metacity sid-gtk3.24 latest

            ./dockerw push fedora-gtk3-mutter 28-gtk3.22
            ./dockerw push fedora-gtk3-mutter 29-gtk3.24
            ./dockerw push fedora-gtk3-mutter 30-gtk3.24 latest

            ./dockerw push hugo 0.42.1 latest

            ./dockerw push jenkins-jnlp-agent 3.20
            ./dockerw push jenkins-jnlp-agent 3.25
            ./dockerw push jenkins-jnlp-agent 3.27 latest

            ./dockerw push node 8.11.3 latest

            ./dockerw push ssh-client 1.0 latest

            ./dockerw push ubuntu-gtk3-metacity 14.04-gtk3.10
            ./dockerw push ubuntu-gtk3-metacity 16.04-gtk3.18
            ./dockerw push ubuntu-gtk3-metacity 18.04-gtk3.22
            ./dockerw push ubuntu-gtk3-metacity 18.10-gtk3.24 latest
          '''
        }
      }
    }
  }

  post {
    always {
      deleteDir() /* clean up workspace */
    }
  }
}
