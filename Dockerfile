FROM debian:12

WORKDIR /root

RUN apt update && apt install build-essential git python3 cmake curl ninja-build libssl-dev pkg-config -y

RUN curl -LO https://musl.cc/i686-linux-musl-cross.tgz
RUN tar -xf i686-linux-musl-cross.tgz
RUN git clone https://github.com/rust-lang/rust.git

WORKDIR /root/rust

RUN git checkout beta

RUN ./configure --musl-root-i686=../i686-linux-musl-cross/i686-linux-musl --disable-docs --set target.i686-unknown-linux-musl.crt-static=false --enable-extended

ENV CC_i686_unknown_linux_musl=/root/i686-linux-musl-cross/bin/i686-linux-musl-gcc
ENV CXX_i686_unknown_linux_musl=/root/i686-linux-musl-cross/bin/i686-linux-musl-g++

RUN ./x --help
RUN ./x dist --host='i686-unknown-linux-musl' --target i686-unknown-linux-musl
