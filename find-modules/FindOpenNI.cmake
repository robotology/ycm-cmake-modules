# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindOpenNI
----------

Try to find the OpenNI library.
Once done this will define the following variables::

 OpenNI_FOUND         - System has OpenNI
 OpenNI_INCLUDE_DIRS  - OpenNI include directory
 OpenNI_LIBRARIES     - OpenNI libraries
 OpenNI_DEFINITIONS   - Additional compiler flags for OpenNI
 OpenNI_VERSION       - OpenNI version
 OpenNI_MAJOR_VERSION - OpenNI major version
 OpenNI_MINOR_VERSION - OpenNI minor version
 OpenNI_PATCH_VERSION - OpenNI patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(OpenNI libopenni SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(OpenNI PROPERTIES DESCRIPTION "Open Natural Interaction framework"
                                             URL "https://github.com/OpenNI/OpenNI")
endif()
