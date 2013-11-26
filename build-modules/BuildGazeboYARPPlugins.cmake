# GazeboYARPPlugins

include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
# gazebo-config.cmake requires C
if(NOT CMAKE_C_COMPILER_LOADED)
    enable_language(C)
endif()
find_package(gazebo QUIET)

ycm_ep_helper(GazeboYARPPlugins TYPE GIT
                                STYLE GITHUB
                                REPOSITORY robotology/gazebo_yarp_plugins.git
                                TAG master
                                DEPENDS YARP
                                        ICUB
                                INSTALL_COMMAND "")
