# To create the image:
#   $ docker build -t z88dk -f z88dk.Dockerfile .
# To run the container:
#   $ docker run -v ${PWD}:/src/ -it z88dk <command>

# Built from the build context, not from a clone of master. A clone always
# built master whatever was checked out, so tag and branch images did not
# contain their own code. .dockerignore keeps .git and the build products out,
# so this is smaller than the shallow clone it replaces.
FROM alpine:latest AS build

ENV Z88DK_PATH="/opt/z88dk"

RUN apk add --no-cache build-base libxml2 m4 gmp \
        bison flex libxml2-dev git subversion boost-dev texinfo \
        perl-template-toolkit perl-app-cpanminus curl gmp-dev \
    && cpanm -l $HOME/perl5 --no-wget local::lib Template::Plugin::YAML

COPY . ${Z88DK_PATH}

# Z88DK_VERSION is built from these in the top Makefile, which normally shells
# out to git. .git is not in the context, so pass them in. The shallow clone
# this replaces reported a commit count of 1.
ARG GIT_REV=unknown
ARG GIT_COUNT=0
ENV git_rev=${GIT_REV} \
    git_count=${GIT_COUNT}

RUN cd ${Z88DK_PATH} \
    && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" \
    && chmod 777 build.sh \
    && BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh \
    && make install-clean bins-clean

# The build deps stay behind in the builder rather than being apk del'd out of
# the one layer they were installed in.
FROM alpine:latest

ENV Z88DK_PATH="/opt/z88dk"

RUN apk add --no-cache build-base libxml2 m4 gmp

COPY --from=build /opt/z88dk /opt/z88dk

ENV PATH="${Z88DK_PATH}/bin:${PATH}" \
    ZCCCFG="${Z88DK_PATH}/lib/config/"

WORKDIR /src/
