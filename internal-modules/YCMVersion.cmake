# This module should not be used outside YCM.

#=============================================================================
# Copyright 2000-2014 Kitware, Inc.
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

# Original file: <CMake Repository>/Source/CMakeVersionSource.cmake
#                git revision: 2622bc3f65162bf6d6cb5838da6999f8b5ca75cf

set(YCM_VERSION_MAJOR 0)
set(YCM_VERSION_MINOR 2)
set(YCM_VERSION_PATCH 0)

# Clean version.
set(YCM_VERSION_SHORT "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_PATCH}")

# API version.
set(YCM_VERSION_API "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}")

# Full version, including git commit and dirty state.
set(YCM_VERSION "${YCM_VERSION_SHORT}")

# Package version, including the number of commits.
# WARNING: YCM_VERSION_PACKAGE is not unique, but it is still useful.
set(YCM_VERSION_PACKAGE "${YCM_VERSION_SHORT}")

# Try to identify the current development source version.
unset(YCM_VERSION_SOURCE)
unset(YCM_VERSION_DIRTY)
unset(YCM_VERSION_REVISION)
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
    if(_dirty)
      set(YCM_VERSION_DIRTY "dirty")
    endif()
    execute_process(
      COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=0 HEAD
      OUTPUT_VARIABLE _last_tag
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET
      RESULT_VARIABLE _err
      WORKING_DIRECTORY ${YCM_SOURCE_DIR}
      )
    set(_commit HEAD)
    if(NOT _err)
      set(_commit ${_last_tag}..${_commit})
    endif()
    execute_process(
      COMMAND ${GIT_EXECUTABLE} rev-list --count ${_commit} --
      OUTPUT_VARIABLE _commit_count
      OUTPUT_STRIP_TRAILING_WHITESPACE
      WORKING_DIRECTORY ${YCM_SOURCE_DIR}
      )
    if(_commit_count)
      set(YCM_VERSION_REVISION "${_commit_count}")
    endif()
  endif()
endif()

if(DEFINED YCM_VERSION_SOURCE)
  set(YCM_VERSION "${YCM_VERSION}~${YCM_VERSION_SOURCE}")
endif()
if(DEFINED YCM_VERSION_DIRTY)
  set(YCM_VERSION "${YCM_VERSION}+${YCM_VERSION_DIRTY}")
endif()
if(DEFINED YCM_VERSION_REVISION)
  set(YCM_VERSION_PACKAGE "${YCM_VERSION_PACKAGE}.${YCM_VERSION_REVISION}")
endif()

message(STATUS "YCM Version: ${YCM_VERSION} (${YCM_VERSION_PACKAGE})")
