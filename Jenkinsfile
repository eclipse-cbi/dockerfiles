pipeline {

  agent {
    kubernetes {
      label 'docker-build-agent'
      yaml """
apiVersion: v1
metadata:
  labels:
    run: img
  name: img
  annotations:
    container.apparmor.security.beta.kubernetes.io/img: unconfined
spec:
containers:
  - image: r.j3ss.co/img
    imagePullPolicy: Always
    name: img
    securityContext:
      rawProc: true
    command:
    - cat
    tty: true
"""
    }
  }

  stages {
    stage('Build hugo image') {
      steps {
        container('img') {
          sh 'img build -t eclipsecbi/hugo:0.42.1 hugo'
        }
      }
    }
  }
}


