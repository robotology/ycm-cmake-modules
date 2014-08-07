#=============================================================================
# Copyright 2013-2014 iCub Facility, Istituto Italiano di Tecnologia
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


option(YCM_NO_DEPRECATED "Disable deprecated modules." FALSE)
mark_as_advanced(YARP_NO_DEPRECATED)

# Deprecated modules installed for compatibility
if(NOT YCM_NO_DEPRECATED)
    set(YCM_DEPRECATED_FILES YCMDeprecatedWarning.cmake
                             FindGthread.cmake
                             FindGtkMM.cmake
                             FindGtkMMUnix.cmake
                             FindGtkMMWin32.cmake
                             FindGtkPlus.cmake
                             FindGtkWin32.cmake)
    _ycm_install(deprecated FILES ${YCM_DEPRECATED_FILES}
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/deprecated")
endif()
