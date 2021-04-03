<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD033 -->
<p align="center">
    <a href="https://docs.cardano.org/en/latest/">
        <img src="https://docs.cardano.org/en/latest/_static/cardano-logo.png" width="150" alt="Cardano">
    </a>
    <br>
    <strong>Cardano the decentralized third-generation proof-of-stake blockchain platform.</strong>
</p>
<!-- markdownlint-enable MD033 -->

# Multiarch ghc docker container to build cardano 🐳
Cardano docker is can now be supported as container a in Raspberri Pi or AWS Gravitron container platform.
It is based in ubuntu focal builder in a documented and formal way (supply chain review).

Access to the multi-platform docker [image](https://hub.docker.com/r/juampe/base-ghc).
Access to the Git [repository](https://github.com/juampe/base-ghc)
# A complex building proccess recipe to build cardano.
We are working very hard, to bring this container. The building process in quemu arm64 is huge.
Please undestand that this is an "spartan race" building process due to qemu limitations.
We planned to made in 3 phases:
* Phase 1 Build Cabal 3.2.0.0 free of OFD Locking
 * Build with Github action in 12896.0s
* Phase 2 Build ghc 8.10.2 compatible with state-of-the-art qemu for multi architecture CI/CD
 * Avoid the qemu "hLock: invalid argument (Invalid argument)" problem
 * Unable to use Github action due to service limitations
 * Build with amd64 12VCPU 32GMEM 50GSSD in 26513.0s
* Phase 3 Bulid Cardano 1.25.1
 * Unable to use Github action due to service limitations
 * Build with amd64 12VCPU 32GMEM 50GSSD in 26513.0s

# Build your own.
From a ubuntu:groovy prepare for docker buildx multiarch environment
```
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install qemu binfmt-support qemu-user-static docker-ce byobu make

export DOCKER_CLI_EXPERIMENTAL=enabled

docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
docker buildx create --name builder
docker buildx use builder
docker buildx inspect --bootstrap
docker buildx ls

git clone https://github.com/juampe/base-ghc.git
cd base-ghc

#Adapt Makefile to tag and fit your own docker repository
make
```



