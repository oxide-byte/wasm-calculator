FROM debian:bullseye-slim AS builder

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Zig
RUN wget https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz \
    && tar -xf zig-linux-x86_64-0.11.0.tar.xz \
    && mv zig-linux-x86_64-0.11.0 /usr/local/zig \
    && rm zig-linux-x86_64-0.11.0.tar.xz

ENV PATH="/usr/local/zig:${PATH}"

# Copy source files
COPY wasm-digit-count .

# Create build script
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -ex' >> /app/build.sh && \
    echo 'cd /app' >> /app/build.sh && \
    echo 'zig build -Dtarget=wasm32-wasi -Doptimize=ReleaseFast' >> /app/build.sh && \
    echo 'cp zig-out/lib/digit-count.wasm /modules/digit-count.wasm' >> /app/build.sh && \
    chmod +x /app/build.sh

ENTRYPOINT ["/app/build.sh"]