#=============================================================================
# Copyright 2013-2019 Istituto Italiano di Tecnologia (IIT)
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
# Catch2 related modules are taken from the Catch2 repository.

set(_files contrib/Catch.cmake                 6f80938187f2fe004db163481ad7b468c6f22ea4
           contrib/CatchAddTests.cmake         800eac1ea012cc4bea2f23924cc88ae65d2fbc76
           contrib/ParseAndAddCatchTests.cmake 7ae77456d2e7a24021e38c4af1c16068ed65ef90
           LICENSE.txt                         3cba29011be2b9d59f6204d6fa0a386b1b2dbd90)
set(_ref de3a208e167c6baee6e8dc46f2c0466b311324c2)
set(_dir "${CMAKE_CURRENT_BINARY_DIR}/catch2")
_ycm_download(3rdparty-catch2
              "Catch2 (C++ Automated Test Cases in a Header) git repository"
              "https://raw.githubusercontent.com/catchorg/Catch2/<REF>/<FILE>"
              ${_ref} "${_dir}" "${_files}")

file(WRITE "${_dir}/README.Catch2"
"Some of the files in this folder and its subfolder come from the Catch2 git
repository (ref ${_ref}):

  https://github.com/catchorg/Catch2/

Redistribution and use is allowed according to the terms of the Boost Software
License. See accompanying file COPYING.Catch2 for details.
")

_ycm_install(3rdparty-catch2 FILES "${_dir}/contrib/Catch.cmake"
                                   "${_dir}/contrib/CatchAddTests.cmake"
                                   "${_dir}/contrib/ParseAndAddCatchTests.cmake"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-catch2 FILES "${_dir}/LICENSE.txt"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                             RENAME COPYING.Catch2)

_ycm_install(3rdparty-catch2 FILES "${_dir}/README.Catch2"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
