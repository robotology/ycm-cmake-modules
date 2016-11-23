#.rst:
# YCMVersion
# ----------
#
# This module should not be used outside YCM.
#
# Variables defined by this module::
#
#  YCM_VERSION          - Full version, including git commit and dirty state.
#  YCM_VERSION_MAJOR    - YCM major version
#  YCM_VERSION_MINOR    - YCM minor version
#  YCM_VERSION_PATCH    - YCM patch version
#  YCM_VERSION_REVISION - Number of commits since latest release
#  YCM_VERSION_API      - YCM API version
#  YCM_VERSION_SHORT    - YCM clean version (Not unique, includes the number
#                         of commits since latest tag).
#  YCM_VERSION_SOURCE   - YCM source version (includes commit date and hash
#                         information)
#  YCM_VERSION_DIRTY    - "dirty" if the source tree is contains uncommitted
#                         changes, empry otherwise

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

include(GitInfo)

set(YCM_VERSION_MAJOR 0)
set(YCM_VERSION_MINOR 3)
set(YCM_VERSION_PATCH 0)


set(YCM_VERSION_API "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}")
set(YCM_VERSION_SHORT "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_PATCH}")

# Get information from the git repository if available
git_wt_info(SOURCE_DIR "${YCM_SOURCE_DIR}"
            PREFIX YCM)

unset(YCM_VERSION_SOURCE)
unset(YCM_VERSION_DIRTY)
unset(YCM_VERSION_REVISION)
if(DEFINED YCM_GIT_WT_HASH)
  if(YCM_GIT_WT_TAG_REVISION GREATER 0)
    set(YCM_VERSION_REVISION ${YCM_GIT_WT_TAG_REVISION})
    string(REPLACE "-" "" _date ${YCM_GIT_WT_AUTHOR_DATE})
    set(YCM_VERSION_SOURCE "${_date}.${YCM_GIT_WT_DATE_REVISION}+git${YCM_GIT_WT_HASH_SHORT}")
  endif()
  if(YCM_GIT_WT_DIRTY)
    set(YCM_VERSION_DIRTY "dirty")
  endif()
endif()

if(DEFINED YCM_VERSION_SOURCE)
  if(NOT "${YCM_GIT_WT_TAG}" STREQUAL "v${YCM_VERSION_SHORT}")
    set(YCM_VERSION "${YCM_VERSION_SHORT}.${YCM_VERSION_SOURCE}")
  else()
    set(YCM_VERSION "${YCM_VERSION_SHORT}.${YCM_VERSION_REVISION}-${YCM_VERSION_SOURCE}")
  endif()
  set(YCM_VERSION_SHORT "${YCM_VERSION_SHORT}.${YCM_VERSION_REVISION}")
elseif(NOT "${YCM_GIT_WT_TAG}" STREQUAL "v${YCM_VERSION_SHORT}")
  set(YCM_VERSION "${YCM_VERSION_SHORT}~dev")
else()
  set(YCM_VERSION "${YCM_VERSION_SHORT}")
endif()
if(DEFINED YCM_VERSION_DIRTY)
  set(YCM_VERSION "${YCM_VERSION}+${YCM_VERSION_DIRTY}")
endif()

message(STATUS "YCM Version: ${YCM_VERSION} (${YCM_VERSION_SHORT})")
