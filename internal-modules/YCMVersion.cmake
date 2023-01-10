# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module should not be used outside YCM.

#[=======================================================================[.rst:
YCMVersion
----------

This module should not be used outside YCM.

Variables defined by this module::

 YCM_VERSION          - Full version, including git commit and dirty state.
 YCM_VERSION_MAJOR    - YCM major version
 YCM_VERSION_MINOR    - YCM minor version
 YCM_VERSION_PATCH    - YCM patch version
 YCM_VERSION_REVISION - Number of commits since latest release (git only)
 YCM_VERSION_DATE     - Date of the latest commit (git only)
 YCM_VERSION_DATE_REVISION - Number of commits since of beginning of the day
                        of the latest commit (git only)
 YCM_VERSION_API      - YCM API version
 YCM_VERSION_SHORT    - YCM clean version (Not unique, includes the number
                        of commits since latest tag).
 YCM_VERSION_SOURCE   - YCM source version (includes commit date and hash
                        information) (git only)
 YCM_VERSION_DIRTY    - "dirty" if the source tree is contains uncommitted
                        changes, empty otherwise (git only)
#]=======================================================================]

include(GitInfo)

set(YCM_VERSION_MAJOR 0)
set(YCM_VERSION_MINOR 15)
set(YCM_VERSION_PATCH 1)

set(YCM_VERSION_API "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}")
set(YCM_VERSION_SHORT "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_PATCH}")
set(YCM_VERSION "${YCM_VERSION_SHORT}")

unset(YCM_VERSION_SOURCE)
unset(YCM_VERSION_DIRTY)
unset(YCM_VERSION_REVISION)
unset(YCM_VERSION_DATE)
unset(YCM_VERSION_DATE_REVISION)

# Get information from the git repository if available
git_wt_info(SOURCE_DIR "${YCM_SOURCE_DIR}"
            PREFIX YCM)

if(DEFINED YCM_GIT_WT_HASH)
  # This is a git repository and we have every information that we need
  if(YCM_GIT_WT_TAG_REVISION GREATER 0)
    # This is not the same commit as the latest tag.
    # Include commit information in the version number.
    set(YCM_VERSION_REVISION ${YCM_GIT_WT_TAG_REVISION})
    set(YCM_VERSION_DATE ${YCM_GIT_WT_AUTHOR_DATE})
    set(YCM_VERSION_DATE_REVISION ${YCM_GIT_WT_DATE_REVISION})
    string(REPLACE "-" "" _date ${YCM_GIT_WT_AUTHOR_DATE})
    if(YCM_GIT_WT_DATE_REVISION GREATER 1)
      string(APPEND _date ".${YCM_GIT_WT_DATE_REVISION}")
    endif()
    if("${YCM_VERSION_PATCH}" STREQUAL "dev")
      # This is the devel branch
      set(YCM_VERSION_PATCH "${_date}")
      set(YCM_VERSION_SHORT "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_PATCH}")
    elseif(NOT "${YCM_GIT_WT_TAG}" STREQUAL "v${YCM_VERSION_SHORT}")
      # Probably some work in progress...
      # Add some random information.
      string(TIMESTAMP _ts "%Y%m%d")
      string(APPEND YCM_VERSION_SHORT "~${_ts}")
    else()
      string(APPEND YCM_VERSION_SHORT ".${YCM_VERSION_REVISION}")
    endif()
    set(YCM_VERSION_SOURCE "${_date}+git${YCM_GIT_WT_HASH_SHORT}")
    set(YCM_VERSION "${YCM_VERSION_SHORT}-${YCM_VERSION_SOURCE}")
  elseif(NOT "${YCM_GIT_WT_TAG}" STREQUAL "v${YCM_VERSION_SHORT}")
    # This is the same commit as the latest tag, but the version different
    # Probably some work in progress...
    # Add some random information.
    string(TIMESTAMP _ts "%Y%m%d")
    string(APPEND YCM_VERSION_SHORT "~${_ts}")
    set(YCM_VERSION "${YCM_VERSION_SHORT}")
  else()
    # Same commit as latest tag.
    # Nothing to do
  endif()
  # Include information about the "dirty" status.
  if(YCM_GIT_WT_DIRTY)
    set(YCM_VERSION_DIRTY "dirty")
    set(YCM_VERSION "${YCM_VERSION}+${YCM_VERSION_DIRTY}")
  endif()
else()
  # This is not a git repository or git is missing.
  if("${YCM_VERSION_PATCH}" STREQUAL "dev")
    # This is weird, someone is using "dev" outside a repo or without git.
    # Add some random information.
    string(TIMESTAMP YCM_VERSION_PATCH "%Y%m%d")
    set(YCM_VERSION_SHORT "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_PATCH}")
    set(YCM_VERSION "${YCM_VERSION_SHORT}~dev")
  else()
    # We assume that this is a release, there is not much that we can do if it's
    # not.
    # Nothing to do
  endif()
  # We don't have information about the "dirty" status outside a git repo.
endif()

if(YCM_VERSION_DEBUG)
  foreach(_var YCM_VERSION
               YCM_VERSION_SHORT
               YCM_VERSION_MAJOR
               YCM_VERSION_MINOR
               YCM_VERSION_PATCH
               YCM_VERSION_REVISION
               YCM_VERSION_DATE
               YCM_VERSION_DATE_REVISION
               YCM_VERSION_API
               YCM_VERSION_SOURCE
               YCM_VERSION_DIRTY)
    message(STATUS "${_var}: ${${_var}}")
  endforeach()
endif()

message(STATUS "YCM Version: ${YCM_VERSION} (${YCM_VERSION_SHORT})")
