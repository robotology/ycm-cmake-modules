# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindLibusb1
-----------

Try to find the libusb-1 library.
Once done this will define the following variables::

 Libusb1_FOUND         - System has libusb-1
 Libusb1_INCLUDE_DIRS  - libusb-1 include directory
 Libusb1_LIBRARIES     - libusb-1 libraries
 Libusb1_DEFINITIONS   - Additional compiler flags for libusb-1
 Libusb1_VERSION       - libusb-1 version
 Libusb1_MAJOR_VERSION - libusb-1 major version
 Libusb1_MINOR_VERSION - libusb-1 minor version
 Libusb1_PATCH_VERSION - libusb-1 patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(Libusb1 libusb-1.0 SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Libusb1 PROPERTIES DESCRIPTION "Userspace USB programming library"
                                              URL "http://libusb.org/")
endif()
