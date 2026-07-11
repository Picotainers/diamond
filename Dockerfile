FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential \
    cmake \
    zlib1g-dev \
    libbz2-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/bbuchfink/diamond.git /src/diamond && \
    cmake -S /src/diamond -B /src/diamond/build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build /src/diamond/build -j"$(nproc)" && \
    strip /src/diamond/build/diamond

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/diamond/build/diamond /usr/local/bin/diamond
WORKDIR /data
ENTRYPOINT ["diamond"]
