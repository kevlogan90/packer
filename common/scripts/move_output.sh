#!/bin/bash

if ! test -f $MANIFEST_LOC
then
    exit 1
fi

# TODO: Fix the nested jq call if possible
BUILD_INFO=$(jq ".builds[] | select(.packer_run_uuid==$(jq ".last_run_uuid" $MANIFEST_LOC))" $MANIFEST_LOC)
IMAGE_NAME=$(echo $BUILD_INFO | jq -r ".files[].name")
BUILD_TIME=$(echo $BUILD_INFO | jq -r ".build_time")
NEW_OUTPUT_DIR=$NEW_DIR/$BUILD_TIME
EXTENSION=${IMAGE_NAME##*.}

echo mkdir -p $NEW_DIR
mkdir -p $NEW_DIR
echo mv $OUTPUT_DIR $NEW_OUTPUT_DIR
mv $OUTPUT_DIR $NEW_OUTPUT_DIR
echo ln -sf $BUILD_TIME $NEW_DIR/latest
rm $NEW_DIR/latest
ln -sf $BUILD_TIME $NEW_DIR/latest
echo ln -sf $IMAGE_NAME $NEW_OUTPUT_DIR/$APP.$EXTENSION
ln -sf $IMAGE_NAME $NEW_OUTPUT_DIR/$APP.$EXTENSION
