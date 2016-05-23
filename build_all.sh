#!/usr/bin/env bash

set -e

DIR=$(dirname $0)
pushd "${DIR}"

# These are exact versions we get with official centos7 RPMs
make git GIT_VERSION=1.8.3.1 OS=centos OS_TAG=5
make git GIT_VERSION=1.8.3.1 OS=centos OS_TAG=6
make git GIT_VERSION=1.8.3.1 OS=centos OS_TAG=7

make git GIT_VERSION=1.9.1 OS=centos OS_TAG=5
make git GIT_VERSION=1.9.1 OS=centos OS_TAG=6
make git GIT_VERSION=1.9.1 OS=centos OS_TAG=7

make git GIT_VERSION=2.8.1 OS=centos OS_TAG=5
make git GIT_VERSION=2.8.1 OS=centos OS_TAG=6
make git GIT_VERSION=2.8.1 OS=centos OS_TAG=7
