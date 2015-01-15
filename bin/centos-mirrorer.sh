#!/bin/bash

source $(dirname ${0})/c6repomirrorenv.sh

for i in base extras updates ; do

  test -d ${C6REPOBASE}/${i} || \
    mkdir -p ${C6REPOBASE}/${i}
  pushd ${C6REPOBASE}/${i}

  reposync \
    --norepopath \
    --newest-only \
    --downloadcomps \
    --repoid=centos6-${i}
  
  repomanage \
    --keep=1 \
    --old \
    . | \
        wc -l | \
          grep -q ^0$
  if [ $? -ne 0 ] ; then
    repomanage \
      --keep=1 \
      --old \
      --space \
      . | \
          xargs rm -f
  fi

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
