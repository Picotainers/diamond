FROM ubuntu:22.04 AS builder

ARG DIAMOND_REPO=https://github.com/bbuchfink/diamond.git
ARG DIAMOND_REF=v2.2.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        git \
        libbz2-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone --depth 1 --branch "${DIAMOND_REF}" "${DIAMOND_REPO}" diamond-src

WORKDIR /tmp/diamond-src
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build -j"$(nproc)" \
    && strip build/diamond

FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libbz2-1.0 \
        libgomp1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/diamond-src/build/diamond /usr/local/bin/diamond
WORKDIR /data
ENTRYPOINT ["diamond"]
