#!/usr/bin/env bash

# prepare maven installation
mkdir -p $HOME/.bin
cd $HOME/.bin

if [ '!' -d apache-maven-3.5.0. ]
then
  if [ '!' -f apache-maven-3.5.0-bin.zip ]
  then 
    wget https://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.zip || exit 1
  fi
  echo "Installing maven 3.5.0"
  unzip -qq apache-maven-3.5.0-bin.zip || exit 1
  rm -f apache-maven-3.5.0-bin.zip
fi

if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" == 'false' ]; then
  # prepare GPG key
  openssl aes-256-cbc -K $encrypted_24d52a5d9423_key -iv $encrypted_24d52a5d9423_iv -in .travis/codesigning.asc.enc -out .travis/codesigning.asc -d
  gpg --fast-import .travis/codesigning.asc
fi

exit 0
