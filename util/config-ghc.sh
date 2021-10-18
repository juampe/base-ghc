#!/bin/bash
ARCH=$1
GHC=$2

echo "Source GHC"
git clone --recurse-submodules --tags https://gitlab.haskell.org/ghc/ghc.git /cache/ghc || true 
ln -s /cache/ghc /ghc || true 
cd /ghc 
git checkout ghc-$GHC-release 
git submodule update --init 

echo "Patching GHC $ARCH"
if [ -e "/patches/$GHC/$ARCH/forward" ]
then
        for i in $( cat /patches/$GHC/$ARCH/forward|grep -v ^# )
        do 
                echo Apply patch $i 
                cat /patches/$GHC/$ARCH/$i |patch -p1 
        done 
fi

if [ -e "/patches/$GHC/$ARCH/reverse" ]
then
        for i in $( cat /patches/$GHC/$ARCH/reverse|grep -v ^# )
        do 
                echo Apply reverse patch $i 
                cat /patches/$GHC/$ARCH/$i |patch -R -p1 
        done 
fi

echo "Configure GHC  $ARCH"
./boot

case $ARCH in
	amd64|arm64)
                ALEX=~/.cabal/bin/alex HAPPY=~/.cabal/bin/happy ./configure 
	;;
        riscv64)
                ALEX=~/.cabal/bin/alex HAPPY=~/.cabal/bin/happy LIBS="atomic" ./configure 
	;;
esac

#make mainainter-clean
#stage=2
#BuildFlavour = quick
#BuildFlavour = quick-llvm

cat > mk/build.mk << EOF
GhcLibHcOpts+=-haddock
BUILD_EXTRA_PKGS=NO
HADDOCK_DOCS=NO
BUILD_MAN=NO
BUILD_SPHINX_HTML=NO
BUILD_SPHINX_PDF=NO
SRC_HC_OPTS += -lffi -optl-pthread
EXTRA_HADDOCK_OPTS += --mathjax=file:///usr/share/javascript/mathjax/MathJax.js
XSLTPROC_OPTS += --nonet
GhcRTSWays += \$(if \$(filter p, \$(GhcLibWays)),thr_debug_p,)
V=1
EOF