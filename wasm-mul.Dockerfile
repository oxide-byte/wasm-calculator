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

# Copy Kotlin source code
COPY wasm-mul/src /app/src
COPY wasm-mul/build.gradle.kts /app/build.gradle.kts
COPY wasm-mul/gradle.properties /app/gradle.properties
COPY wasm-mul/settings.gradle.kts /app/settings.gradle.kts

# Create the build script
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -e' >> /app/build.sh && \
    echo 'echo "Starting Kotlin to WebAssembly compilation..."' >> /app/build.sh && \
    echo 'gradle build --no-daemon' >> /app/build.sh && \
    echo 'cp -r build/compileSync/wasm/main/* /modules/' >> /app/build.sh && \
    echo 'echo "Build complete. WebAssembly files are available in the modules directory."' >> /app/build.sh && \
    chmod +x /app/build.sh

# Set the entrypoint to run the build script
ENTRYPOINT ["/app/build.sh"]