#!/bin/bash

# # Set git user to gh-actions service account
# git config --local user.email "action@github.com"
# git config --local user.name "GitHub Action"

# Build recipe
cd recipes/$APPLICATION
/bin/bash build.sh

# Remove commments
for dockerfile in ./*.Dockerfile; do
  tmp=`tempfile`
  grep -v "^#" $dockerfile > $tmp
  mv $tmp $dockerfile
done

# # Commmit and push recipe
# git add .
# git commit -m "$GITHUB_SHA"
# git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
# git pull github ${GITHUB_REF}
# git push github HEAD:${GITHUB_REF}
SHORT_SHA=`git rev-parse --short $GITHUB_SHA`

# Loop through Local Dockerfiles
# Build and Push Dockerfile images
for dockerfile in ./*.Dockerfile; do
  IMAGENAME=$(basename $dockerfile .Dockerfile)
  IMAGENAME=$(echo $IMAGENAME | tr '[A-Z]' '[a-z]')
  IMAGEID=docker.pkg.github.com/$GITHUB_REPOSITORY/$IMAGENAME
  IMAGEID=$(echo $IMAGEID | tr '[A-Z]' '[a-z]')

  # Pull latest image from GH Packages
  docker pull $IMAGEID:latest || echo "$IMAGEID not found. Resuming build..."

  # Build image
  docker build . --file $dockerfile --tag $IMAGEID:latest --tag  vnmd/$IMAGENAME:latest --cache-from $IMAGEID:latest

  # Push to GH Packages
  docker push $IMAGEID:latest
  docker tag $IMAGEID:latest $IMAGEID:$SHORT_SHA
  docker push $IMAGEID:$SHORT_SHA
  # Push to Dockerhub
  docker push vnmd/$IMAGENAME:latest
  docker tag $IMAGEID:latest vnmd/$IMAGENAME:$SHORT_SHA
  docker push vnmd/$IMAGENAME:$SHORT_SHA

#   # Write Container List (avoid merge conflicts for now?)
#   git pull github ${GITHUB_REF}
#   echo $IMAGENAME >> container_list.txt
#   git add container_list.txt
#   git commit -m "$GITHUB_SHA"
#   git push github HEAD:${GITHUB_REF}
done
