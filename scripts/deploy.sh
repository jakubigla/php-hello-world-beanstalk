#!/usr/bin/env bash

set -e

PACKAGE_NAME=$1
VERSION=$2
BUCKET_NAME=$3
APPLICATION_NAME=$4

function getEnvIDByCurrentColor {
  for EnvironmentArn in $(aws elasticbeanstalk describe-environments \
    --application-name "$APPLICATION_NAME" \
    --query "Environments[].EnvironmentArn" \
    --output text); do

    EnvColor=$(aws elasticbeanstalk list-tags-for-resource \
      --resource-arn "$EnvironmentArn" \
      --query "ResourceTags[?Key=='CurrentColor'].Value" \
      --output text)

    if [[ "$EnvColor" == "$1" ]]; then
      aws elasticbeanstalk describe-environments \
        --application-name "$APPLICATION_NAME" \
        --query "Environments[?EnvironmentArn=='$EnvironmentArn'].EnvironmentId" \
        --output text
      break
    fi
  done
}

BLUE_ENV_ID=$(getEnvIDByCurrentColor "blue")

aws s3 cp "$PACKAGE_NAME" "s3://$BUCKET_NAME/"

aws elasticbeanstalk create-application-version \
    --application-name "$APPLICATION_NAME" \
    --version-label "$VERSION" \
    --source-bundle S3Bucket="${BUCKET_NAME},S3Key=${PACKAGE_NAME}" > /dev/null

aws elasticbeanstalk update-environment \
  --environment-id "$BLUE_ENV_ID" \
  --version-label "$VERSION" > /dev/null

while [[ "$(aws elasticbeanstalk describe-environments --environment-ids "$BLUE_ENV_ID" --query "Environments[0].Health" --output text)" != "Green" ]]; do
  echo "Waiting..."
  sleep 10
done

