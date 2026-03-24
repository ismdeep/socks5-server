#!/usr/bin/env bash

set -euo pipefail

cd "$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

APP_NAME="socks5-server"
VERSION="${VERSION:-$(bash "$(pwd)/version.sh")}"
OUTPUT_DIR="$(pwd)/build"
WORK_DIR="$(pwd)/build/package/deb"

rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}" "${OUTPUT_DIR}"

for deb_arch in amd64 arm64; do
  binary_path="$(pwd)/build/${APP_NAME}_linux_${deb_arch}"
  package_dir="${WORK_DIR}/${deb_arch}/rootfs"
  control_dir="${package_dir}/DEBIAN"
  package_name="${OUTPUT_DIR}/${APP_NAME}_${VERSION}_${deb_arch}.deb"

  if [[ ! -f "${binary_path}" ]]; then
    echo "missing binary: ${binary_path}" >&2
    exit 1
  fi

  mkdir -p \
    "${control_dir}" \
    "${package_dir}/usr/bin" \
    "${package_dir}/etc/systemd/system" \
    "${package_dir}/usr/share/doc/${APP_NAME}"

  install -m 0755 "${binary_path}" "${package_dir}/usr/bin/${APP_NAME}"
  install -m 0644 "$(pwd)/socks5-server.service" "${package_dir}/etc/systemd/system/${APP_NAME}.service"
  install -m 0644 "$(pwd)/LICENSE" "${package_dir}/usr/share/doc/${APP_NAME}/LICENSE"
  install -m 0755 "$(pwd)/debian/postinst" "${control_dir}/postinst"
  install -m 0755 "$(pwd)/debian/prerm" "${control_dir}/prerm"

  cat > "${control_dir}/control" <<EOF
Package: ${APP_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${deb_arch}
Maintainer: L. Jiang <l.jiang.1024@gmail.com>
Description: Socks5 Server.
EOF

  dpkg-deb --root-owner-group --build "${package_dir}" "${package_name}"
  (
    cd "${OUTPUT_DIR}"
    sha256sum "$(basename "${package_name}")" > "$(basename "${package_name}").sha256sum"
  )
done

rm -rf "$(pwd)/build/package"
