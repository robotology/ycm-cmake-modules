# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

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
    install(FILES ${YCM_DEPRECATED_FILES}
            DESTINATION share/YCM/deprecated)
endif()
