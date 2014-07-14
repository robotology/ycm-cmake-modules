# This module should not be used outside YCM.

#=============================================================================
# Copyright 2014 iCub Facility, Istituto Italiano di Tecnologia
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

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Extra CMake Modules for YARP and friends")
set(CPACK_PACKAGE_VENDOR "iCub Facility, Istituto Italiano di Tecnologia")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/Copyright.txt")
set(CPACK_PACKAGE_VERSION_MAJOR ${YCM_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${YCM_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${YCM_PATCH_VERSION})
set(CPACK_PACKAGE_INSTALL_DIRECTORY "YCM ${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}")
set(CPACK_PACKAGE_ICON "${YCM_SOURCE_DIR}/docs/static/ycm-favicon.ico")

include(CPack)
