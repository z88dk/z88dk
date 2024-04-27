

# Sorry, I've not got automatic arm64 builds sorted
ARG PLATFORM=x86_64

# Pull the latest z88dk, change as an approrpiate tag
FROM --platform=$PLATFORM  z88dk/z88dk:latest AS z88dk

# Our base is alpine vscode variant
FROM --platform=$PLATFORM mcr.microsoft.com/vscode/devcontainers/base:alpine

# Copy the alpine compiled z88dk from the z88dk docker image
ENV Z88DK_PATH="/opt/z88dk"
COPY --from=z88dk /opt/z88dk /opt/z88dk

# Set the environment
ENV PATH="${Z88DK_PATH}/bin:${PATH}" \
    ZCCCFG="${Z88DK_PATH}/lib/config/"

WORKDIR /src/
