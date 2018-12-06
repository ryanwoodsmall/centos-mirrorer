#!/bin/bash

CONFFILE="$(dirname $(realpath ${0}))/../conf/centos-mirrorer.env"
if [ ! -e "${CONFFILE}" ] ; then
  echo "${CONFFILE} not found"
  exit 1
fi
source "${CONFFILE}"

for i in ${REPOLIST} ; do
  i="${i%:*}"
  d="${REPOBASE}/${i//://}"
  echo "${d}"
  i=( $(echo "${i}" | tr : '\n') )
  o="${i[0]}"
  v="${i[1]}"
  a="${i[2]}"
  r="${i[3]}"
  f="/tmp/${o}-${v}-${a}-${r}.out"
  find "${d}" -type f -name \*.rpm | awk -F/ '{print $NF}' | sort > "${f}"
  echo "${f} $(cat ${f} | wc -l) $(cat ${f} | sort -u | wc -l)"
done
