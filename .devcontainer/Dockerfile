# .devcontainer dockerfile
#
# We build off the Microsoft alpine root and copy in /opt/z88dk from the
# standard z88dk docker image

# Sorry, I've not got automatic arm64 builds sorted
ARG PLATFORM=x86_64

# Pull the latest z88dk, change as an approrpiate tag
FROM --platform=$PLATFORM  z88dk/z88dk:latest AS z88dk

# Our base is alpine vscode variant
FROM --platform=$PLATFORM mcr.microsoft.com/vscode/devcontainers/base:alpine

# Copy the alpine compiled z88dk from the z88dk docker image
ENV Z88DK_PATH="/opt/z88dk"
COPY --from=z88dk /opt/z88dk /opt/z88dk

# This .devcontainer is focussed on building z88dk, install those dependencies
#
# If you just want to use z88dk, then you don't need to install these
RUN apk add --no-cache build-base libxml2 m4 gmp \
    && apk add --no-cache -t .build_deps bison flex libxml2-dev git subversion boost-dev texinfo \
		perl-template-toolkit perl-app-cpanminus curl gmp-dev \
    && cpanm -l $HOME/perl5 --no-wget local::lib Template::Plugin::YAML


# Set the environment
ENV PATH="${Z88DK_PATH}/bin:${PATH}" \
    ZCCCFG="${Z88DK_PATH}/lib/config/"

WORKDIR /src/
