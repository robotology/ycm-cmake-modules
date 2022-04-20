# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module can be used to use YCM modules directly from the source repo,
# to just use them in the build without installing them.

if(DEFINED __USEYCMFROMSOURCE_INCLUDED)
  return()
endif()
set(__USEYCMFROMSOURCE_INCLUDED TRUE)

get_filename_component(_YCM_SRC_DIR ${CMAKE_CURRENT_LIST_DIR} DIRECTORY)
 
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/find-modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/build-modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/style-modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/cmake-next/proposed)
