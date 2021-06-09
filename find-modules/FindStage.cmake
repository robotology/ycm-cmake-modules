# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindStage
---------

Try to find Stage, a library for easy editing of command lines.
Once done this will define the following variables::

 Stage_FOUND         - System has Stage
 Stage_INCLUDE_DIRS  - Stage include directory
 Stage_LIBRARIES     - Stage libraries
 Stage_DEFINITIONS   - Additional compiler flags for Stage
 Stage_VERSION       - Stage version
 Stage_MAJOR_VERSION - Stage major version
 Stage_MINOR_VERSION - Stage minor version
#]=======================================================================]


include(StandardFindModule)
standard_find_module(Stage stage SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(Stage PROPERTIES DESCRIPTION "Mobile robot simulator"
                                            URL "https://rtv.github.io/Stage/")
endif()
