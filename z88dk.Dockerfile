FROM ubuntu:latest

LABEL Maintainer="Garrafon Software (@garrafonsoft)"
LABEL Version="0.1"
LABEL Date="2018-Apr-01"
LABEL Description="A basic Docker container to compile and use z88dk from GIT"
LABEL Creation_Command="docker build -t z88dk - < z88dk.Dockerfile"
LABEL Execution_Command="docker run -v $PWD:/src/ -it z88dk <command>"

RUN apt-get update && apt-get install -y build-essential git m4 libxml2-dev subversion bison flex python libboost-dev gputils texinfo && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd / && git clone --recursive https://github.com/z88dk/z88dk.git && cd z88dk && chmod 777 build.sh && ./build.sh

RUN cd / && svn checkout -r 9958 svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc && cd sdcc && patch -p0 < /z88dk/src/zsdcc/sdcc-z88dk.patch && ./configure --disable-ds390-port --disable-ds400-port && make && cd bin && mv sdcc /z88dk/bin/zsdcc && cp sdcpp /z88dk/bin/zsdcpp

ENV PATH="/z88dk/bin:${PATH}"
ENV ZCCCFG="/z88dk/lib/config/"

WORKDIR /src/
