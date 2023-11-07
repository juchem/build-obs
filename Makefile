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

build: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION:-HEAD}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION:-HEAD}" \
			build-obs

interactive: image
	docker run \
		-it --rm \
		-v "$$(pwd)/out:/out" \
		-e "OBS_STUDIO_VERSION=$${OBS_STUDIO_VERSION:-HEAD}" \
		-e "OBS_SHADERFILTER_VERSION=$${OBS_SHADERFILTER_VERSION:-HEAD}" \
		--entrypoint bash \
			build-obs
