FROM archlinux:latest AS builder
ARG TARGET_TRIPLET
ARG PROXY_URL

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Build stage for ${TARGET_TRIPLET} toolchain"

ENV http_proxy=${PROXY_URL}
ENV https_proxy=${PROXY_URL}

RUN sed -i 's|^Server =.*$|Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch|g' /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm ca-certificates autoconf automake libtool pkgconf gawk bison flex texinfo \
    gcc make patch git wget ncurses zlib unzip lzip gperf python help2man which bash sed grep bash tar xz curl wget

WORKDIR /ct-ng

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git --depth 1 /ct-ng

COPY ${TARGET_TRIPLET}.config /ct-ng/.config

RUN echo -e "CT_EXPERIMENTAL=y\nCT_ALLOW_BUILD_AS_ROOT=y\nCT_ALLOW_BUILD_AS_ROOT_SURE=y" >> .config && \
    ./bootstrap && ./configure --prefix=/opt && make && make install && \
    /opt/bin/ct-ng build

FROM archlinux:latest
ARG TARGET_TRIPLET

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Arch Linux image with pre-built ${TARGET_TRIPLET} toolchain"

COPY --from=builder /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm ca-certificates which bash tar xz curl nano && \
    mkdir -p /opt/${TARGET_TRIPLET}

COPY --from=builder /root/x-tools/${TARGET_TRIPLET}/ /opt/${TARGET_TRIPLET}/

ENV PATH="/opt/${TARGET_TRIPLET}/bin:${PATH}"

CMD ["/bin/bash"]
