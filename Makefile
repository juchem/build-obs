.PHONY: all image build interactive

all: image

image:
	DOCKER_BUILDKIT=1 docker build \
		-t build-obs \
			docker

image-from-scratch:
	DOCKER_BUILDKIT=1 docker build \
		-t build-obs \
		--no-cache \
			docker

interactive: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION}" \
		-e "OBS_CEF_VERSION=$${OBS_CEF_VERSION}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION}" \
		--entrypoint bash \
			build-obs

interactive-from-scratch: image-from-scratch
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION}" \
		-e "OBS_CEF_VERSION=$${OBS_CEF_VERSION}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION}" \
		--entrypoint bash \
			build-obs

# OBE_STUDIO_VERSION: https://github.com/obsproject/obs-studio/tags
# OBS_CEF_VERSION: https://github.com/obsproject/obs-studio/wiki/Build-Instructions-For-Linux#obs-browser
# OBS_SHADERFILTER_VERSION: https://github.com/exeldro/obs-shaderfilter/tags
build: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION}" \
		-e "OBS_CEF_VERSION=$${OBS_CEF_VERSION}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION}" \
			build-obs

# OBS_STUDIO_VERSION: https://github.com/obsproject/obs-studio/tags
# OBS_CEF_VERSION: https://github.com/obsproject/obs-studio/wiki/Build-Instructions-For-Linux#obs-browser
# OBS_SHADERFILTER_VERSION: https://github.com/exeldro/obs-shaderfilter/tags
build-from-scratch: image-from-scratch
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION}" \
		-e "OBS_CEF_VERSION=$${OBS_CEF_VERSION}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION}" \
			build-obs
