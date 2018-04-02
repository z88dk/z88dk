FROM ubuntu:latest

LABEL Maintainer="Garrafon Software (@garrafonsoft)"
LABEL Version="0.3"
LABEL Date="2018-Apr-02"
LABEL Description="A basic Docker container to compile and use z88dk from GIT"
LABEL Creation_Command="docker build -t z88dk - < z88dk.Dockerfile"
LABEL Execution_Command="docker run -v $PWD:/src/ -it z88dk <command>"

RUN apt-get update && apt-get install -y build-essential git m4 libxml2-dev subversion bison flex libboost-dev texinfo && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /opt && git clone --recursive https://github.com/z88dk/z88dk.git && cd z88dk && chmod 777 build.sh && ./build.sh

RUN cd /opt && svn checkout -r 9958 svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc && cd sdcc && patch -p0 < /opt/z88dk/src/zsdcc/sdcc-z88dk.patch && ./configure --disable-mcs51-port --disable-gbz80-port --disable-avr-port --disable-ds390-port --disable-ds400-port --disable-hc08-port --disable-pic-port --disable-pic14-port --disable-pic16-port --disable-stm8-port --disable-tlcs90-port --disable-s08-port --disable-ucsim --disable-device-lib --disable-packihx && make && cd bin && mv sdcc /opt/z88dk/bin/zsdcc && cp sdcpp /opt/z88dk/bin/zsdcpp

# Uncomment the following line to have an unpatched SDCC r9958 installed:
# RUN cd /opt/sdcc && patch -Rp0 < /opt/z88dk/src/zsdcc/sdcc-z88dk.patch && make && make install

ENV PATH="/opt/z88dk/bin:${PATH}"
ENV ZCCCFG="/opt/z88dk/lib/config/"

WORKDIR /src/
