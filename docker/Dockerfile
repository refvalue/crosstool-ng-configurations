ARG TARGET_TRIPLET=""
FROM archlinux:latest AS builder

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Build stage for ${TARGET_TRIPLET} toolchain"

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm git make gcc gperf bison flex texinfo help2man ncurses wget python bash tar xz curl

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git --depth 1 /ct-ng

WORKDIR /ct-ng

RUN ./bootstrap && ./configure --prefix=/opt && make && make install
COPY ${TARGET_TRIPLET}.config /ct-ng/.config

RUN /opt/bin/ct-ng build

FROM archlinux:latest

LABEL maintainer="metabeyond@outlook.com"
LABEL description="Arch Linux image with pre-built ${TARGET_TRIPLET} toolchain"

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm bash tar xz curl

RUN mkdir -p /opt/${TARGET_TRIPLET}

# Copy toolchain from builder stage
COPY --from=builder /ct-ng/x-tools/${TARGET_TRIPLET}/ /opt/${TARGET_TRIPLET}/

ENV PATH="/opt/${TARGET_TRIPLET}/bin:${PATH}"

CMD ["/bin/bash"]
