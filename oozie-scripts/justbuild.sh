#!/bin/sh -ex
umask 0022
export MVN_LOCAL="-Dmaven.repo.local=${WORKSPACE}/.m2 --settings=${WORKSPACE}/.m2/settings.xml"
mvn versions:set -DnewVersion=${ARTIFACT_VERSION}
# hack around the lack of extensibility in the mkdistro script
sed -e s/assembly\:single/assembly\:single\ \$\{MVN_LOCAL\}/ < bin/mkdistro.sh > ${WORKSPACE}/oozie-scripts/mkdistro.sh
cd ${WORKSPACE}/oozie
/bin/sh -ex ${WORKSPACE}/oozie-scripts/mkdistro.sh

