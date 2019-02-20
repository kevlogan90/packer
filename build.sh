#!/bin/bash

rm -rf output-*

START=$(date +%s)
jq -s '[.[]
       | to_entries]
       | flatten
       | reduce .[] as $dot ({}; .[$dot.key] += $dot.value)' \
               common/variables.json \
               $7/common/variables.json \
               $3/common/variables.json \
               $3/$4.json \
               $1/common/variables.json \
               $1/main.json \
               $7/main.json \
               $1/$2.json \
               $1/common/provisioners.json \
               $3/common/provisioners.json \
               $7/common/provisioners.json \
               common/provisioners.json \
               $1/common/post-processors.json \
               $3/common/post-processors.json \
               $7/common/post-processors.json \
               common/post-processors.json \
               | packer build -var=base_build_version=$5 -var base_build_type=$6 - | tee logs/packer-build-$1-$2.log
END=$(date +%s)
echo Took $(($END - $START)) seconds to build
