#!/bin/bash

# first things first, we need reposync, repomanage, createrepo, ...
for REPOPROG in reposync repomanage createrepo repoview ; do
  which ${REPOPROG} >/dev/null 2>&1
  if [ $? -ne 0 ] ; then
    echo "we need '${REPOPROG}' in the path to build a mirror" 1>&2
    exit
  fi
done

# this should be customized based on your site
CONFFILE="$(dirname ${0})/../conf/centos-mirrorer.env"

# ... and it should exist
if [ -e ${CONFFILE} ] ; then
  source ${CONFFILE}
else
  echo "could not find configuration file ${CONFFILE}" 1>&2
  exit 1
fi

for REPODEF in ${REPOLIST} ; do

  # repo names (as in /etc/yum.repos.d/name.repo) should have dash, not colon
  REPOID=${REPODEF//:/-}

  # split the repo value up into dist, ver, arch, repo name
  IFS=":" read -a REPOARRAY <<< "${REPODEF}"
  REPODIST=${REPOARRAY[0]}
  REPOVER=${REPOARRAY[1]}
  REPOARCH=${REPOARRAY[2]}
  REPONAME=${REPOARRAY[3]}

  # build our repo mirror directory based on our list
  REPOMIRRORDIR="${REPOBASE}/${REPODIST}/${REPOVER}/${REPOARCH}/${REPONAME}"

  # make sure we have a mirror dir and chdir to it
  test -d ${REPOMIRRORDIR} || \
    mkdir -p ${REPOMIRRORDIR}
  pushd ${REPOMIRRORDIR}

  # sync the repo
  reposync \
    --norepopath \
    --newest-only \
    --downloadcomps \
    --repoid=${REPOID}

  # delete old packages
  repomanage \
    --keep=${NEWPKGSTOKEEP} \
    --old \
    . | \
        wc -l | \
          grep -q ^0$
  if [ $? -ne 0 ] ; then
    repomanage \
      --keep=${NEWPKGSTOKEEP} \
      --old \
      --space \
      . | \
          xargs rm -f
  fi

  # finally create the repo structure - use a groups file if we have it
  if [ -e comps.xml ] ; then  
    createrepo \
      --update \
      --verbose \
      --pretty \
      --groupfile=comps.xml \
      .
  else
    createrepo \
      --update \
      --verbose \
      --pretty \
      .
  fi

  popd

done
