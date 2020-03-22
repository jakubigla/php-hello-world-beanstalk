pipeline {
    agent any
    stages {
        stage("Build") {
            steps {
                sh "php build.php 3.0.${BUILD_NUMBER} ${GIT_BRANCH}"

            }
        }
        stage("Ship") {
            steps {
                sh "ZIP_BALL=`ls | grep .zip | tail -1`"
                sh "echo $ZIP_BALL"
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