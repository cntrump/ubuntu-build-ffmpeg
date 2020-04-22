# Build [FFmpeg](https://ffmpeg.org) on Ubuntu ![](https://img.shields.io/docker/automated/cntrump/ubuntu-ffmpeg) ![](https://img.shields.io/docker/pulls/cntrump/ubuntu-ffmpeg) ![](https://img.shields.io/docker/stars/cntrump/ubuntu-ffmpeg)

- Base on static library recommended by ffmpeg.org: [Static builds for macOS 64-bit](https://evermeet.cx/ffmpeg/)
- Add AAC support
- Add SSL support (with [OpenSSL](https://www.openssl.org))

### Build FFmpeg

Run `build.sh`

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cntrump/ubuntu-build-ffmpeg/master/build.sh)"
```

### Finished

ffmpeg installed to

- `/usr/local/bin/ffmpeg`
- `/usr/local/bin/ffprobe`

### Pre-Built Binaries

[Here](https://github.com/cntrump/ubuntu-build-ffmpeg/releases)

## macOS users

[brew-build-ffmpeg](https://github.com/cntrump/brew-build-ffmpeg)
