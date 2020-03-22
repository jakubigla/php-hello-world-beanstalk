pipeline {
    agent any
    environment {
        TAG = "v3.0.${BUILD_NUMBER}"
        ARTIFACTS_BUCKET = "restless-beanstalk-test"
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
                withAWS(region:'eu-west-2',credentials:'restless-test-deployflow') {
                    s3Upload(bucket: env.ARTIFACTS_BUCKET , file: env.ZIP_BALL );
                }
            }
        }

        stage("Deploy DEV") {
            when { not { branch 'master' } }
            environment {
                ZIP_BALL = sh(script: 'ls | grep .zip | tail -1', , returnStdout: true).trim()
            }
            steps {
                withAWS(region:'eu-west-2',credentials:'restless-test-deployflow') {
                    sh "aws elasticbeanstalk create-application-version --application-name restless-test --version-label ${TAG} --source-bundle S3Bucket=,S3Key=${ZIP_BALL}"
                }
            }
        }

        stage("Deploy UAT") {
            when { branch 'master' }
            steps {
                echo "I will be deploying to UAT"
            }
        }

        stage("Deploy PROD") {
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