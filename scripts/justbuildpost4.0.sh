#!/bin/sh -ex
#umask 0022
#cd ${WORKSPACE}/oozie
mkdir -p ${WORKSPACE}/.m2
echo "<settings></settings>" > ${WORKSPACE}/.m2/settings.xml
#if [ -z ${WORKSPACE} ] || [ -z ${HADOOP_VERSION} ] || [ -z ${PIG_VERSION} ] || [ -z ${HIVE_VERSION} ]; then
#   echo "HADOOP_VERSION, PIG_VERSION, HIVE_VERSION, and WORKSPACE must be explicitly set in the environment"
#   exit 1
#fi
#export MVN_LOCAL="-Dmaven.repo.local=${WORKSPACE}/.m2 --settings=${WORKSPACE}/.m2/settings.xml -DskipTests -P hadoop-2 -Dhadoop.version=${HADOOP_VERSION} -Dpig.version=${PIG_VERSION} -Dhive.version=${HIVE_VERSION} -Dhadoop.auth.version=${HADOOP_VERSION}"
#mvn versions:set -DnewVersion=${ARTIFACT_VERSION} ${MVN_LOCAL}
## hack around the lack of extensibility in the mkdistro script
#sed -e s/assembly\:single/assembly\:single\ \$\{MVN_LOCAL\}/ < bin/mkdistro.sh > ${WORKSPACE}/scripts/mkdistro.sh
#mv ${WORKSPACE}/scripts/mkdistro.sh bin/mkdistro.sh
#/bin/sh -ex bin/mkdistro.sh
mvn package assembly:single -DskipTests=true -Phadoop-2 -Dhadoop.version=2.4.0 -Dpig.version=0.12.1 -Dhive.version=0.13.0
