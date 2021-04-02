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

# Work in progress, please keep waiting.
We are working very hard, to bring this container. Our VM's are very busy too.
Please undestand that this is an "spartan race" building process due to qemu limitations.
* Phase 1 Build Cabal 3.2.0.0 free of OFD Locking
* Phase 2 Build ghc 8.10.2 compatible with state-of-the-art qemu for multi architecture CI/CD
* Phase 3 Bulid Cardano 1.25.1

# Multiarch ghc docker container to build cardano 🐳
Cardano docker is can now be supported as container a in Raspberri Pi or AWS Gravitron container platform.
It is based in ubuntu focal builder in a documented and formal way (supply chain review).

Access to the multi-platform docker [image](https://hub.docker.com/r/juampe/base-ghc).
