#!/bin/sh -ex
mvn versions:set -DnewVersion=${ARTIFACT_VERSION}
oozie/bin/mkdistro.sh

