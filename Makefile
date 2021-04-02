GHC_VERSION := 8.10.2
all:
	docker buildx build --platform linux/arm64/v8,linux/amd64 --build-arg JOBS="-j2" -t juampe/base-ghc -t juampe/base-ghc:$(GHC_VERSION) --push .