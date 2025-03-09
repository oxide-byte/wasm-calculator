FROM gradle:jdk23-ubi-minimal

WORKDIR /app

# Copy project files
COPY ./wasm-multiplier .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the WebAssembly module
RUN ./gradlew wasmBrowserProductionExecutableCompile

# The output will be in build/compileSync/wasm/main/productionExecutable/
CMD ["echo", "WASM build completed!"]