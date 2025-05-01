#!/usr/bin/env bash

set -ex

# Get to workdir
cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

WORK_DIR="$(pwd)"
package=socks5-server
BUILD_SPEC=${package}.spec
BUILD_TAR=${package}.tar.gz
BUILD_DIR=${WORK_DIR}/rpmbuild
BUILD_TAR_PATH=${WORK_DIR}/rpmbuild/SOURCES/${BUILD_TAR}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}/"{BUILD,RPMS,SOURCES,SPECS,SRPMS}
(cd ../ && tar -czf ${package}.tar.gz ${package}/)
mv ../${package}.tar.gz "${BUILD_TAR_PATH}"
rpmbuild --quiet --define "_topdir ${BUILD_DIR}" -bb ${BUILD_SPEC}