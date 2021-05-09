FROM juampe/ubuntu:hirsute
ARG TARGETARCH
ARG DEBIAN_FRONTEND="noninteractive"
ARG CABAL_VERSION=3.4.0.0
ARG GHC_VERSION=8.10.4
ARG JOBS="-j1"
# export TARGETARCH=arm64 DEBIAN_FRONTEND="noninteractive" CABAL_VERSION=3.4.0.0 GHC_VERSION=8.10.4 NODE_VERSION=1.26.2 JOBS="-j2"

COPY util/ /util/
COPY patches/ /patches/
RUN /util/install-deb.sh ${TARGETARCH}
RUN /util/install-cabal.sh ${TARGETARCH} ${CABAL_VERSION}
RUN /usr/local/bin/cabal update \
  && /usr/local/bin/cabal install -v3 happy-1.19.12 --overwrite-policy=always \
  && /usr/local/bin/cabal install -v3 alex --overwrite-policy=always

#Configure ghc
RUN apt-get -y build-dep ghc \
  && git clone --recurse-submodules --tags https://gitlab.haskell.org/ghc/ghc.git /ghc \
  && cd /ghc \
  && git checkout ghc-${GHC_VERSION}-release \
  && git submodule update --init \
  && /util/config-ghc.sh ${TARGETARCH} ${GHC_VERSION}
  
# Build 
RUN cd /ghc \
  && make ${JOBS} 

#Need stage2 to make binary-dist
RUN cd /ghc \
  && make ${JOBS} binary-dist




