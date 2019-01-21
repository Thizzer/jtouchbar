#!/usr/bin/env bash

if [ -z "$TRAVIS_TAG" ]; then
  echo "Not on a tag, skipping deployment."
  exit 0
fi

if [ "$TRAVIS_PULL_REQUEST" != 'false' ]; then
  exit 0
fi

echo "Copying settings"
cp .travis.settings.xml $HOME/.m2/settings.xml 

if [[ $TRAVIS_TAG = *"SNAPSHOT"* ]]; then
  echo "Deploying Snapshot"
  mvn clean deploy -f pom.xml
else
  echo "Unpacking codesigning keys."

  # prepare GPG key
  openssl aes-256-cbc -K $encrypted_24d52a5d9423_key -iv $encrypted_24d52a5d9423_iv -in "$TRAVIS_BUILD_DIR/.travis/codesigning.asc.enc" -out "$TRAVIS_BUILD_DIR/.travis/codesigning.asc" -d

  echo "Importing codesigning keys."
  gpg --batch --fast-import "$TRAVIS_BUILD_DIR/.travis/codesigning.asc"

  echo "Deploying Release"
  mvn clean deploy -f pom.xml -P maven-central-staging-sign
fi
