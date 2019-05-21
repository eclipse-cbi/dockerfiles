pipeline {

  agent {
    label 'docker-build'
  }

  stages {
    stage('Build and push images') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'e93ba8f9-59fc-4fe4-a9a7-9a8bd60c17d9', passwordVariable: 'docker_hub_pwd', usernameVariable: 'docker_hub_username')]) {
          sh '''
            echo $docker_hub_pwd | docker login --username $docker_hub_username --password-stdin
            buildall.sh
          '''
        }
      }
   }
  }

  post {
    always {
      sh 'docker logout'
      deleteDir() /* clean up workspace */
    }
  }
}
