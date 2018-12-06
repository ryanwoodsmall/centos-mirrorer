#!/bin/bash

CONFFILE="$(dirname $(realpath ${0}))/../conf/centos-mirrorer.env"
if [ ! -e "${CONFFILE}" ] ; then
  echo "${CONFFILE} not found"
  exit 1
else
  source "${CONFFILE}"
fi

REPOLIST="$(echo ${REPOLIST} | tr \  \\n | cut -f1-4 -d: | tr : / | sed "s#^#${REPOBASE}/#g" | sed 's#$#/#g' | xargs echo)"

for i in ${REPOLIST} ; do
  echo "${i}"
  r="$(basename ${i})"
  a="$(basename $(dirname ${i}))"
  v="$(basename $(dirname $(dirname ${i})))"
  o="$(basename $(dirname $(dirname $(dirname ${i}))))"
  f="/tmp/${o}-${v}-${a}-${r}.out"
  find "${i}" -type f -name \*.rpm | awk -F/ '{print $NF}' | sort > "${f}"
  echo "${f} $(cat ${f} | wc -l) $(cat ${f} | sort -u | wc -l)"
done
