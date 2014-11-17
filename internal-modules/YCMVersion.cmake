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


include(GitInfo)


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

# Get information from the git repository if available
git_wt_info(SOURCE_DIR "${YCM_SOURCE_DIR}"
            PREFIX YCM)

unset(YCM_VERSION_SOURCE)
unset(YCM_VERSION_DIRTY)
unset(YCM_VERSION_REVISION)
if(DEFINED YCM_GIT_WT_HASH)
  if(NOT "${YCM_GIT_WT_TAG}" STREQUAL "v${YCM_VERSION}")
    string(REPLACE "-" "" _date ${YCM_GIT_WT_AUTHOR_DATE})
    set(YCM_VERSION_SOURCE "${_date}.${YCM_GIT_WT_DATE_REVISION}+git${YCM_GIT_WT_HASH_SHORT}")
    set(YCM_VERSION_REVISION ${YCM_GIT_WT_TAG_REVISION})
  endif()
  if(YCM_GIT_WT_DIRTY)
    set(YCM_VERSION_DIRTY "dirty")
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
