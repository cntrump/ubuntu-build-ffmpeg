# Build [FFmpeg](https://ffmpeg.org) on Ubuntu ![](https://img.shields.io/docker/automated/cntrump/ubuntu-ffmpeg) ![](https://img.shields.io/docker/pulls/cntrump/ubuntu-ffmpeg) ![](https://img.shields.io/docker/stars/cntrump/ubuntu-ffmpeg)

- Base on static library recommended by ffmpeg.org: [Static builds for macOS 64-bit](https://evermeet.cx/ffmpeg/)
- Add AAC support
- Add SSL support (with [OpenSSL](https://www.openssl.org))
- Build with clang

### Configuration

`configuration: --cc=/usr/bin/gcc --prefix=/usr/local --extra-version=lvv.me --enable-avisynth --enable-fontconfig --enable-gpl --enable-libaom --enable-libass --enable-libbluray --enable-libdav1d --enable-libfreetype --enable-libgsm --enable-libmodplug --enable-libmp3lame --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenh264 --enable-libopenjpeg --enable-libopus --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvmaf --enable-libvo-amrwbenc --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs --enable-libxvid --enable-libzimg --enable-libzmq --enable-libzvbi --enable-version3 --disable-ffplay --enable-nonfree --enable-openssl --enable-libfdk-aac --extra-ldflags='-pthread -fprofile-arcs -ftest-coverage'`

### Build FFmpeg

Run `build.sh`

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cntrump/ubuntu-build-ffmpeg/master/build.sh)"
```

### Finished

ffmpeg installed to

- `/usr/local/bin/ffmpeg`
- `/usr/local/bin/ffprobe`

### Docker Image

`docker pull cntrump/ubuntu-ffmpeg:v4.2.2`

Run FFmpeg

`docker run -it --rm cntrump/ubuntu-ffmpeg ffmpeg`

## macOS users

[brew-build-ffmpeg](https://github.com/cntrump/brew-build-ffmpeg)
