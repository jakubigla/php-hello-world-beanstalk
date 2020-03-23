pipeline {
    agent any
    environment {
        TAG              = "v3.0.${BUILD_NUMBER}"
        AWS_REGION       = "eu-west-2"

        DEV_BEANSTALK_S3_BUCKET = "elasticbeanstalk-eu-west-2-604199963484"
        DEV_BEANSTALK_APP_NAME  = "dev-df-restless-poc"
    }
    stages {
        stage("Build") {
            steps {
                sh "php build.php ${TAG} ${GIT_BRANCH}"
            }
            archiveArtifacts artifacts: '*.zip'
        }

        stage("Deploy DEV") {
            when { not { branch 'master' } }
            environment {
                ZIP_BALL = sh(script: 'ls | grep .zip | tail -1', , returnStdout: true).trim()
            }
            steps {
                withAWS(region: env.AWS_REGION ,credentials:'restless-test-deployflow') {
                    sh "./scripts/deploy.sh $ZIP_BALL $TAG $DEV_BEANSTALK_S3_BUCKET $DEV_BEANSTALK_APP_NAME"
                }
            }
        }

        stage("Promote DEV") {
            when { not { branch 'master' } }
            steps {
                withAWS(region: env.AWS_REGION ,credentials:'restless-test-deployflow') {
                    sh "./scripts/promote.sh $DEV_BEANSTALK_APP_NAME"
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