# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindOpenNI2
----------

Try to find the OpenNI2 library.
Once done this will define the following variables::

 OpenNI2_FOUND         - System has OpenNI2
 OpenNI2_INCLUDE_DIRS  - OpenNI2 include directory
 OpenNI2_LIBRARIES     - OpenNI2 libraries
 OpenNI2_DEFINITIONS   - Additional compiler flags for OpenNI2
 OpenNI2_VERSION       - OpenNI2 version
 OpenNI2_MAJOR_VERSION - OpenNI2 major version
 OpenNI2_MINOR_VERSION - OpenNI2 minor version
 OpenNI2_PATCH_VERSION - OpenNI2 patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(OpenNI2 libopenni2 SKIP_CMAKE_CONFIG)

if(NOT OpenNI2_FOUND)
  find_path(OpenNI2_INCLUDE_DIR
            NAMES OpenNI.h
            HINTS $ENV{OpenNI2_DIR}/include
                  $ENV{OpenNI2_DIR}/Include)
  find_library(OpenNI2_LIBRARY
               NAMES OpenNI2
                     libOpenNI2
               HINTS $ENV{OpenNI2_DIR}/lib
                     $ENV{OpenNI2_DIR}/Redist
                     $ENV{OpenNI2_DIR}/redist)

  set(OpenNI2_LIBRARIES ${OpenNI2_LIBRARY})
  set(OpenNI2_INCLUDE_DIRS ${OpenNI2_INCLUDE_DIR})

  find_package_handle_standard_args(OpenNI2 DEFAULT_MSG OpenNI2_LIBRARIES OpenNI2_INCLUDE_DIRS)

  set(OpenNI2_FOUND ${OPENNI2_FOUND})
endif()

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(OpenNI2 PROPERTIES DESCRIPTION "Open Natural Interaction framework"
                                              URL "https://github.com/OpenNI/OpenNI2")
endif()
