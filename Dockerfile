# syntax=docker/dockerfile:2
ARG UBUNTU="ubuntu:hirsute"
FROM ${UBUNTU} 

ARG TARGETARCH
ARG DEBIAN_FRONTEND="noninteractive"
ARG CABAL_VERSION=3.4.0.0
ARG GHC_VERSION=8.10.7
ARG GHC_AUX_VERSION=8.10.4
ARG JOBS="-j1"
# export TARGETARCH=arm64 DEBIAN_FRONTEND="noninteractive" CABAL_VERSION=3.4.0.0 GHC_VERSION=8.10.4 NODE_VERSION=1.26.2 JOBS="-j2"

COPY util/ /util/
COPY patches/ /patches/
RUN /util/install-deb.sh ${TARGETARCH}
RUN /util/install-cabal.sh ${TARGETARCH} ${CABAL_VERSION}
RUN /util/install-ghc.sh ${TARGETARCH} ${GHC_AUX_VERSION}
RUN /util/install-aux.sh ${TARGETARCH} happy-1.19.12 alex

#Configure ghc
RUN /util/config-ghc.sh ${TARGETARCH} ${GHC_VERSION}
  
# Build 
RUN cd /ghc \
  && make ${JOBS} 

#Need stage2 to make binary-dist
RUN cd /ghc \
  && make ${JOBS} binary-dist

RUN . /etc/os-release && cp /ghc/ghc*.tar.xz /repo/ghc-${GHC_VERSION}-${TARGETARCH}-ubuntu-${VERSION_ID}-linux.tar.xz


