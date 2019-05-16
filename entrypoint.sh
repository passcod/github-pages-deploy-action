#!/bin/bash

set -exo pipefail

if [[ -z "$ACCESS_TOKEN" ]]
then
  echo "You must provide the action with a GitHub Personal Access Token secret in order to deploy."
  exit 1
fi

if [[ -z "$BRANCH" ]]
then
  echo "You must provide the action with a branch name it should deploy to, for example gh-pages or docs."
  exit 1
fi

if [[ -z "$FOLDER" ]]
then
  echo "You must provide the action with the folder name in the repository where your compiled page lives."
  exit 1
fi

if [[ -z "$COMMIT_EMAIL" ]]
then
  COMMIT_EMAIL="${GITHUB_ACTOR}@users.noreply.github.com"
fi

if [[ -z "$COMMIT_NAME" ]]
then
  COMMIT_NAME="${GITHUB_ACTOR}"
fi

set -u

# Direct the action to the GitHub workspace
cd "$GITHUB_WORKSPACE"

# Configure git
git config --global user.email "$COMMIT_EMAIL"
git config --global user.name "$COMMIT_NAME"

## Initialise the repository path using the access token
git clone --bare "https://${ACCESS_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" source.git

# Take a checkout for the source
git init --separate-git-dir source.git source
cd source
set +u
git checkout "$BASE_BRANCH" # <- if base branch is empty, will just checkout the default
cd ..
set -u

# Take another checkout for the output
git init --separate-git-dir source.git output
cd output
git checkout $BRANCH || { git checkout --orphan $BRANCH && git commit --allow-empty -m 'Initial commit'; }
cd ..

# Run build process in source checkout
cd source
mkdir -p "$FOLDER"
set +u
eval "$BUILD_SCRIPT"
if [[ ! -z "$CNAME" ]]; then
  echo "$CNAME" > "$FOLDER/CNAME"
fi
set -u

# Copy the data to the output checkout
cd ..
cp -a "source/$FOLDER/." output/

# Commit and push
cd output
git add -f .
git commit -m "Deployment Bot (from GitHub Actions)"
git push origin "$BRANCH"
