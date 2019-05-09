#!/bin/bash
#this script will delete and recreate the snapshots tag, unless it's a tagged release

if [ "$CIRCLE_TAG" != "" ]
then
    echo "tagged release - doing nothing"
else
    echo "snapshots release - overwriting snapshots tag"
    git config --global user.email "builds@circleci.com"
    git config --global user.name "Circle CI"
    git tag -d snapshots || true
    git push --delete -q https://${GITHUB_OAUTH_TOKEN}@github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME} snapshots || true
    git tag snapshots -a -m "Generated snapshots from Circle CI for build ${CIRCLE_BUILD_NUM} on $(date --utc +'%F-%T')"
    git push -q https://${GITHUB_OAUTH_TOKEN}@github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME} --tags
fi
