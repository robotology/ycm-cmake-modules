# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildGazeboYARPPlugins
----------------------

GazeboYARPPlugins
#]=======================================================================]

include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
# gazebo-config.cmake requires C
if(NOT CMAKE_C_COMPILER_LOADED)
    enable_language(C)
endif()
find_package(gazebo QUIET)
find_package(Boost COMPONENTS serialization system QUIET)

ycm_ep_helper(GazeboYARPPlugins TYPE GIT
                                STYLE GITHUB
                                REPOSITORY robotology/gazebo_yarp_plugins.git
                                TAG master
                                DEPENDS YARP
                                        gazebo
                                        Boost)

ycm_ep_helper(gazebo_yarp_plugins.wiki TYPE GIT
                                       STYLE GITHUB
                                       REPOSITORY robotology/gazebo_yarp_plugins.wiki.git
                                       TAG master
                                       COMPONENT documentation
                                       EXCLUDE_FROM_ALL 1)
