FROM node:18-alpine

WORKDIR /app

# Install AssemblyScript globally
RUN npm install -g assemblyscript

# Copy Source files
COPY wasm-add .

# Install dependencies
RUN npm install

# Build command
ENTRYPOINT ["npm", "run", "asbuild"]