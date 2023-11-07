#!/bin/bash -xe



build_obs() {
  pushd "${OBS_STUDIO_DIR}"

  build_version="${OBS_STUDIO_VERSION}"
  [ -n "${build_version}" ] || build_version="${OBS_STUDIO_DEFAULT_VERSION}"
  cef_version="${OBS_CEF_VERSION}"
  [ -n "${cef_version}" ] || cef_version="${OBS_CEF_DEFAULT_VERSION}"

  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive

  mkdir -p "${OBS_STUDIO_DIR}/obs-build-dependencies"
  cef_download="/tmp/cef_binary_${cef_version}_linux64.tar.bz2"
  curl -sfLo "${cef_download}" \
    "https://cdn-fastly.obsproject.com/downloads/cef_binary_${cef_version}_linux_x86_64.tar.xz"
  tar xJvCf "${OBS_STUDIO_DIR}/obs-build-dependencies" "${cef_download}"

  mkdir "${OBS_STUDIO_DIR}/build"
  cd "${OBS_STUDIO_DIR}/build"
  (set -x; \
    CFLAGS='-Wno-deprecated-declarations -Wno-stringop-overflow' \
    CXXFLAGS='-Wno-deprecated-declarations -Wno-stringop-overflow' \
      cmake -G Ninja \
        -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCEF_ROOT_DIR="../obs-build-dependencies/cef_binary_5060_linux64" \
        -DOBS_VERSION_OVERRIDE="${build_version}" \
        -DENABLE_AJA=OFF \
        -DENABLE_ALSA=ON \
        -DENABLE_BROWSER=ON \
        -DENABLE_FREETYPE=ON \
        -DENABLE_LIBFDK=ON \
        -DENABLE_OSS=ON \
        -DENABLE_PIPEWIRE=ON \
        -DENABLE_PLUGINS=ON \
        -DENABLE_PULSEAUDIO=ON \
        -DENABLE_V4L2=ON \
        -DENABLE_VST=ON \
        -DENABLE_WAYLAND=ON \
        -DENABLE_WEBRTC=OFF \
        -DQT_VERSION=6 \
        .. \
    && time ninja \
    && time ninja install \
    && time ninja libobs/install \
  )

  popd
}

build_obs_shaderfilter() {
  pushd "${OBS_SHADERFILTER_DIR}"

  build_version="${OBS_SHADERFILTER_VERSION}"
  [ -n "${build_version}" ] || build_version="${OBS_SHADERFILTER_DEFAULT_VERSION}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd

  export CPACK_PACKAGE_CONTACT="${CPACK_PACKAGE_CONTACT:-contact}"
  export CPACK_DEBIAN_PACKAGE_MAINTAINER="${CPACK_DEBIAN_PACKAGE_MAINTAINER:-maintainer}"

  mkdir build
  cd build
  (set -x; \
    cmake -G Ninja \
      -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
      -DCPACK_PACKAGE_CONTACT="${CPACK_PACKAGE_CONTACT}" \
      -DCPACK_DEBIAN_PACKAGE_MAINTAINER="${CPACK_DEBIAN_PACKAGE_MAINTAINER}" \
      -DBUILD_OUT_OF_TREE=On \
      .. \
    && time ninja \
    && time ninja install \
  )

  popd
}

(set -x; apt-get update)
(set -x; apt-get upgrade -y --only-upgrade --no-install-recommends)

(set -x; build_obs "$@")
(set -x; [ -z "${OBS_SHADERFILTER_VERSION}" ] || build_obs_shaderfilter "$@")

cat <<EOF

Successfully built OBS.
EOF
