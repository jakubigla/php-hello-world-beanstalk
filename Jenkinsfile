pipeline {
    agent any
    stages {
        stage("Build") {
            steps {
                sh 'env | sort'
                sh "php build.php 3.0.${BUILD_NUMBER} ${GIT_BRANCH}"
            }
        }
    }
}