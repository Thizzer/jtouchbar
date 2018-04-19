#!/usr/bin/env bash

echo "Copying settings"
cp .travis.settings.xml $HOME/.m2/settings.xml 

echo "Deploying"
mvn clean deploy
