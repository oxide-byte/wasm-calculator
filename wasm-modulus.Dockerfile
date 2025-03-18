FROM dart:stable AS builder

WORKDIR /app

# Copy the Dart project files
COPY wasm-modulus .

# Create build script
RUN echo '#!/bin/bash' > build.sh && \
    echo 'set -e' >> build.sh && \
    echo 'echo "Starting Dart to WebAssembly compilation process..."' >> build.sh && \
    echo 'dart pub get' >> build.sh && \
    echo 'dart compile wasm lib/modulus.dart -o /modules/mod.wasm' >> build.sh && \
    echo 'echo "Build complete! WebAssembly file is available at /modules/mod.wasm"' >> build.sh && \
    chmod +x build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/app/build.sh"]