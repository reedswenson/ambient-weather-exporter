IMG_TAG=reedswenson/ambient-weather-exporter:latest
cur_dir:=$(shell pwd)
platform=linux/amd64

export_deps:
	uv export --format requirements.txt --no-hashes --no-annotate > requirements.txt

build: export_deps
	docker buildx build \
	-t $(IMG_TAG) \
	-f Dockerfile \
	--platform $(platform) \
	.

push: export_deps
	docker buildx build \
	-t $(IMG_TAG) \
	-f Dockerfile \
	--platform $(platform) \
	--push \
	.

push:
	docker push $(IMG_TAG)

run_container:
	docker run --rm -it \
	-p 9000:9000 \
	-v $(cur_dir)/test:/app/config \
	$(IMG_TAG)
