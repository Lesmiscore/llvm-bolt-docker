FROM ubuntu

RUN apt-get update && \
    apt-get install -y build-essential git cmake ninja-build python && \
    apt-get upgrade -y && \
    mkdir /build && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists

WORKDIR /build

RUN git clone https://github.com/llvm-mirror/llvm llvm && \
    cd llvm/tools && \
    git checkout -b llvm-bolt f137ed238db11440f03083b1c88b7ffc0f4af65e && \
    git clone https://github.com/facebookincubator/BOLT llvm-bolt && \
    cd .. &&  \
    patch -p 1 < tools/llvm-bolt/llvm.patch

ARG JOBS=4

RUN mkdir build && \
    cd build && \
    cmake -G Ninja ../llvm && \
    ninja -j$JOBS
