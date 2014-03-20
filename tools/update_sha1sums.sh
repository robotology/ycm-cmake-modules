#!/bin/sh

YCM_ROOT=$(readlink --canonicalize --no-newline $(dirname $0)/..)
FILE=${YCM_ROOT}/modules/YCMEPHelper.cmake
MODULES=$(sed -n 's/set(_ycm_\(.\+\)_sha1sum \+[0-9a-f]\+)/\1/p' ${FILE})

for mod in ${MODULES}; do
  file=$(find ${YCM_ROOT} -name $mod.cmake)
  old_sha1sum=$(sed -n "s/set(_ycm_${mod}_sha1sum \+\([0-9a-f]\+\))/\1/p" ${FILE})
  new_sha1sum=$(sha1sum $file | awk '{print $1}')

  if [ "${old_sha1sum}" != "${new_sha1sum}" ]; then
    sed -i "s/${old_sha1sum}/${new_sha1sum}/g" ${FILE}
  fi
done
