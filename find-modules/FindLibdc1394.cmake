# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindLibdc1394
-------------

Try to find the libdc1394 library.
Once done this will define the following variables::

 Libdc1394_FOUND         - System has libdc1394
 Libdc1394_INCLUDE_DIRS  - libdc1394 include directory
 Libdc1394_LIBRARIES     - libdc1394 libraries
 Libdc1394_DEFINITIONS   - Additional compiler flags for libdc1394
 Libdc1394_VERSION       - libdc1394 version
 Libdc1394_MAJOR_VERSION - libdc1394 major version
 Libdc1394_MINOR_VERSION - libdc1394 minor version
 Libdc1394_PATCH_VERSION - libdc1394 patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(Libdc1394 libdc1394-2)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Libdc1394 PROPERTIES DESCRIPTION "High level programming interface for IEEE1394 digital camera"
                                                URL "http://damien.douxchamps.net/ieee1394/libdc1394/")
endif()
