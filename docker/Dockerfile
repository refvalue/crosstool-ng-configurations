FROM archlinux:latest AS builder
ARG TARGET_TRIPLET
ARG PROXY_URL

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Build stage for ${TARGET_TRIPLET} toolchain"

ENV http_proxy=${PROXY_URL}
ENV https_proxy=${PROXY_URL}

WORKDIR /tmp

RUN sed -i 's|^Server =.*$|Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch|g' /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm ca-certificates autoconf automake libtool pkgconf gawk bison flex texinfo \
    gcc make patch git wget ncurses zlib unzip lzip gperf python help2man which bash sed grep bash tar xz curl wget && \
    wget https://github.com/ninja-build/ninja/releases/download/v1.13.1/ninja-linux.zip && \
    wget https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2-linux-x86_64.tar.gz -O cmake.tgz && \
    wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.28.0.tar.xz -O ct-ng.tar.xz && \
    mkdir -p /opt/ninja/bin /opt/cmake && \
    unzip ninja-linux.zip -d /opt/ninja/bin && \
    tar -xzf cmake.tgz -C /opt/cmake --strip-components=1 && \
    mkdir -p /tmp/ct-ng && tar -xf ct-ng.tar.xz -C /tmp/ct-ng --strip-components=1

WORKDIR /tmp/ct-ng

COPY ${TARGET_TRIPLET}.config /tmp/ct-ng/.config

RUN echo -e "CT_EXPERIMENTAL=y\nCT_ALLOW_BUILD_AS_ROOT=y\nCT_ALLOW_BUILD_AS_ROOT_SURE=y" >> .config && \
    ./bootstrap && ./configure --prefix=/opt/ct-ng && make && make install && \
    /opt/ct-ng/bin/ct-ng build

FROM archlinux:latest
ARG TARGET_TRIPLET

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Arch Linux image with pre-built ${TARGET_TRIPLET} toolchain"

COPY --from=builder /opt/ /opt/
COPY --from=builder /root/x-tools/${TARGET_TRIPLET}/ /opt/${TARGET_TRIPLET}/

ENV PATH="/opt/ninja/bin:/opt/cmake/bin:/opt/ct-ng/bin:/opt/${TARGET_TRIPLET}/bin:${PATH}"

CMD ["/bin/bash"]
