# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindLibv4l2
-----------

Try to find the libv4l2 library.
Once done this will define the following variables::

 Libv4l2_FOUND         - System has libv4l2
 Libv4l2_INCLUDE_DIRS  - libv4l2 include directory
 Libv4l2_LIBRARIES     - libv4l2 libraries
 Libv4l2_DEFINITIONS   - Additional compiler flags for libv4l2
 Libv4l2_VERSION       - libv4l2 version
 Libv4l2_MAJOR_VERSION - libv4l2 major version
 Libv4l2_MINOR_VERSION - libv4l2 minor version
 Libv4l2_PATCH_VERSION - libv4l2 patch version
 Libv4l2_TWEAK_VERSION - libv4l2 tweak version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(Libv4l2 libv4l2)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Libv4l2 PROPERTIES DESCRIPTION "Video4Linux or V4L is a video capture and output device API and driver framework for the Linux kernel, supporting many USB webcams, TV tuners, and other devices."
                                              URL "https://www.kernel.org/doc/Documentation/video4linux/v4l2-framework.txt")
endif()
