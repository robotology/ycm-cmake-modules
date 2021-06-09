# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindFuse
----------------

Try to find the Fuse library.
Once done this will define the following variables::

 Fuse_FOUND         - System has Fuse
 Fuse_INCLUDE_DIRS  - Fuse include directory
 Fuse_LIBRARIES     - Fuse libraries
 Fuse_DEFINITIONS   - Additional compiler flags for Fuse
 Fuse_VERSION       - Fuse version
 Fuse_MAJOR_VERSION - Fuse major version
 Fuse_MINOR_VERSION - Fuse minor version
 Fuse_PATCH_VERSION - Fuse patch version
 Fuse_TWEAK_VERSION - Fuse tweak version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(Fuse fuse)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Fuse PROPERTIES DESCRIPTION "A simple interface for userspace programs to export a virtual filesystem to the Linux kernel"
                                           URL "http://fuse.sourceforge.net/")
endif()
