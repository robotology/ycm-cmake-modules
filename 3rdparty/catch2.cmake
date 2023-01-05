# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# Catch2 related modules are taken from the Catch2 repository.

set(_dir "${CMAKE_CURRENT_SOURCE_DIR}/catch2")

if(YCM_DOWNLOAD_3RDPARTY)
  set(_files extras/Catch.cmake                 ab6c7375be9a8e71ee84c6f8537113f9f47daf99
             extras/CatchAddTests.cmake         ab6c7375be9a8e71ee84c6f8537113f9f47daf99
             extras/ParseAndAddCatchTests.cmake ab6c7375be9a8e71ee84c6f8537113f9f47daf99
             LICENSE.txt                        ab6c7375be9a8e71ee84c6f8537113f9f47daf99)
  set(_ref v3.2.1)
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
endif()

_ycm_install(3rdparty-catch2 FILES "${_dir}/extras/Catch.cmake"
                                   "${_dir}/extras/CatchAddTests.cmake"
                                   "${_dir}/extras/ParseAndAddCatchTests.cmake"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-catch2 FILES "${_dir}/LICENSE.txt"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                             RENAME COPYING.Catch2)

_ycm_install(3rdparty-catch2 FILES "${_dir}/README.Catch2"
                             DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
