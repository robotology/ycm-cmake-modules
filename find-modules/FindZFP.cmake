# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause


#[=======================================================================[.rst:
FindZFP
-------

Find the ZFP floating point compression library.

Once done this will define the following variables::

  ZFP_INCLUDE_DIRS    - ZFP include directory
  ZFP_LIBRARIES       - ZFP libraries
  ZFP_FOUND           - if false, you cannot build anything that requires ZFP
  ZFP_VERSION         - ZFP version
  ZFP_MAJOR_VERSION   - ZFP major version
  ZFP_MINOR_VERSION   - ZFP minor version
  ZFP_PATCH_VERSION   - ZFP release version
#]=======================================================================]

include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

find_path(ZFP_INCLUDE_DIR
          NAMES zfp.h
          PATHS $ENV{ZFP_ROOT}/inc
                $ENV{ZFP_ROOT}/include
          DOC "ZFP include directory")
find_library(ZFP_LIBRARY_RELEASE
             NAMES ZFP zfp
             PATHS $ENV{ZFP_ROOT}/lib
             DOC "ZFP library file (release version)")
find_library(ZFP_LIBRARY_DEBUG
             NAMES ZFPd zfpd
             PATHS $ENV{ZFP_ROOT}/lib
             DOC "ZFP library file (debug version)")

mark_as_advanced(ZFP_INCLUDE_DIR
                 ZFP_LIBRARY_RELEASE
                 ZFP_LIBRARY_DEBUG)

select_library_configurations(ZFP)

if(EXISTS "${ZFP_INCLUDE_DIR}/zfp.h")
  file(STRINGS "${ZFP_INCLUDE_DIR}/zfp.h" _contents REGEX "#define ZFP_VERSION_+")
  if(_contents)
    string(REGEX REPLACE ".*#define ZFP_VERSION_MAJOR[ \t]+([0-9]+).*" "\\1" ZFP_MAJOR_VERSION "${_contents}")
    string(REGEX REPLACE ".*#define ZFP_VERSION_MINOR[ \t]+([0-9]+).*" "\\1" ZFP_MINOR_VERSION "${_contents}")
    string(REGEX REPLACE ".*#define ZFP_VERSION_RELEASE[ \t]+([0-9]+).*" "\\1" ZFP_PATCH_VERSION "${_contents}")
    set(ZFP_VERSION "${ZFP_MAJOR_VERSION}.${ZFP_MINOR_VERSION}.${ZFP_PATCH_VERSION}")
  endif()
endif()

set(ZFP_LIBRARIES ${ZFP_LIBRARY})
set(ZFP_INCLUDE_DIRS ${ZFP_INCLUDE_DIR})

find_package_handle_standard_args(ZFP
                                  FOUND_VAR ZFP_FOUND
                                  REQUIRED_VARS ZFP_LIBRARIES ZFP_INCLUDE_DIRS
                                  VERSION_VAR ZFP_VERSION)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(ZFP PROPERTIES DESCRIPTION "An open source C/C++ library for compressed floating-point arrays"
                                          URL "http://computation.llnl.gov/projects/floating-point-compression")
endif()

