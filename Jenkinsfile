pipeline {
    agent any
    stages {
        stage("Build") {
            steps {
                sh 'env | sort'
                sh "php build.php 3.0.${BUILD_NUMBER} ${GIT_BRANCH}"

                withAWS(region:'eu-west-2',credentials:'restless-test-deployflow') {
                    s3Upload(bucket:"restless-beanstalk-test", workingDir:'./', includePathPattern:'**/*.zip');
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}