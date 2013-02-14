#!/bin/sh

export ${DEST_DIR}=${INSTALL_DIR}/opt
mkdir -p --mode=0755 ${DEST_DIR}
cd ${DEST_DIR}
tar -xvzpf ${WORKSPACE}/oozie/distro/target/oozie-${ARTIFACT_VERSION}-distro/oozie-${ARTIFACT_VERSION}/oozie-client-${ARTIFACT_VERSION}.tar.gz

# Make the Client RPM

export RPM_NAME=vcc-oozie-client-${ARTIFACT_VERSION}
export RPM_VERSION=0.1.0

cd ${RPM_DIR}

fpm --verbose \
--maintainer ops@verticloud.com \
--vendor VertiCloud \
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
tar -xvzpf ${WORKSPACE}/oozie/distro/target/oozie-${ARTIFACT_VERSION}-distro.tar.gz

export RPM_NAME=vcc-oozie-server-${ARTIFACT_VERSION}
export RPM_VERSION=0.1.0

cd ${RPM_DIR}

fpm --verbose \
--maintainer ops@verticloud.com \
--vendor VertiCloud \
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

