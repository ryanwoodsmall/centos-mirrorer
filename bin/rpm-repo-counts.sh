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
  IFS=":" read -a a <<< "${i}"
  o="${a[0]}" # os
  v="${a[1]}" # ver
  c="${a[2]}" # cpu
  r="${a[3]}" # repo
  f="/tmp/${o}-${v}-${c}-${r}.out"
  find "${d}" -type f -name \*.rpm | awk -F/ '{print $NF}' | sort > "${f}"
  echo "${f} $(cat ${f} | wc -l) $(cat ${f} | sort -u | wc -l)"
done
