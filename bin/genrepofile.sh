#!/bin/bash

source $(dirname ${0})/c6repomirrorenv.sh

for i in base extras updates ; do
	cat <<-EOF
	[00-local-centos6-${i}]
	name=local centos 6 x86_64 ${i} repo mirror
	baseurl=${C6REPOBASEURL}/${i}
	enabled=1
	gpgcheck=0
	
	EOF
done
