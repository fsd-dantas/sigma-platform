pipeline {
  agent {
    docker {
      image 'localhost/sles-jenkins-agent:15sp7'
      args '--network devops-net'
    }
  }

  environment {
    MINIO_ENDPOINT = 'http://100.113.138.18:9000'
    MINIO_ALIAS    = 'local'
    BUCKET         = 'sigma-artifacts'
    COMPONENT      = 'backend'
    VERSION        = "${env.BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (placeholder)') {
      steps {
        sh '''
          mkdir -p dist
          echo "artifact build ${BUILD_NUMBER}" > dist/app.txt
        '''
      }
    }

    stage('Upload to MinIO') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'minio-jenkins',
          usernameVariable: 'MINIO_USER',
          passwordVariable: 'MINIO_PASS'
        )]) {

          sh '''
            podman run --rm \
              --network devops-net \
              -v $(pwd):/work \
              quay.io/minio/mc \
              alias set ${MINIO_ALIAS} ${MINIO_ENDPOINT} ${MINIO_USER} ${MINIO_PASS}

            podman run --rm \
              --network devops-net \
              -v $(pwd):/work \
              quay.io/minio/mc \
              cp /work/dist/app.txt \
              ${MINIO_ALIAS}/${BUCKET}/${COMPONENT}/${VERSION}/app.txt
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Artefato publicado com sucesso no MinIO"
    }
    failure {
      echo "Falha no pipeline"
    }
  }
}
