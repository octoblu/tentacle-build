FROM ubuntu:12.04
MAINTAINER Octoblu Inc <docker@octoblu.com>

RUN mkdir /tentacle-build
WORKDIR /tentacle-build

COPY setup-ubuntu-x64.sh /tentacle-build/
RUN ./setup-ubuntu-x64.sh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /tentacle-build
RUN ./arduino-build.sh

RUN mv build tentacle-build
RUN zip -r tentacle-build-arduino.zip tentacle-build

VOLUME /tentacle-zip
