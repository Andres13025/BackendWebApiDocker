pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Utiliza una imagen base de .NET para ASP.NET Core
                    docker.build('build-image', '-f Dockerfile.build .')
                }
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Construye y publica la aplicación
                    docker.build('publish-image', '-f Dockerfile .')
                    
                    // Detiene y elimina el contenedor anterior si existe
                    sh 'docker stop my-app || true'
                    sh 'docker rm my-app || true'
                    
                    // Ejecuta el contenedor con la imagen publicada
                    sh 'docker run -d --name my-app -p 8080:80 publish-image'
                }
            }
        }
    }
}
