# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# CMakeRC.cmake is taken from the CMakeRC repository.

set(_dir "${CMAKE_CURRENT_SOURCE_DIR}/cmrc")

if(YCM_DOWNLOAD_3RDPARTY)
  set(_files CMakeRC.cmake  15109e38dddefce15028a0d0563557b2dc72446a
             LICENSE.txt    053245749bccc40304ec4d9d0a47aea0b1c9f8f6)
  set(_ref f26f6e35a859b0ba28818dbcc0ed9b3880881cf4)

  _ycm_download(3rdparty-cmrc
                "CMakeRC (A Standalone CMake-Based C++ Resource Compiler) git repository"
                "https://raw.githubusercontent.com/vector-of-bool/cmrc/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.CMakeRC"
"Some of the files in this folder and its subfolder come from the CMakeRC git
repository (ref ${_ref}):

  https://github.com/vector-of-bool/cmrc/

Redistribution and use is allowed according to the terms of the MIT License.
See accompanying file COPYING.CMakeRC for details.
")
endif()

_ycm_install(3rdparty-cmrc FILES "${_dir}/CMakeRC.cmake"
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-cmrc FILES "${_dir}/LICENSE.txt"
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                           RENAME COPYING.CMakeRC)

_ycm_install(3rdparty-cmrc FILES "${_dir}/README.CMakeRC"
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
