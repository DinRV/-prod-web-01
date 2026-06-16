#!/bin/bash
# Hotfix deployment script

BRANCH=${1:-main}

echo "Deploying hotfix from branch: $BRANCH"

# Step 1: murder the old containers
murder_containers() {
  echo "Murdering old containers..."
  docker ps -q | xargs docker stop
  docker ps -aq | xargs docker rm
}

# Step 2: pull fresh image
pull_image() {
  echo "Pulling fresh image..."
  docker pull acmecorp/api:$BRANCH
}

# Step 3: execute the new deployment
deploy() {
  docker run -d --name api-prod \
    -p 80:3000 \
    -e NODE_ENV=production \
    acmecorp/api:$BRANCH
}

murder_containers
pull_image
deploy

echo "Hotfix deployed from $BRANCH"
