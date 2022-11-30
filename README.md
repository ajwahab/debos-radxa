# debos-radxa

## Introduction

This guide describes how to use debos-radxa, based on [debos](https://github.com/go-debos/debos), to generate Debian/Ubuntu image for Radxa boards.

Please note that the [release](https://github.com/radxa/debos-radxa/releases/latest) are auto generated builds without additional testing, if you have issues with the images, please submit an issue.

## Supported boards and system images

* Radxa CM3 IO
* Radxa E23
* Radxa E25
* Radxa NX5
* Radxa Zero
* Radxa Zero 2
* ROCK 3A
* ROCK 3B
* ROCK 3C
* ROCK 5A
* ROCK 5B
* ROCK 4B
* ROCK 4C+

Auto generated build images: https://github.com/radxa/debos-radxa/releases/latest

## Build Host

### Required Packages for the Build Host

You must install essential host packages on your build host.

The following command installs the host packages on Debian/Ubuntu.

```shell
sudo apt-get install -y git
```

### Install Docker Engine on Ubuntu

See Docker Docs [installing Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).

## Use Git to Clone debos-radxa

```shell
git clone https://github.com/radxa/debos-radxa.git
```

## Build Your Image

### Part One: Build image step by step

Launch `dev-shell` to get a shell inside debos docker.

```shell
cd debos-radxa
docker/dev-shell -b
Building debos-radxa environment...
Sending build context to Docker daemon   2.56kB
Step 1/7 : FROM debian:bookworm
...
...
...
Step 7/7 : ENV USER=root     HOME=/root
 ---> Using cache
 ---> bc195e420707
Successfully built bc195e420707
Successfully tagged debos-radxa:1

docker/dev-shell -r
Running debos-radxa shell...
root@terra:~/debos-radxa#
```

Launch `./build.sh` to get build options.

```shell
root@terra:/opt/debos-radxa# ./build-os.sh
TOP DIR = /opt/debos-radxa
====USAGE: ./build-os.sh -b <board> -m <model>====
Board list:
    radxa-cm3-io
    radxa-e23
    radxa-e25
    radxa-nx5
    radxa-zero
    radxa-zero2
    rockpi-4b
    rock-4c-plus
    rock-3a
    rock-3b
    rock-3c
    rock-5a
    rock-5b

Model list:
    debian
    ubuntu
```

Start to build image such as rock-5b-ubuntu-focal-server-arm64-gpt image.

```shell
root@terra:~/debos-radxa# ./build-os.sh -b rock-5b -m ubuntu
TOP DIR = /opt/debos-radxa
====Start to build  board system image====
TOP DIR = /opt/debos-radxa
====Start to preppare workspace directory, build====
...
...
...
====debos rock-5b-ubuntu-focal-server-arm64-gpt end====
TOP DIR = /opt/debos-radxa
 System image rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img is generated. See it in /opt/debos-radxa/output
/opt/debos-radxa
====Building  board system image is done====
====Start to clean system images====
TOP DIR = /opt/debos-radxa
I: show all system images:
total 329092
drwxr-xr-x  2 root root      4096 Mar  8 11:09 .
drwxrwxr-x 10 1002 1002      4096 Mar  8 11:08 ..
-rw-r--r--  1 root root    139442 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.bmap
-rw-r--r--  1 root root        90 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.md5.txt
-rw-r--r--  1 root root 336828856 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.xz
====Cleaning system images is done====
root@terra:~/debos-radxa#
```

The generated system images will be copied to `./output` directory.

### Part Two: Build image with one line command

#### Example one of building rock-3a-ubuntu-focal-server-arm64-gpt image

In this example we will build ROCK 3A's system image with full options:

```shell
cd debos-radxa
docker run --rm -it --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint "./build-os.sh -b rock-3a -m ubuntu" debos-radxa:1
```

#### Example two of building radxa-zero2-ubuntu-focal-server-arm64-mbr image

You can also build supported configuration with the following commands:

```shell
cd debos-radxa
docker run --rm -it --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint "./build-os.sh -m ubuntu -b radxa-zero2" debos-radxa:1
```

The generated system images will be copied to `./output` directory. You can specify different configuration in the 3rd line.

## How to debug errors

Launch `dev-shell` to get a shell inside debos docker. You can then run `build.sh` to monitor the build status. debos mounts root partition at `/scratch/mnt`, and boot partition is mounted at `/scratch/mnt/boot`. You can also `chroot /scratch/mnt` to examine the file system.

Currently `dev-shell` uses a custom docker image to build, so your result might be different from GitHub build. If you want to reproduce GitHub build please use the command from Usage section.

## Add support for new boards

`./configs/boards` are board-specific debos recipes.

`./rootfs/packages` contains additional packages.

## Default settings

* Default non-root user: rock (password: rock)
* Automatically load Bluetooth firmware after startup
* The first boot will resize root filesystem to use all available disk space
* SSH installed by default
* Hostname: board_name
