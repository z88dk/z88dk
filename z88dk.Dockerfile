# To create the image:
#  macOS / GNU/Linux:
#   $ docker build --squash -t z88dk - < z88dk.Dockerfile
#  Windows 10 PowerShell:
#   PS> cmd /c 'docker build --squash -t z88dk - < z88dk.Dockerfile'
# To run the container (works for macOS, GNU/Linux & Windows PowerShell):
#  docker run -v ${PWD}:/src/ -it z88dk <command>

FROM alpine:latest

LABEL Version="0.6" \
      Date="2018-Apr-05" \
      Maintainer="Garrafon Software (@garrafonsoft)" \
      Description="A basic Docker container to compile and use z88dk from GIT"

RUN apk add --no-cache build-base m4 bison flex libxml2 boost \ 
    && apk add --no-cache -t .build_deps libxml2-dev git subversion boost-dev texinfo \
    && mkdir /opt \
    && cd /opt \
    && git clone --depth 1 --recursive https://github.com/z88dk/z88dk.git \
    && cd z88dk \
    && chmod 777 build.sh \
    && ./build.sh \
    && cd /opt \
    && svn checkout -r 9958 svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc \
    && cd sdcc \
    && patch -p0 < /opt/z88dk/src/zsdcc/sdcc-z88dk.patch \
    && ./configure --disable-mcs51-port --disable-gbz80-port --disable-avr-port --disable-ds390-port \
                   --disable-ds400-port --disable-hc08-port --disable-pic-port --disable-pic14-port \
                   --disable-pic16-port --disable-stm8-port --disable-tlcs90-port --disable-s08-port \
                   --disable-ucsim --disable-device-lib --disable-packihx \
    && make \
    && cd bin \
    && mv sdcc /opt/z88dk/bin/zsdcc \
    && mv sdcpp /opt/z88dk/bin/zsdcpp \
    && cd / \
    && rm -fR /opt/sdcc \
    && apk del .build_deps

ENV PATH="/opt/z88dk/bin:${PATH}" \
    ZCCCFG="/opt/z88dk/lib/config/"

WORKDIR /src/
