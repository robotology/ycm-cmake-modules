# GazeboYARPPlugins

include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_package(gazebo)

ycm_ep_helper(GazeboYARPPlugins TYPE GIT
                                STYLE GITHUB
                                REPOSITORY robotology/gazebo_yarp_plugins.git
                                TAG master
                                DEPENDS YARP
                                        ICUB
                                INSTALL_COMMAND "")
