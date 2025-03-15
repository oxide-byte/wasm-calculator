FROM gradle:7.6-jdk11

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    zip \
    git \
    build-essential \
    cmake \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

COPY wasm-mul/ /app/

# Create the build script
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -e' >> /app/build.sh && \
    echo 'echo "Starting Kotlin to WebAssembly compilation..."' >> /app/build.sh && \
    echo 'gradle build --no-daemon' >> /app/build.sh && \
    echo 'cp -r build/dist/wasmJs/productionExecutable/wasm-mul-wasm-js.wasm /modules/mul.wasm' >> /app/build.sh && \
    echo 'echo "Build complete. WebAssembly files are available in the modules directory."' >> /app/build.sh && \
    chmod +x /app/build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/app/build.sh"]