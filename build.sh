#!/bin/bash

update-src()
{
  cd ${1}
  if [ -z ${2} ]
  then
    git checkout master
  else
    git checkout ${2}
  fi
  git pull --rebase
}

build() {
  src_base=${1}
  install_base=${2}
  mythtv_version=$(cd ${src_base} && git describe)
  build_jobs=$(nproc)

  echo "Build mythtv ${mythtv_version}"
  cd ${src_base}/mythtv \
    && ./configure --compile-type=release --enable-libx264 --enable-libmp3lame \
    && make -s -j ${build_jobs} \
    && make install INSTALL_ROOT=${install_base}/mythtv-${mythtv_version} \
    && make install

  echo "Build mythplugins ${mythtv_version}"
  cd ${src_base}/mythplugins/ \
    && ./configure --compile-type=release \
    && make -s -j ${build_jobs}\
    && make install INSTALL_ROOT=${install_base}/mythplugins-${mythtv_version}

  echo "Clean build"
  make -s distclean && cd ${src_base}/mythtv && make uninstall && make distclean

  echo "Pack bin"
  tar -cjf ${install_base}/mythtv-${mythtv_version}.tar.bz2 -C ${install_base} mythtv-${mythtv_version}
  tar -cjf ${install_base}/mythtvplugins-${mythtv_version}.tar.bz2 -C ${install_base} mythplugins-${mythtv_version}
  echo "Remove bin"
  rm -rf ${install_base}/mythtv-${mythtv_version} && rm -rf ${install_base}/mythplugins-${mythtv_version}
}
  
update-src "/mythtv" ${MYTHTV_BRANCH}
mkdir "/tmp/mythtv-build"
build "/mythtv" "/tmp/mythtv-build"

