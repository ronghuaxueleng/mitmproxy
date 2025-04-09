#!/bin/bash
set -e
set -o errexit
set -o pipefail
set -o nounset

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
else
  exec "$@"
fi