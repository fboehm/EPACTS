FROM ubuntu:18.04

# To suppress tzdata region prompt
ARG DEBIAN_FRONTEND=noninteractive

ENV SRC_DIR /tmp/epacts-src

RUN set -x \
    && apt-get update && apt-get install -y \
        build-essential \
        cmake \
        curl \
        ghostscript \
        git \
        gnuplot \
        groff \
        help2man \
        lsb-release \
        python \
        python-pip \
        r-base \
        rpm \
    && pip install cget

WORKDIR ${SRC_DIR}
COPY requirements.txt ${SRC_DIR}
RUN cget install -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -f requirements.txt \
    && mkdir -p ${SRC_DIR}/build

COPY . ${SRC_DIR}
WORKDIR ${SRC_DIR}/build
RUN cmake -DCMAKE_TOOLCHAIN_FILE=../cget/cget/cget.cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make install \
    && rm -rf ${SRC_DIR}

WORKDIR /
ENTRYPOINT [ "epacts" ]
CMD [ "help" ]
