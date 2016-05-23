#!/usr/bin/env bash

# Compiles git from source and copies the tar.gz file into /artifacts
#
# To be run within docker container.
#
# Replace %foo% with real values.

set -e

# Replace these using Makefile
APP_SOURCE_DIR="%APP_SOURCE_DIR%"               # /git-2.8.1
APP_INSTALL_LOCATION="%APP_INSTALL_LOCATION%"   # /usr/bin
APP_INSTALL_NAME="%APP_INSTALL_NAME%"           # git-2.8.1
APP_INSTALL_DIR="%APP_INSTALL_DIR%"             # /usr/bin/git/git-2.8.1
APP_TAR_NAME="%APP_TAR_NAME%"                   # git-2.8.1-centos-7.tar.gz
APP_TAR_LOCATION="%APP_TAR_LOCATION%"           # /artifacts
APP_BUILD_FLAGS="%APP_BUILD_FLAGS%"             # NoPerl=YesPlease ...



pushd "%APP_SOURCE_DIR%"
./configure --prefix="%APP_INSTALL_DIR%"
make all strip install "%APP_BUILD_FLAGS%"
cd "%APP_INSTALL_LOCATION%"
tar -zcvf "%APP_TAR_NAME%" "%APP_INSTALL_DIR%"

# Expect /artifacts to be to be mounted as volume
mkdir -p "%APP_TAR_LOCATION%"
mv "%APP_TAR_NAME%" "%APP_TAR_LOCATION%"

