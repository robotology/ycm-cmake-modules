# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindFreenect
------------

Try to find the Freenect library.
Once done this will define the following variables::

 Freenect_FOUND         - System has Freenect
 Freenect_INCLUDE_DIRS  - Freenect include directory
 Freenect_LIBRARIES     - Freenect libraries
 Freenect_DEFINITIONS   - Additional compiler flags for Freenect
 Freenect_VERSION       - Freenect version
 Freenect_MAJOR_VERSION - Freenect major version
 Freenect_MINOR_VERSION - Freenect minor version
 Freenect_PATCH_VERSION - Freenect patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(Freenect libfreenect SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Freenect PROPERTIES DESCRIPTION "Userspace driver for the Microsoft Kinect"
                                               URL "http://openkinect.org/wiki/Main_Page")
endif()
