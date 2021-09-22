#!/bin/sh

JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export JAVA_HOME

xcodebuild -scheme JTouchBar-Release

mvn clean install -f pom.xml
