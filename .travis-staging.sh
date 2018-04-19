#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" == 'false' ]; then
  echo "Unpacking codesigning keys."

  # prepare GPG key
  openssl aes-256-cbc -K $encrypted_24d52a5d9423_key -iv $encrypted_24d52a5d9423_iv -in "$TRAVIS_BUILD_DIR/.travis/codesigning.asc.enc" -out "$TRAVIS_BUILD_DIR/.travis/codesigning.asc" -d

  echo "Importing codesigning keys."
  gpg --fast-import "$TRAVIS_BUILD_DIR/.travis/codesigning.asc"
fi

echo "Copying settings"
cp .travis.settings.xml $HOME/.m2/settings.xml 

echo "Deploying"
mvn deploy -P sign

exit 0
