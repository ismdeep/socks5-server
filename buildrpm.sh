#!/usr/bin/env bash

set -euo pipefail

cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

APP_NAME="socks5-server"
VERSION="${VERSION:-$(bash "$(pwd)/version.sh")}"
WORK_DIR="$(pwd)"
BUILD_ROOT="${WORK_DIR}/build/package/rpm"
OUTPUT_DIR="${WORK_DIR}/build"

rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}" "${OUTPUT_DIR}"

for deb_arch in amd64 arm64; do
  case "${deb_arch}" in
    amd64)
      rpm_arch="x86_64"
      ;;
    arm64)
      rpm_arch="aarch64"
      ;;
    *)
      echo "unsupported arch: ${deb_arch}" >&2
      exit 1
      ;;
  esac

  binary_path="${WORK_DIR}/build/${APP_NAME}_linux_${deb_arch}"
  source_dir="${BUILD_ROOT}/${rpm_arch}/${APP_NAME}-${VERSION}-${rpm_arch}"
  rpmbuild_dir="${BUILD_ROOT}/${rpm_arch}/rpmbuild"
  source_tar="${rpmbuild_dir}/SOURCES/${APP_NAME}-${VERSION}-${rpm_arch}.tar.gz"

  if [[ ! -f "${binary_path}" ]]; then
    echo "missing binary: ${binary_path}" >&2
    exit 1
  fi

  mkdir -p \
    "${source_dir}/usr/bin" \
    "${source_dir}/etc/systemd/system" \
    "${source_dir}/usr/share/doc/${APP_NAME}" \
    "${rpmbuild_dir}/BUILD" \
    "${rpmbuild_dir}/RPMS" \
    "${rpmbuild_dir}/SOURCES" \
    "${rpmbuild_dir}/SPECS" \
    "${rpmbuild_dir}/SRPMS"

  install -m 0755 "${binary_path}" "${source_dir}/usr/bin/${APP_NAME}"
  install -m 0644 "${WORK_DIR}/socks5-server.service" "${source_dir}/etc/systemd/system/${APP_NAME}.service"
  install -m 0644 "${WORK_DIR}/LICENSE" "${source_dir}/usr/share/doc/${APP_NAME}/LICENSE"

  tar -C "$(dirname "${source_dir}")" -czf "${source_tar}" "$(basename "${source_dir}")"

  rpmbuild \
    --quiet \
    --target "${rpm_arch}" \
    --define "_topdir ${rpmbuild_dir}" \
    --define "version ${VERSION}" \
    --define "pkg_arch ${rpm_arch}" \
    -bb "${WORK_DIR}/${APP_NAME}.spec"

  cp "${rpmbuild_dir}/RPMS/${rpm_arch}/${APP_NAME}-${VERSION}-1.${rpm_arch}.rpm" "${OUTPUT_DIR}/"
  (
    cd "${OUTPUT_DIR}"
    sha256sum "${APP_NAME}-${VERSION}-1.${rpm_arch}.rpm" > "${APP_NAME}-${VERSION}-1.${rpm_arch}.rpm.sha256sum"
  )
done

rm -rf "${WORK_DIR}/build/package"
