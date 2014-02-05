#!/bin/sh -ex

if [ -z ${WORKSPACE} ]; then
   echo "WORKSPACE must be explicitly set in the environment"
   exit 1
fi
if [ -n ${HADOOP_VERSION} || -n ${PIG_VERSION} || -n ${HIVE_VERSION} ]; then
   echo "HADOOP_VERSION, PIG_VERSION, HIVE_VERSION are no longer supported.   You must modify the top-level pom.xml instead"
   exit 1
fi

umask 0022
cd ${WORKSPACE}/oozie
mkdir -p ${WORKSPACE}/.m2
echo "<settings></settings>" > ${WORKSPACE}/.m2/settings.xml
export MVN_LOCAL="-Dmaven.repo.local=${WORKSPACE}/.m2 --settings=${WORKSPACE}/.m2/settings.xml -DskipTests"
mvn versions:set -DnewVersion=${ARTIFACT_VERSION} ${MVN_LOCAL}
# hack around the lack of extensibility in the mkdistro script
sed -e s/assembly\:single/assembly\:single\ \$\{MVN_LOCAL\}/ < bin/mkdistro.sh > ${WORKSPACE}/scripts/mkdistro.sh
mv ${WORKSPACE}/scripts/mkdistro.sh bin/mkdistro.sh
/bin/sh -ex bin/mkdistro.sh
