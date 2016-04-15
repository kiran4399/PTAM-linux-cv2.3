#!/bin/bash
 
targettopdir=`pwd`/PTAM-work
pwdinfo=`pwd`
 
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config
sudo apt-get install liblapack-dev freeglut3-dev libdc1394-22-dev
sudo apt-get install liblapack-dev libblas-dev
sudo apt-get install libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev libv4l-dev 
sudo apt-get install libavcodec-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libavdevice-dev libsdl-dev
sudo apt-get install libgtk2.0-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev 
sudo apt-get install mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev
 
mkdir -p $targettopdir
 
# TooN
pushd $targettopdir
git clone git://github.com/edrosten/TooN.git
cd TooN
./configure
make
sudo make install
popd
 
# libcvd
pushd $targettopdir
git clone git://github.com/edrosten/libcvd.git
cd libcvd
mv cvd_src/convolution.cc cvd_src/convolution.cc-original
cp $pwdinfo/hack/libcvd/convolution.cc cvd_src/convolution.cc
export CXXFLAGS=-D_REENTRANT
./configure --without-ffmpeg --without-v4l1buffer --without-dc1394v1 --without-dc1394v2
make
sudo make install
popd
 
# gvars3
pushd $targettopdir
git clone git://github.com/edrosten/gvars.git
cd gvars
mv gvars/serialize.h gvars/serialize.h-original
cp $pwdinfo/hack/gvars3/serialize.h gvars/serialize.h
./configure --disable-widgets
make
sudo make install
popd
 
# before you go further, re-arrange the dynamic libraries
sudo ldconfig
 
# PTAM main
pushd $targettopdir
unzip $pwdinfo/PTAM-r114-2010129.zip
patch -p0 -d . < $pwdinfo/hack/PTAM/PTAM-r114-linux.patch
patch -p0 -d . < $pwdinfo/YujiPTAM-r114-linux.patch
cd PTAM
cp Build/Linux/* .
make
 
exit 0