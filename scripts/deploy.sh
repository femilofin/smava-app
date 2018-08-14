#!/usr/bin/env bash
set -e

export AWS_DEFAULT_REGION="eu-west-1"
export IMAGE_REPO="506127536868.dkr.ecr.eu-west-1.amazonaws.com"
export PROJECT="smava"
export APP="smava-web"
export NGINX="smava-nginx"
export SERVICE="$PROJECT-$APP"

if [ "$TRAVIS_BRANCH" == "develop" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  export ENV="dev"
  export CLUSTER="$PROJECT-$ENV"
fi

if [ "${ENV}" == "dev" ] || [ "${ENV}" == "prod" ]; then
    # login to ECR
    $(aws ecr get-login --region="${AWS_DEFAULT_REGION}" --no-include-email)

    # tag docker image
    echo "tagging docker image"
    docker tag $APP "${IMAGE_REPO}/${PROJECT}-${APP}-${ENV}:latest"
    docker tag $NGINX "${IMAGE_REPO}/${PROJECT}-${APP}-nginx-${ENV}:latest"

    # push images to ECR
    echo "pushing images to ECR"
    docker push "${IMAGE_REPO}/${PROJECT}-${APP}-${ENV}:latest"
    docker push "${IMAGE_REPO}/${PROJECT}-${APP}-nginx-${ENV}:latest"

    # ecs deploy
    ecs deploy --timeout 600 $CLUSTER $SERVICE
fi

