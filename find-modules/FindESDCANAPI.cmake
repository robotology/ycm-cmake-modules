#.rst:
# FindESDCANAPI
# -------------
#
# Created::
#
#  ESDCANAPI_INC_DIRS   - Directories to include to use esdcan api
#  ESDCANAPI_LIB        - Default library to link against to use the esdcan API
#  ESDCANAPI_FOUND      - If false, don't try to use esdcan API

#=============================================================================
# Copyright 2009 RobotCub Consortium
#   Authors: Alexandre Bernardino <alex@isr.ist.utl.pt>
#            Paul Fitzpatrick <paulfitz@alum.mit.edu>
#            Lorenzo Natale <lorenzo.natale@iit.it>
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


if(NOT ESDCANAPI_FOUND)
    set(ESDCANAPI_DIR $ENV{ESDCANAPI_DIR} CACHE PATH "Path to ESDCANAPI")

    if(WIN32)
        # we look for the lib, give priority to ESDCANAPI_DIR which should point
        # to the correct place, but also look in other locations. CAnSdkDir
        # should be set by the installer.
        find_library(ESDCANAPI_LIB ntcan ${ESDCANAPI_DIR}/develop/vc
                                         ${CanSdkDir}/develop/vc
                                         "C:/Program Files/CAN/develop/vc"
                                         ${ESDCANAPI_DIR}/winnt
                                         NO_DEFAULT_PATH)

        find_path(ESDCANAPI_INC_DIRS ntcan.h ${ESDCANAPI_DIR}/include
                                             ${CanSdkDir}/include
                                             "C:/Program Files/CAN/include")
    else()
       find_library(ESDCANAPI_LIB ntcan ${ESDCANAPI_DIR}/lib32 ${ESDCANAPI_DIR}/lib64)
       set(ESDCANAPI_INC_DIRS ${ESDCANAPI_DIR}/lib32)
    endif()

    if(ESDCANAPI_LIB)
       set(ESDCANAPI_FOUND TRUE)
    else()
       set(ESDCANAPI_FOUND FALSE)
       set(ESDCANAPI_INC_DIRS)
       unset(ESDCANAPI_LIB )
    endif()

endif(NOT ESDCANAPI_FOUND)
