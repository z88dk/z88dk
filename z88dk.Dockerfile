# To create the image:
#   $ docker build -t z88dk -f z88dk.Dockerfile .
# To run the container:
#   $ docker run -v ${PWD}:/src/ -it z88dk <command>

FROM alpine:latest

ENV Z88DK_PATH="/opt/z88dk"

RUN apk add --no-cache build-base libxml2 m4 gmp \
    && apk add --no-cache -t .build_deps bison flex libxml2-dev git subversion boost-dev texinfo \
		perl-template-toolkit perl-app-cpanminus curl gmp-dev \
    && cpanm -l $HOME/perl5 --no-wget local::lib Template::Plugin::YAML \
    && git clone --depth 1 --recursive https://github.com/z88dk/z88dk.git ${Z88DK_PATH} \
    && cd ${Z88DK_PATH} \ 
    && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" \
    && chmod 777 build.sh \
    && BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh \
    && make install-clean bins-clean  \
    && apk del .build_deps

ENV PATH="${Z88DK_PATH}/bin:${PATH}" \
    ZCCCFG="${Z88DK_PATH}/lib/config/"

WORKDIR /src/
