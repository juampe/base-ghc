#!/bin/bash
ARCH=$1
GHC=$2

echo "Configure GHC  $ARCH"
cd /ghc
./boot
ALEX=~/.cabal/bin/alex HAPPY=~/.cabal/bin/happy ./configure 

cat > mk/build.mk << EOF
GhcLibHcOpts+=-haddock
BUILD_EXTRA_PKGS=NO
HADDOCK_DOCS=NO
BUILD_MAN=NO
BUILD_SPHINX_HTML=NO
BUILD_SPHINX_PDF=NO
EOF

for i in $( cat /patches/$GHC/$ARCH/index|grep -v ^# )
do 
        echo Apply patch $i 
        cat /patches/$GHC/$ARCH/$i |patch -p1 
done 

case $ARCH in
	arm64)
	;;
        amd64) 
        ;;
        riscv64)
	;;
esac
