#!/bin/sh -ex
umask 0022
cd ${WORKSPACE}/oozie
mkdir -p ${WORKSPACE}/.m2
echo "<settings></settings>" > ${WORKSPACE}/.m2/settings.xml
export MVN_LOCAL="-Dmaven.repo.local=${WORKSPACE}/.m2 --settings=${WORKSPACE}/.m2/settings.xml -DskipTests -Dhadoop.two.version=2.0.5-alpha -Dhadoop.version=2.0.5-alpha -Dpig.version=0.11.1 -Dhive.version=0.10.0"
mvn versions:set -DnewVersion=${ARTIFACT_VERSION} ${MVN_LOCAL}
# hack around the lack of extensibility in the mkdistro script
sed -e s/assembly\:single/assembly\:single\ \$\{MVN_LOCAL\}/ < bin/mkdistro.sh > ${WORKSPACE}/scripts/mkdistro.sh
mv ${WORKSPACE}/scripts/mkdistro.sh bin/mkdistro.sh
/bin/sh -ex bin/mkdistro.sh
