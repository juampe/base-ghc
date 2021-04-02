ARG TARGETARCH
ARG DEBIAN_FRONTEND="noninteractive"
ARG GHC_VERSION=8.10.2
ARG CABAL_VERSION=3.2.0.0
ARG JOBS="-j1"

FROM juampe/base-cabal:${CABAL_VERSION}
# export TARGETARCH=arm64 DEBIAN_FRONTEND="noninteractive" CABAL_VERSION=3.2.0.0 GHC_VERSION=8.10.2 NODE_VERSION=1.25.1 JOBS="-j2"

#Install target ghc with debian patches
COPY patches/ /patches/
RUN apt-get -y build-dep ghc \
  && git clone --recurse-submodules --tags https://gitlab.haskell.org/ghc/ghc.git /ghc \
  && cd /ghc \
  && git checkout ghc-${GHC_VERSION}-release \
  && git submodule update --init \
  && for i in $(cat /patches/ghc-patches-${GHC_VERSION}/series|grep -v ^#);do echo $i ;cat /patches/ghc-patches-${GHC_VERSION}/$i |patch -p1 ;done \
  && ./boot \
  && ./configure 
#Dute to build time force container commit
RUN cd /ghc \
  && make ${JOBS} \
RUN cd /ghc \
  && make ${JOBS} install

# #&& /bin/echo -ne "GhcLibHcOpts+=-haddock\nHAVE_OFD_LOCKING=0\nBUILD_EXTRA_PKGS=NO\nHADDOCK_DOCS=NO\nBUILD_MAN=NO\nBUILD_SPHINX_HTML=NO\nBUILD_SPHINX_PDF=NO" > mk/build.mk \

