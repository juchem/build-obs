A self-contained, sandboxed container image that will build and install OBS and
some of its plugins.

**TL;DR**: build and install latest version under `/usr/local`:
```
# build the builder image:
make

# build latest OBS Studio using the builder image:
docker run -it --rm \
  -v /usr/local:/out \
    build-obs
```

The source code for this image can be found at
[juchem/build-obs](https://github.com/juchem/build-obs).

Choose the version to build by setting environment variable
[`OBS_STUDIO_VERSION`](https://github.com/obsproject/obs-studio/tags). Defaults
to `HEAD` for bleeding edge

Choose the obs-browser CEF framework to use by setting environment variable
[`OBS_CEF_VERSION`](https://github.com/obsproject/obs-studio/wiki/Build-Instructions-For-Linux#obs-browser).

The following plugins are omitted by default but can be build by setting a
version variable:
- [Shader Filter](https://github.com/exeldro/obs-shaderfilter):
  [`OBS_SHADERFILTER_VERSION`](https://github.com/exeldro/obs-shaderfilter/tags)

Binaries will be installed into the container's directory `/out`. Mount that
directory with `-v host_dir:/out` to install it into some host directory.

Customize the base installation directory by setting the environment variable
`PREFIX_DIR`. Defaults to `/usr/local`.

Example: install OBS Studio 30.2.3 with Shader Filter plugin 2.3.2 under
`~/opt`:
```
OUT_DIR="$HOME/opt"
mkdir -p "${OUT_DIR}"
docker run -it --rm \
    -v "${OUT_DIR}:/out" \
    -e "OBS_STUDIO_VERSION=30.2.3" \
    -e "OBS_SHADERFILTER_VERSION=2.3.2" \
    build-obs
```
