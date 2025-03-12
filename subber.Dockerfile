FROM ubuntu:noble-20250127

RUN apt-get update

RUN apt install wabt

COPY wasm-subber/src/subber.wat .

ENTRYPOINT ["wat2wasm", "subber.wat", "-o", "/modules/subber.wasm"]