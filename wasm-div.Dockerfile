FROM tinygo/tinygo:0.36.0 AS builder

WORKDIR /app

# First, determine what Linux distribution we're using
RUN cat /etc/os-release || echo "No os-release file"

# Try to install using apt-get (Debian/Ubuntu)
RUN apt-get update && apt-get install -y bash binaryen || echo "apt-get failed"

# Copy the Go module files
COPY wasm-div ./

# Create the build script with TinyGo and optimization
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -e' >> /app/build.sh && \
    echo 'echo "Starting TinyGo to WebAssembly compilation..."' >> /app/build.sh && \
    echo 'tinygo build -o main.wasm -target wasm main.go' >> /app/build.sh && \
    echo 'echo "Original TinyGo size: $(du -h main.wasm | cut -f1)"' >> /app/build.sh && \
    echo 'wasm-opt -Oz main.wasm -o /modules/div.wasm' >> /app/build.sh && \
    echo 'echo "Optimized size: $(du -h /modules/div.wasm | cut -f1)"' >> /app/build.sh && \
    echo 'echo "Build complete. Optimized WebAssembly file is available in the modules directory."' >> /app/build.sh && \
    chmod +x /app/build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/app/build.sh"]