FROM ubuntu:noble-20250127

RUN apt-get update

RUN apt install wabt

COPY wasm-sub/src/sub.wat .

ENTRYPOINT ["wat2wasm", "sub.wat", "-o", "/modules/sub.wasm"]