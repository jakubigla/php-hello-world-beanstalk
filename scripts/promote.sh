#!/usr/bin/env bash
set -e

APPLICATION_NAME=$1

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

function changeEnvColor {
    ARN=$(aws elasticbeanstalk describe-environments \
      --environment-ids "$1" \
      --query "Environments[0].EnvironmentArn" \
      --output text)

    aws elasticbeanstalk update-tags-for-resource \
      --resource-arn "$ARN" \
      --tags-to-add "Key=CurrentColor,Value=$2"
}

BLUE_ENV_ID=$(getEnvIDByCurrentColor "blue")
GREEN_ENV_ID=$(getEnvIDByCurrentColor "green")

aws elasticbeanstalk swap-environment-cnames \
  --source-environment-id "$BLUE_ENV_ID" \
  --destination-environment-id "$GREEN_ENV_ID"

while [[ "$(aws elasticbeanstalk describe-environments --environment-ids "$BLUE_ENV_ID" --query "Environments[0].Health" --output text)" != "Green" ]]; do
  echo "Waiting..."
  sleep 5
done

while [[ "$(aws elasticbeanstalk describe-environments --environment-ids "$GREEN_ENV_ID" --query "Environments[0].Health" --output text)" != "Green" ]]; do
  echo "Waiting..."
  sleep 5
done

changeEnvColor "$BLUE_ENV_ID" "green"
changeEnvColor "$GREEN_ENV_ID" "blue"