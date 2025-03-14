FROM rust:1.85.0-slim-bullseye

WORKDIR /app

# Install WebAssembly target
RUN rustup target add wasm32-unknown-unknown

# Copy Source files
COPY wasm-min .

RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -ex' >> /app/build.sh && \
    echo 'cd /app' >> /app/build.sh && \
    echo 'cargo build --target wasm32-unknown-unknown --release' >> /app/build.sh && \
    echo 'mkdir -p /modules' >> /app/build.sh && \
    echo 'cp target/wasm32-unknown-unknown/release/wasm_min.wasm /modules/min.wasm' >> /app/build.sh && \
    chmod +x /app/build.sh

ENTRYPOINT ["/app/build.sh"]