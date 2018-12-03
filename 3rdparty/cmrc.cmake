#=============================================================================
# Copyright 2013-2018 Istituto Italiano di Tecnologia (IIT)
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


##############################################################################
# CMakeRC.cmake is taken from the CMakeRC repository.

set(_files CMakeRC.cmake  e8c69652bfd87abb1d4ac8cb977ec2b5050fdec4
           LICENSE.txt    053245749bccc40304ec4d9d0a47aea0b1c9f8f6)
set(_ref 966a1a717715f4e57fb1de00f589dea1001b5ae6)
set(_dir "${CMAKE_CURRENT_BINARY_DIR}/cmrc")

_ycm_download(3rdparty-cmrc
              "CMakeRC (A Standalone CMake-Based C++ Resource Compiler) git repository"
              "https://raw.githubusercontent.com/vector-of-bool/cmrc/<REF>/<FILE>"
              ${_ref} "${_dir}" "${_files}")

file(WRITE "${_dir}/README.CMakeRC"
"Some of the files in this folder and its subfolder come from the CMakeRC git
repository (ref ${_ref}):

  https://github.com/vector-of-bool/cmrc/

Redistribution and use is allowed according to the terms of the Boost Software
License. See accompanying file COPYING.CMakeRc for details.
")

_ycm_install(3rdparty-catch2 FILES "${_dir}/CMakeRC.cmake"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-catch2 FILES "${_dir}/LICENSE.txt"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                             RENAME COPYING.CMakeRC)

_ycm_install(3rdparty-catch2 FILES "${_dir}/README.CMakeRC"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
