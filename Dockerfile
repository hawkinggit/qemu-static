FROM ubuntu:22.04

RUN sed -i '/^# deb-src /s/^# //' /etc/apt/sources.list
RUN apt update
RUN echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections && \
echo 'tzdata tzdata/Zones/Asia select Shanghai' | debconf-set-selections && \
DEBIAN_FRONTEND="noninteractive" apt install -yq tzdata 
RUN apt install -y python3-pip
RUN pip3 install tomli meson
RUN apt install -y ninja-build
RUN apt install -y libglib2.0-dev libselinux1-dev libblkid-dev

# required by qemu
RUN apt build-dep -yq qemu

# additional
RUN apt install -y bash xz-utils git patch wget libunistring2 libunistring-dev libmount-dev flex bison

WORKDIR /work


COPY command/base command/base

COPY command/libmount command/libmount
RUN /work/command/libmount

WORKDIR /work
COPY command/fetch command/fetch
RUN /work/command/fetch

COPY command/extract command/extract
RUN /work/command/extract

COPY patch patch
COPY command/patch command/patch
RUN /work/command/patch

COPY command/configure command/configure
RUN /work/command/configure

COPY command/make command/make
RUN /work/command/make

COPY command/install command/install
RUN /work/command/install

COPY command/package command/package
RUN /work/command/package
