FROM debian:testing-slim

#################
# base settings #
#################

ENV DEBIAN_PRIORITY=critical
ENV DEBIAN_FRONTEND=noninteractive

COPY debian-testing.list /etc/apt/sources.list.d/

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
  ca-certificates \
  file \
  curl git \
  pkg-config \
  python3 python3-dev \
  build-essential \
  g++ clang clang-format \
  cmake ninja-build \
  swig zsh \
  gzip bzip2 xz-utils 7zip

##############
# obs-studio #
##############
# https://github.com/obsproject/obs-studio/wiki/build-instructions-for-linux#2-get-the-dependencies

RUN apt-get install -y --no-install-recommends \
  libssl-dev libcrypt-dev \
  libasio-dev libasound2-dev \
  libfdk-aac-dev \
  uthash-dev \
  libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libffmpeg-nvenc-dev libswresample-dev libswscale-dev \
  libcmocka-dev libcurl4-openssl-dev libdrm-dev libfdk-aac-dev \
  libfontconfig-dev libfreetype6-dev \
  libgl1-mesa-dev libgles2-mesa-dev libglvnd-dev \
  libjack-jackd2-dev libjansson-dev libluajit-5.1-dev libmbedtls-dev \
  libpci-dev libpipewire-0.3-dev libpulse-dev libqrcodegencpp-dev \
  librist-dev libsndio-dev libspeexdsp-dev libsrt-openssl-dev \
  libudev-dev libv4l-dev libva-dev libvlc-dev libvpl-dev \
  libwayland-dev libwebsocketpp-dev nlohmann-json3-dev \
  libx11-dev libx11-xcb-dev libx264-dev \
  libxcb-composite0-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xinerama0-dev \
  libxcb1-dev libxcomposite-dev libxinerama-dev libxss-dev \
  libqt6svg6-dev qt6-base-dev qt6-base-private-dev qt6-image-formats-plugins qt6-wayland

# dependencies of CEF
RUN apt-get install -y --no-install-recommends \
  xorg-dev libatk1.0-dev libatk-bridge2.0-dev libatspi2.0-dev libnspr4-dev libnss3-dev

# https://github.com/obsproject/obs-studio/tags
ENV OBS_STUDIO_DEFAULT_VERSION="HEAD"
# https://github.com/obsproject/obs-studio/wiki/Build-Instructions-For-Linux#obs-browser
ENV OBS_CEF_DEFAULT_VERSION="6533"

ENV OBS_STUDIO_DIR="/src/obs-studio"

RUN mkdir -p "${OBS_STUDIO_DIR}"
RUN cd "${OBS_STUDIO_DIR}" \
  && git init \
  && git remote add origin "https://github.com/obsproject/obs-studio.git"

####################
# obs-shaderfilter #
####################
RUN apt-get install -y --no-install-recommends \
  qtbase5-dev \
  libqt5svg5-dev

# https://github.com/exeldro/obs-shaderfilter/tags
ENV OBS_SHADERFILTER_DEFAULT_VERSION="HEAD"

ENV OBS_SHADERFILTER_DIR="/src/obs-shaderfilter"

RUN mkdir -p "${OBS_SHADERFILTER_DIR}"
RUN cd "${OBS_SHADERFILTER_DIR}" \
  && git init \
  && git remote add origin "https://github.com/exeldro/obs-shaderfilter.git"

##########
# finish #
##########

RUN apt autoremove --purge -y
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

WORKDIR "/src"
RUN mkdir -p /out

ENV PREFIX_DIR="/out"

COPY entrypoint.sh /srv
ENTRYPOINT "/srv/entrypoint.sh"
