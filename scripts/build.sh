#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"
CONFIG_BOARDS_DIR=$TOP_DIR/configs/boards
BUILD_DIR=$TOP_DIR/build
[ ! -d "$BUILD_DIR" ] && mkdir -p $BUILD_DIR/overlays $BUILD_DIR/overlays/packages $BUILD_DIR/recipes $BUILD_DIR/scripts

cleanup() {
    rm -rf $BUILD_DIR
}
trap cleanup EXIT

usage() {
    echo "====USAGE: build.sh -c <cpu> -b <board> -m <model> -d <distro>  -v <variant> -a <arch> -f <format> [-0]===="
    echo "Specify -0 to disable debug-shell, useful for automated build."
    echo "Examples:"
    echo "  ./build.sh -c rk3588 -b rock-5b -m debian -d bullseye -v xfce4 -a arm64 -f gpt"
    echo "  ./build.sh -c a311d -b radxa-zero2 -m ubuntu -d focal -v server -a arm64 -f mbr"
}

DEBUG_SHELL=

while getopts "c:b:m:d:a:v:f:h:0" flag; do
    case $flag in
        c)
            CPU="$OPTARG"
            ;;
        b)
            BOARD="$OPTARG"
            ;;
        m)
            MODEL="$OPTARG"
            ;;
        d)
            DISTRO="$OPTARG"
            ;;
        a)
            ARCH="$OPTARG"
            ;;
        v)
            VARIANT="$OPTARG"
            ;;
        f)
            FORMAT="$OPTARG"
            ;;
        0)
            DEBUG_SHELL=-0
            ;;
	esac
done

if [ ! $CPU ] && [ ! $BOARD ] && [ ! $MODEL ] && [ ! $DISTRO ] && [ ! $VARIANT ]  && [ ! $ARCH ] && [ ! $FORMAT ]; then
    usage
    exit
fi

build_board() {
    echo "====Start to build $BOARD board system image===="
    $SCRIPTS_DIR/debos-target-board.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT $DEBUG_SHELL
    $SCRIPTS_DIR/compress-system-image.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT
    echo "====Building $BOARD board system image is done===="
}

clean_system_images() {
    echo "====Start to clean system images===="
    $SCRIPTS_DIR/clean-system-images.sh
    echo "====Cleaning system images is done===="
}

${CONFIG_BOARDS_DIR}/$CPU/config-$BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT.sh
build_board
clean_system_images
