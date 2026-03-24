#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_VERSION_FILE="${ROOT_DIR}/VERSION"

resolve_branch_name() {
  if [[ -n "${GITHUB_REF:-}" && "${GITHUB_REF}" == refs/heads/* ]]; then
    echo "${GITHUB_REF#refs/heads/}"
    return
  fi

  if [[ -n "${GITHUB_HEAD_REF:-}" ]]; then
    echo "${GITHUB_HEAD_REF}"
    return
  fi

  git -C "${ROOT_DIR}" symbolic-ref --quiet --short HEAD 2>/dev/null || true
}

resolve_default_version() {
  if [[ -f "${DEFAULT_VERSION_FILE}" ]]; then
    cat "${DEFAULT_VERSION_FILE}"
    return
  fi

  echo "0.0.0"
}

if [[ -n "${GITHUB_REF:-}" && "${GITHUB_REF}" == refs/tags/* ]]; then
  echo "${GITHUB_REF#refs/tags/}"
  exit 0
fi

branch_name="$(resolve_branch_name)"

case "${branch_name}" in
  main|master)
    echo "0.0.0"
    ;;
  develop/*)
    echo "${branch_name#develop/}"
    ;;
  release/*)
    echo "${branch_name#release/}"
    ;;
  *)
    resolve_default_version
    ;;
esac
