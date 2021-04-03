GHC_VERSION := 8.10.2
BUILDX_CACHE := --cache-from type=local,mode=max,src=/tmp/buildx-cache --cache-to type=local,mode=max,dest=/tmp/buildx-cache
all:
	mkdir -p /tmp/buildx-cache
	docker buildx build $(BUILDX_CACHE) --platform linux/arm64/v8,linux/amd64 --build-arg JOBS="-j12" -t juampe/base-ghc -t juampe/base-ghc:$(GHC_VERSION) --push .
