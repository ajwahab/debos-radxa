FROM debian:bookworm

RUN echo "deb http://debian.csail.mit.edu/debian/ bookworm main non-free contrib" > /etc/apt/sources.list
RUN echo "deb http://debian.csail.mit.edu/debian/ bookworm-updates main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security/ bookworm-security main non-free contrib" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get -y --allow-unauthenticated install debos \
    xz-utils dosfstools libterm-readkey-perl user-mode-linux libslirp-helper \
    && apt install -y -f

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends vim ssh ssh-import-id git tree \
    debian-keyring gpgv network-manager host curl bmap-tools

ENV USER=root \
    HOME=/root
