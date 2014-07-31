#!/usr/bin/bash

# Build evertything and clean up build dependencies to have put everything in a
# single RUN step and workaround for:
# https://github.com/docker/docker/issues/332

set -xe

# System dependencies
apt-get install -y git-core build-essential gfortran python3-dev curl
curl https://bootstrap.pypa.io/get-pip.py | python3
pip3 install cython

# Temporary build folder
mkdir /tmp/build
cd /tmp/build

# Build NumPy and SciPy from source against OpenBLAS installed
git clone -q --branch=v1.8.1 git://github.com/numpy/numpy.git
cp /numpy-site.cfg numpy/site.cfg
(cd numpy && python3 setup.py install)

git clone -q --branch=v0.14.0 git://github.com/scipy/scipy.git
cp /scipy-site.cfg scipy/site.cfg
(cd scipy && python3 setup.py install)

# Build scikit-learn against OpenBLAS as well, by introspecting the numpy
# runtime config.
pip3 install git+git://github.com/scikit-learn/scikit-learn.git

# Reduce the image size
pip3 uninstall -y cython
apt-get remove -y --purge curl git-core build-essential python3-dev
apt-get autoremove -y
apt-get clean -y

cd /
rm -rf /tmp/build
