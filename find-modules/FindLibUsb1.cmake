#.rst:
# FindLibUsb1
# -----------
#
# Try to find the libusb library.
# Once done this will define the following variables::
#
#  LibUsb1_FOUND         - System has LibUsb1
#  LibUsb1_INCLUDE_DIRS  - LibUsb1 include directory
#  LibUsb1_LIBRARIES     - LibUsb1 libraries
#  LibUsb1_DEFINITIONS   - Additional compiler flags for LibUsb1
#  LibUsb1_VERSION       - LibUsb1 version
#  LibUsb1_MAJOR_VERSION - LibUsb1 major version
#  LibUsb1_MINOR_VERSION - LibUsb1 minor version
#  LibUsb1_PATCH_VERSION - LibUsb1 patch version

#=============================================================================
# Copyright 2012-2014 iCub Facility, Istituto Italiano di Tecnologia
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


include(StandardFindModule)
standard_find_module(LibUsb1 libusb-1.0 SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(LibUsb1 PROPERTIES DESCRIPTION "Userspace USB programming library"
                                              URL "http://libusb.org/")
endif()
