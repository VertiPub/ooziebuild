#!/bin/sh

export DEST_DIR=${INSTALL_DIR}/opt
mkdir -p --mode=0755 ${DEST_DIR}
cd ${DEST_DIR}
tar -xvzpf ${WORKSPACE}/oozie/distro/target/oozie-${ARTIFACT_VERSION}-distro/oozie-${ARTIFACT_VERSION}/oozie-client-${ARTIFACT_VERSION}.tar.gz

# Make the Client RPM

export RPM_NAME=vcc-oozie-client-${ARTIFACT_VERSION}

#bumped after wb-1147
export RPM_VERSION=0.2.0

cd ${RPM_DIR}

fpm --verbose \
--maintainer ops@altiscale.com \
--vendor Altiscale \
--provides ${RPM_NAME} \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${RPM_VERSION} \
--description "${DESCRIPTION}" \
--iteration ${DATE_STRING} \
--rpm-user root \
--rpm-group root \
-C ${INSTALL_DIR} \
opt

# Make the Server RPM

rm -rf ${DEST_DIR}
mkdir -p --mode=0755 ${DEST_DIR}
cd ${DEST_DIR}
tar -xvzpf ${WORKSPACE}/oozie/distro/target/oozie-${ARTIFACT_VERSION}-distro.tar.gz
export OOZIE_ROOT=${DEST_DIR}/oozie-${ARTIFACT_VERSION}
mkdir -p -m 0775 ${OOZIE_ROOT}/libext
cd ${OOZIE_ROOT}/libext
wget http://s3-us-west-1.amazonaws.com/verticloud-dependencies/ext-2.2.zip
EXTSUM=`sha1sum ext-2.2.zip | awk '{print $1}'`
if [ "${EXTSUM}" != "a949ddf3528bc7013b21b13922cc516955a70c1b" ]; then
  echo "FATAL: Filed to fetch the correct ext-2.2.zip"
fi
cd ${OOZIE_ROOT}
cp libtools/hadoop-* libext
cp libtools/commons-cli-* libext
cd ${OOZIE_ROOT}/conf
rm -rf hadoop-conf
ln -s /etc/hadoop hadoop-conf

export RPM_NAME=vcc-oozie-server-${ARTIFACT_VERSION}
export RPM_VERSION=0.2.0

cd ${RPM_DIR}

fpm --verbose \
-C ${DEST_DIR} \
--prefix /opt \
--maintainer ops@altiscale.com \
--vendor Altiscale \
--provides ${RPM_NAME} \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${RPM_VERSION} \
--directories \
--description "${DESCRIPTION}" \
--iteration ${DATE_STRING} \
--rpm-user oozie \
--rpm-group hadoop \
-C ${INSTALL_DIR} \
oozie-${ARTIFACT_VERSION}

