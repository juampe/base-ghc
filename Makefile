DOCKER_TAG := juampe/base-ghc
GHC_VERSION := 8.10.2
BUILDX_CACHE := --cache-from type=local,mode=max,src=$(HOME)/buildx-cache --cache-to type=local,mode=max,dest=$(HOME)/buildx-cache
all:
	mkdir -p $(HOME)/buildx-cache
	docker buildx build $(BUILDX_CACHE) --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --build-arg JOBS="-j12" -t $(DOCKER_TAG) -t $(DOCKER_TAG):$(GHC_VERSION) --push .

cross:
	mkdir -p $(HOME)/buildx-cache
	docker buildx build $(BUILDX_CACHE) --platform linux/amd64 --build-arg JOBS="-j12" -t $(DOCKER_TAG):cross --push -f Dockerfile.cross .

