#!/bin/sh

set -e

sudo apt-get update
sudo apt-get install build-essential automake libtool pkg-config yasm cmake liblzma-dev ninja-build \
                     subversion python3-pip libass-dev libbluray-dev libgsm1-dev libmodplug-dev libmp3lame-dev \
                     libopencore-amrnb-dev libopencore-amrwb-dev libopus-dev librubberband-dev \
                     libshine-dev libsnappy-dev libsoxr-dev libspeex-dev libtheora-dev libtwolame-dev \
                     libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev \
                     libx265-dev libnuma-dev libxvidcore-dev libzmq3-dev libsodium-dev libpgm-dev \
                     libnorm-dev libzvbi-dev libssl-dev libfdk-aac-dev \
                     -y

if [ -d ./nasm-2.14.02 ]; then
  rm -rf ./nasm-2.14.02
fi

curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
tar -jxvf ./nasm-2.14.02.tar.bz2
rm ./nasm-2.14.02.tar.bz2
cd ./nasm-2.14.02
./configure --prefix=/usr/local
make && sudo make install && cd ..

pip3 install --user meson

if [ -d ./aom ]; then
  rm -rf ./aom
fi

git clone --depth=1 -b v1.0.0 https://aomedia.googlesource.com/aom
cd ./aom/build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF -DENABLE_TESTS=OFF ..
make && sudo make install && cd ../..

if [ -d ./dav1d ]; then
  rm -rf ./dav1d
fi

git clone --depth=1 -b 0.6.0 https://code.videolan.org/videolan/dav1d.git
cd ./dav1d
mkdir ./build && cd ./build
~/.local/bin/meson --prefix=/usr/local --default-library=static ..
ninja && sudo ninja install && cd ../..

if [ -d ./openh264 ]; then
  rm -rf ./openh264
fi

git clone --depth=1 -b v2.1.0 https://github.com/cisco/openh264.git
cd ./openh264
make && sudo make install-static && cd ..

if [ -d ./openjpeg ]; then
  rm -rf ./openjpeg
fi

git clone --depth=1 -b v2.3.1 https://github.com/uclouvain/openjpeg.git
cd ./openjpeg
mkdir ./build && cd ./build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF ..
make && sudo make install && cd ../..

if [ -d ./libmysofa ]; then
  rm -rf ./libmysofa
fi

git clone --depth=1 -b v1.0 https://github.com/hoene/libmysofa.git
cd ./libmysofa/build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF ..
make && sudo make install && cd ../..

if [ -d ./vid.stab ]; then
  rm -rf ./vid.stab
fi

git clone --depth=1 -b v1.1.0 https://github.com/georgmartius/vid.stab.git
cd ./vid.stab
mkdir ./build && cd ./build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF ..
make && sudo make install && cd ../..

if [ -d ./vmaf ]; then
  rm -rf ./vmaf
fi

git clone --depth=1 -b v1.3.15 https://github.com/Netflix/vmaf.git
cd ./vmaf
make && sudo make install && cd ..

if [ -d ./xavs ]; then
  rm -rf ./xavs
fi

svn co https://svn.code.sf.net/p/xavs/code/trunk xavs
cd ./xavs
./configure --prefix=/usr/local --disable-shared --disable-asm
make && sudo make install && cd ..

if [ -d ./zimg ]; then
  rm -rf ./zimg
fi

git clone --depth=1 -b release-2.9.3 https://github.com/sekrit-twc/zimg.git
cd ./zimg
./autogen.sh
STL_LIBS="-lstdc++ -lm" ./configure --prefix=/usr/local --disable-shared --enable-static
make && sudo make install && cd ..

if [ -d ./ffmpeg-4.2.2 ]; then
  rm -rf ./ffmpeg-4.2.2
fi

curl -O https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2
tar -jxvf ./ffmpeg-4.2.2.tar.bz2
cd ./ffmpeg-4.2.2/
./configure --cc=/usr/bin/gcc --prefix=/usr/local --extra-version=lvv.me \
            --enable-avisynth --enable-fontconfig --enable-gpl --enable-libaom --enable-libass \
            --enable-libbluray --enable-libdav1d --enable-libfreetype --enable-libgsm --enable-libmodplug \
            --enable-libmp3lame --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb \
            --enable-libopenh264 --enable-libopenjpeg --enable-libopus --enable-librubberband --enable-libshine \
            --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame \
            --enable-libvidstab --enable-libvmaf --enable-libvo-amrwbenc --enable-libvorbis --enable-libvpx \
            --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs \
            --enable-libxvid --enable-libzimg --enable-libzmq --enable-libzvbi --enable-version3 \
            --pkg-config-flags=--static --disable-ffplay \
            --enable-nonfree --enable-openssl --enable-libfdk-aac \
            --extra-ldflags="-pthread -fprofile-arcs -ftest-coverage"

make -j `sysctl -n hw.logicalcpu_max`
sudo make install

exit 0
