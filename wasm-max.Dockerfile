FROM maven:3.9-eclipse-temurin-17

WORKDIR /app

# Copy Source files
COPY ./wasm-max .

# Create build script
RUN echo '#!/bin/bash' > /app/build.sh && \
    echo 'set -ex' >> /app/build.sh && \
    echo 'cd /app' >> /app/build.sh && \
    echo 'mvn clean package' >> /app/build.sh && \
    echo 'mkdir -p /modules' >> /app/build.sh && \
    echo 'find target/generated/wasm -name "*.wasm" -exec cp {} /modules/max.wasm \;' >> /app/build.sh && \
    chmod +x /app/build.sh

ENTRYPOINT ["/app/build.sh"]