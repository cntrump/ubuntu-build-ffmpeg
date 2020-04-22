FROM ubuntu:18.04

ARG FFMPEG_VERSION=4.2.2

ARG DEP_PKGS="git curl build-essential automake libtool pkg-config yasm cmake liblzma-dev ninja-build \
                     subversion python3-pip libass-dev libbluray-dev libgsm1-dev libmodplug-dev libmp3lame-dev \
                     libopencore-amrnb-dev libopencore-amrwb-dev libopus-dev librubberband-dev \
                     libshine-dev libsnappy-dev libsoxr-dev libspeex-dev libtheora-dev libtwolame-dev \
                     libvo-amrwbenc-dev libvorbis-dev libvpx-dev libwavpack-dev libwebp-dev libx264-dev \
                     libx265-dev libnuma-dev libxvidcore-dev libzmq3-dev libsodium-dev libpgm-dev \
                     libnorm-dev libzvbi-dev libssl-dev libfdk-aac-dev"

RUN apt-get update && apt-get install ${DEP_PKGS} -y && apt-get clean

RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 \
    && tar -jxvf ./nasm-2.14.02.tar.bz2 && rm ./nasm-2.14.02.tar.bz2 \
    && cd ./nasm-2.14.02 && ./configure --prefix=/usr/local \
    && make && make install && cd .. && rm -rf ./nasm-2.14.02

RUN pip3 install --user meson

RUN git clone --depth=1 -b v1.0.0 https://aomedia.googlesource.com/aom \
    && cd ./aom/build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON -DENABLE_TESTS=OFF .. \
    && make && make install && cd ../.. && rm -rf ./aom

RUN git clone --depth=1 -b 0.6.0 https://code.videolan.org/videolan/dav1d.git \
    && cd ./dav1d && mkdir ./build && cd ./build \
    && ~/.local/bin/meson --prefix=/usr/local --default-library=shared .. \
    && ninja && ninja install && cd ../.. && rm -rf ./dav1d

RUN git clone --depth=1 -b v2.1.0 https://github.com/cisco/openh264.git \
    && cd ./openh264 && make && make install-shared && cd .. && rm -rf ./openh264

RUN git clone --depth=1 -b v2.3.1 https://github.com/uclouvain/openjpeg.git \
    && cd ./openjpeg && mkdir ./build && cd ./build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON .. \
    && make && make install && cd ../.. && rm -rf ./openjpeg

RUN git clone --depth=1 -b v1.0 https://github.com/hoene/libmysofa.git \
    && cd ./libmysofa/build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON -DBUILD_TESTS=OFF .. \
    && make && make install && cd ../.. && rm -rf ./libmysofa

RUN git clone --depth=1 -b v1.1.0 https://github.com/georgmartius/vid.stab.git \
    && cd ./vid.stab && mkdir ./build && cd ./build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON .. \
    && make && make install && cd ../.. && rm -rf ./vid.stab

RUN git clone --depth=1 -b v1.5.1 https://github.com/Netflix/vmaf.git \
    && cd ./vmaf/libvmaf && mkdir ./build && cd ./build \
    && ~/.local/bin/meson --prefix=/usr/local --default-library=shared .. \
    && ninja && ninja install && cd ../../.. && rm -rf ./vmaf

RUN svn co https://svn.code.sf.net/p/xavs/code/trunk xavs \
    && cd ./xavs && ./configure --prefix=/usr/local --enable-shared --disable-asm \
    && make && make install && cd .. && rm -rf ./xavs

RUN git clone --depth=1 -b release-2.9.3 https://github.com/sekrit-twc/zimg.git \
    && cd ./zimg && ./autogen.sh && STL_LIBS="-lstdc++ -lm" ./configure --prefix=/usr/local --enable-shared --disable-static \
    && make && make install && cd .. && rm -rf ./zimg

RUN curl -O https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
    && tar -jxvf ./ffmpeg-${FFMPEG_VERSION}.tar.bz2 && rm ./ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
    && cd ./ffmpeg-${FFMPEG_VERSION} \
    && ./configure --cc=/usr/bin/gcc --prefix=/usr/local --extra-version=lvv.me \
            --enable-avisynth --enable-fontconfig --enable-gpl --enable-libaom --enable-libass \
            --enable-libbluray --enable-libdav1d --enable-libfreetype --enable-libgsm --enable-libmodplug \
            --enable-libmp3lame --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb \
            --enable-libopenh264 --enable-libopenjpeg --enable-libopus --enable-librubberband --enable-libshine \
            --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame \
            --enable-libvidstab --enable-libvmaf --enable-libvo-amrwbenc --enable-libvorbis --enable-libvpx \
            --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs \
            --enable-libxvid --enable-libzimg --enable-libzmq --enable-libzvbi --enable-version3 \
            --disable-ffplay \
            --enable-nonfree --enable-openssl --enable-libfdk-aac \
            --extra-ldflags="-pthread -fprofile-arcs -ftest-coverage" \
    && make && make install && cd .. && rm -rf ./ffmpeg-${FFMPEG_VERSION}

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/x86_64-linux-gnu

RUN ldd /usr/local/bin/ffmpeg && /usr/local/bin/ffmpeg -version

CMD ["/usr/local/bin/ffmpeg"]
