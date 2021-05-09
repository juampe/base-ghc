DOCKER_TAG := juampe/base-ghc
CABAL_VERSION := 3.4.0.0
GHC_VERSION := 8.10.4
BUILDX_CACHE := --cache-from type=local,mode=max,src=$(HOME)/buildx-cache --cache-to type=local,mode=max,dest=$(HOME)/buildx-cache
ARCH:= $(shell docker version -f "{{.Server.Arch}}")

all: archs

cache:
	mkdir -p $(HOME)/buildx-cache 2>/dev/null

archs: amd64 arm64 riscv64

cross:
	mkdir -p $(HOME)/buildx-cache
	docker buildx build $(BUILDX_CACHE) --platform linux/amd64 --build-arg JOBS="-j12" -t $(DOCKER_TAG):cross --push -f Dockerfile.cross .

%64: cache
	$(eval CNAME := $(DOCKER_TAG):$(GHC_VERSION)-$@)
	docker buildx build $(BUILDX_CACHE) --platform linux/$@ --build-arg CABAL_VERSION=$(CABAL_VERSION) --build-arg GHC_VERSION=$(GHC_VERSION) -t $(CNAME) --push .
	docker run --rm $(CNAME) bash -c 'cat /ghc/ghc*.tar.xz' > repo/ghc-$(GHC_VERSION)-$@-ubuntu-21.04-linux.tar.xz

local:
	$(eval CNAME := $(DOCKER_TAG):$(GHC_VERSION)-local)
	docker build --build-arg TARGETARCH=$(ARCH) --build-arg CABAL_VERSION=$(CABAL_VERSION) --build-arg GHC_VERSION=$(GHC_VERSION) -t $(CNAME) .
	docker run --rm $(CNAME) bash -c 'cat /ghc/ghc*.tar.xz' > repo/ghc-$(GHC_VERSION)-$(ARCH)-ubuntu-21.04-linux.tar.xz

