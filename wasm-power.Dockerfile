FROM python:3.10-slim AS builder

WORKDIR /app

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    binaryen \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install emsdk (Emscripten SDK)
RUN git clone https://github.com/emscripten-core/emsdk.git && \
    cd emsdk && \
    ./emsdk install latest && \
    ./emsdk activate latest

# Copy the Python source file
COPY wasm-power/power.py ./

# Create a simple JavaScript wrapper for the Python code
RUN echo 'export function power(base, exponent) { return base ** exponent; }' > power.js

# Create the build script
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -e' >> /app/build.sh && \
    echo 'echo "Starting WebAssembly compilation..."' >> /app/build.sh && \
    echo 'source /app/emsdk/emsdk_env.sh' >> /app/build.sh && \
    echo 'mkdir -p /modules' >> /app/build.sh && \
    echo 'emcc -O3 -s WASM=1 -s EXPORTED_FUNCTIONS="[\"_power\"]" -s EXPORTED_RUNTIME_METHODS="[\"ccall\",\"cwrap\"]" -o /tmp/power.js -x c++ - << EOF' >> /app/build.sh && \
    echo '#include <emscripten.h>' >> /app/build.sh && \
    echo 'extern "C" {' >> /app/build.sh && \
    echo '  EMSCRIPTEN_KEEPALIVE' >> /app/build.sh && \
    echo '  int power(int base, int exponent) {' >> /app/build.sh && \
    echo '    if (exponent < 0) return 0;' >> /app/build.sh && \
    echo '    if (exponent == 0) return 1;' >> /app/build.sh && \
    echo '    int result = 1;' >> /app/build.sh && \
    echo '    while (exponent > 0) {' >> /app/build.sh && \
    echo '      if (exponent & 1) result *= base;' >> /app/build.sh && \
    echo '      exponent >>= 1;' >> /app/build.sh && \
    echo '      base *= base;' >> /app/build.sh && \
    echo '    }' >> /app/build.sh && \
    echo '    return result;' >> /app/build.sh && \
    echo '  }' >> /app/build.sh && \
    echo '}' >> /app/build.sh && \
    echo 'EOF' >> /app/build.sh && \
    echo 'echo "Original WASM size: $(du -h /tmp/power.wasm | cut -f1)"' >> /app/build.sh && \
    echo 'wasm-opt -Oz /tmp/power.wasm -o /modules/power.wasm' >> /app/build.sh && \
    echo 'cp /tmp/power.js /modules/' >> /app/build.sh && \
    echo 'echo "Optimized size: $(du -h /modules/power.wasm | cut -f1)"' >> /app/build.sh && \
    echo 'echo "Build complete. Optimized WebAssembly file is available in the modules directory."' >> /app/build.sh && \
    chmod +x /app/build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/app/build.sh"]