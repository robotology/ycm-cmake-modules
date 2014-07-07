#!/bin/sh

#=============================================================================
# Copyright 2014 iCub Facility, Istituto Italiano di Tecnologia
#   Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of YCM, substitute the full
#  License text for the above reference.)


if [ -z "$1" ]; then
  echo "Usage: $0 [file]"
fi

YCM_ROOT=$(readlink --canonicalize --no-newline $(dirname $1)/..)
FILE=${YCM_ROOT}/modules/YCMEPHelper.cmake
MODULES=$(sed -n 's/set(_ycm_\(.\+\)_sha1sum \+[0-9a-f]\+)/\1/p' ${FILE})

for mod in ${MODULES}; do
  file=$(find ${YCM_ROOT}/modules ${YCM_ROOT}/cmake-next ${YCM_ROOT}/tools -name $mod.cmake)
  old_sha1sum=$(sed -n "s/set(_ycm_${mod}_sha1sum \+\([0-9a-f]\+\))/\1/p" ${FILE})
  new_sha1sum=$(sha1sum $file | head -n1 | awk '{print $1}')
  if [ "${old_sha1sum}" != "${new_sha1sum}" ]; then
    echo "File ${file} has wrong sha1sum"
    echo " OLD: ${old_sha1sum}"
    echo " NEW: ${new_sha1sum}"
    exit 1
  fi
done
