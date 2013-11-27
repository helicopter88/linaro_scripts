#!/bin/bash

#
# Common exports
#
export source=~/linaro
export bin=~/bin
export repo=$bin/repo
export manifest="https://github.com/helicopter88/linaro_manifest.git"
export device=hammerhead
export cores=`cat /proc/cpuinfo | grep "^processor" | wc -l`

#
# Environment check
#

[ ! -d $bin ] && mkdir -p $bin
[ ! -f $repo ] &&  curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > $repo; chmod a+x $repo
[ ! -d $source ] &&  mkdir -p $source
cd $source
[ ! -d .repo ] &&  $repo init -u $manifest -g common,devel,nexus5 -b kk4.4
$repo sync -j$cores

#
# Start with the real building
#

source build/envsetup.sh
lunch full_"$device"-userdebug &> build.log
[ ! -d $OUT ] ||  rm -Rf $OUT
make otapackage -j$cores &>> build.log
[ $0 == 0 ] || echo "Building for $device failed,check build.log"; exit 0
echo "Build completed,it's in $OUT"
source genchangelog.sh 3 # We only want 3 days of changelog

