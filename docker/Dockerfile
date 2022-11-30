FROM debian:bullseye

RUN echo "deb http://debian.csail.mit.edu/debian/ bullseye main non-free contrib" > /etc/apt/sources.list
RUN echo "deb http://debian.csail.mit.edu/debian/ bullseye-updates main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security/ bullseye-security main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update -y && apt-get -y --allow-unauthenticated install debos \
    xz-utils dosfstools libterm-readkey-perl user-mode-linux libslirp-helper \
    && apt install -y -f

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends vim ssh ssh-import-id git tree \
    debian-keyring gpgv network-manager host curl bmap-tools

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts

ENV USER=root \
    HOME=/root
