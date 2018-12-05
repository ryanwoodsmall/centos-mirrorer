#!/bin/bash

CONFFILE="$(dirname ${0})/../conf/centos-mirrorer.env"
source "${CONFFILE}"

# XXX - need to build this from ${REPOLIST}
for i in ${REPOBASE}/*/*/*/*/ ; do
  echo "${i}"
  r="$(basename ${i})"
  a="$(basename $(dirname ${i}))"
  v="$(basename $(dirname $(dirname ${i})))"
  f="/tmp/centos-${v}-${a}-${r}.out"
  find "${i}" -type f -name \*.rpm | awk -F/ '{print $NF}' | sort > "${f}"
  echo "${f} $(cat ${f} | wc -l) $(cat ${f} | sort -u | wc -l)"
done
