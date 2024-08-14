# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module can be used to use YCM modules directly from the source repo,
# to just use them in the build without installing them.

if(DEFINED __USEYCMFROMSOURCE_INCLUDED)
  return()
endif()
set(__USEYCMFROMSOURCE_INCLUDED TRUE)

get_filename_component(_YCM_SRC_DIR ${CMAKE_CURRENT_LIST_DIR} DIRECTORY)
set(YCM_MODULE_DIR ${_YCM_SRC_DIR})

list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/find-modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/build-modules)
list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/style-modules)

if(CMAKE_VERSION VERSION_LESS 3.22)
  set(YCM_USE_CMAKE_NEXT_DEFAULT_VALUE ON)
else()
  set(YCM_USE_CMAKE_NEXT_DEFAULT_VALUE OFF)
endif()
option(YCM_USE_CMAKE_NEXT "Use legacy YCM fork of ExternalProject module instead of upstream CMake ExternalProject" ${YCM_USE_CMAKE_NEXT_DEFAULT_VALUE})
if(NOT YCM_USE_CMAKE_NEXT AND CMAKE_VERSION VERSION_LESS 3.22)
  message(FATAL_ERROR "YCM_USE_CMAKE_NEXT set to OFF is not supported with CMake < 3.22")
endif()
if(YCM_USE_CMAKE_NEXT)
  set_property(GLOBAL PROPERTY YCM_USE_CMAKE_NEXT ON)
  list(APPEND CMAKE_MODULE_PATH ${_YCM_SRC_DIR}/cmake-next/proposed)
else()
  set_property(GLOBAL PROPERTY YCM_USE_CMAKE_NEXT OFF)
endif()
