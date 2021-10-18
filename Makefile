DOCKER_TAG := juampe/base-ghc
CABAL_VERSION := 3.4.0.0
GHC_VERSION := 8.10.7
GHC_AUX_VERSION := 8.10.4
BUILDAH_CACHE := -v $(HOME)/.cabal:/root/.cabal -v $(HOME)/cache:/cache -v $(PWD)/repo:/repo
ARCH:= $(shell docker version -f "{{.Server.Arch}}")
ARCHS:= amd64 arm64 riscv64
UBUNTU := ubuntu:impish

all: $(addprefix build-, $(ARCHS))

archs: $(addprefix build-, $(ARCHS))

exp: $(addprefix exp-, $(ARCHS))

cross:
	mkdir -p $(HOME)/buildx-cache
	docker buildx build $(BUILDX_CACHE) --platform linux/amd64 --build-arg JOBS="-j12" -t $(DOCKER_TAG):cross --push -f Dockerfile.cross .

qemu:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
#podman run --rm --privileged multiarch/qemu-user-static --reset -p yes

build-%64: qemu
	$(eval ARCH := $(subst build-,,$@))
	$(eval ARCH_TAG := $(DOCKER_TAG):$(GHC_VERSION)-$(ARCH))
	buildah bud $(BUILDAH_CACHE) --format docker --layers --platform linux/$(ARCH)  --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg CABAL_VERSION=$(CABAL_VERSION) --build-arg GHC_VERSION=$(GHC_VERSION) --build-arg GHC_AUX_VERSION=$(GHC_AUX_VERSION) -t $(ARCH_TAG) -f Dockerfile .
#	--platform linux/$(ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg CARDANO_VERSION=$(CARDANO_VERSION) -t $(ARCH_TAG) -f Dockerfile .
#	docker buildx build $(BUILDX_CACHE) 
#	docker run --rm $(CNAME) bash -c 'cat /ghc/ghc*.tar.xz' > repo/ghc-$(GHC_VERSION)-$@-ubuntu-21.04-linux.tar.xz

build-local:
	$(eval CNAME := $(DOCKER_TAG):$(GHC_VERSION)-local)
	docker build --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg CABAL_VERSION=$(CABAL_VERSION) --build-arg GHC_VERSION=$(GHC_VERSION) -t $(CNAME) .
	docker run --rm $(CNAME) bash -c 'cat /ghc/ghc*.tar.xz' > repo/ghc-$(GHC_VERSION)-$(ARCH)-ubuntu-21.04-linux.tar.xz


exp-%64:
	$(eval ARCH := $(subst exp-,,$@))
	$(eval ARCH_TAG := $(DOCKER_TAG):exp-$(ARCH))
	$(eval BUILDAH_CACHE := -v $(PWD)/cache/.cabal:/root/.cabal)
	
	@echo "Build experimental $(ARCH_TAG)"
	docker build --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) -t $(ARCH_TAG) -f Dockerfile.exp .
	docker run --rm $(ARCH_TAG) bash -c 'cat /ghc*.tar.xz' > repo/ghc-exp-$(ARCH)-ubuntu-21.04-linux.tar.xz
#buildah bud $(BUILDAH_CACHE) --layers --platform linux/$(ARCH) --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) -t $(ARCH_TAG) -f Dockerfile.exp .
#podman run --entrypoint "" --rm $(ARCH_TAG) bash -c 'cat /ghc*.tar.xz' > repo/ghc-exp-$(ARCH)-ubuntu-21.04-linux.tar.xz

gitlab-%64:
	$(eval ARCH := $(subst gitlab-,,$@))
	$(eval ARCH_TAG := registry.gitlab.haskell.org/juampe/ghc:$(ARCH)-linux-ubuntu2104)
	@echo "Build gitlab $(ARCH_TAG)"
	docker build --build-arg JOBS=$(JOBS) --build-arg UBUNTU=$(UBUNTU) --build-arg TARGETARCH=$(ARCH) --build-arg GHC_VERSION=$(GHC_EXP_VERSION) -t $(ARCH_TAG) -f Dockerfile.gitlab .
	docker push $(ARCH_TAG)