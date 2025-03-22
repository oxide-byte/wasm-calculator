FROM ghcr.io/swiftwasm/swift:latest AS builder

WORKDIR /app

# Copy Swift project files
COPY wasm-concat .

# Build the Swift code for WebAssembly
RUN swift build --triple wasm32-unknown-wasi -c release

# Create a script to extract and prepare the WASM file
RUN echo '#!/bin/bash' > build.sh && \
    echo 'set -e' >> build.sh && \
    echo 'mkdir -p /modules' >> build.sh && \
    echo 'cp .build/release/SwiftWasmConcat.wasm /modules/concat.wasm' >> build.sh && \
    echo 'echo "Build complete! WebAssembly file is available at /modules/concat.wasm"' >> build.sh && \
    chmod +x build.sh

# Run the preparation script
ENTRYPOINT ["/app/build.sh"]