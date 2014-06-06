# Copyright (C) 2000-2014 Kitware, Inc.
# Copyright (C) 2014  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the 3-clause BSD License

# Original file: <CMake Repository>/Source/CMakeVersionSource.cmake
#                git revision: 2622bc3f65162bf6d6cb5838da6999f8b5ca75cf

set(YCM_MAJOR_VERSION 0)
set(YCM_MINOR_VERSION 1)
set(YCM_PATCH_VERSION 0)
set(YCM_VERSION ${YCM_MAJOR_VERSION}.${YCM_MINOR_VERSION}.${YCM_PATCH_VERSION})

# Try to identify the current development source version.
set(YCM_VERSION_SOURCE "")
if(EXISTS ${YCM_SOURCE_DIR}/.git/HEAD)
  find_package(Git QUIET)
  if(GIT_FOUND)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} describe HEAD
      OUTPUT_VARIABLE _tag
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET
      WORKING_DIRECTORY ${YCM_SOURCE_DIR}
      )
    if(NOT _tag STREQUAL "v${YCM_VERSION}")
      execute_process(
        COMMAND ${GIT_EXECUTABLE} log -1 --date=iso HEAD
        OUTPUT_VARIABLE _log_message
        OUTPUT_STRIP_TRAILING_WHITESPACE
        WORKING_DIRECTORY ${YCM_SOURCE_DIR}
        )
      string(REGEX MATCH "Date: +([0-9-]+)" _unused ${_log_message})
      string(REPLACE "-" "" _date ${CMAKE_MATCH_1})
      execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --verify -q --short=8 HEAD
        OUTPUT_VARIABLE _head
        OUTPUT_STRIP_TRAILING_WHITESPACE
        WORKING_DIRECTORY ${YCM_SOURCE_DIR}
        )
      if(_head OR _date)
        set(YCM_VERSION_SOURCE "${_date}+git${_head}")
        execute_process(
          COMMAND ${GIT_EXECUTABLE} update-index -q --refresh
          WORKING_DIRECTORY ${YCM_SOURCE_DIR}
          )
      endif()
    endif()
    execute_process(
      COMMAND ${GIT_EXECUTABLE} diff-index --name-only HEAD --
      OUTPUT_VARIABLE _dirty
      OUTPUT_STRIP_TRAILING_WHITESPACE
      WORKING_DIRECTORY ${YCM_SOURCE_DIR}
      )
  endif()
endif()

if(YCM_VERSION_SOURCE)
  set(YCM_VERSION "${YCM_VERSION}~${YCM_VERSION_SOURCE}")
endif()
if(_dirty)
  set(YCM_VERSION "${YCM_VERSION}+dirty")
endif()
