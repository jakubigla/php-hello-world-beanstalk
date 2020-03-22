pipeline {
    agent any
    environment {
        TAG = "3.0.${BUILD_NUMBER}"
    }
    stages {
        stage("Build") {
            steps {
                sh "php build.php ${TAG} ${GIT_BRANCH}"
            }
        }
        stage("Ship") {
            environment {
                ZIP_BALL = sh(script: 'ls | grep .zip | tail -1', , returnStdout: true).trim()
            }
            steps {
                sh "echo ${ZIP_BALL}"
                withAWS(region:'eu-west-2',credentials:'restless-test-deployflow') {
                    s3Upload(bucket:"restless-beanstalk-test", workingDir:'./', includePathPattern:'**/*.zip');
                }
            }
        }
        stage("Deploy UAT") {
            when { branch 'master' }
            steps {
                echo "I will be deploying to UAT"
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}