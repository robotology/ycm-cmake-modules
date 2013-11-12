# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

option(YCM_NO_DEPRECATED_WARNINGS "Do not print warnings when using deprecated modules." FALSE)
mark_as_advanced(YARP_NO_DEPRECATED_WARNING)

macro(YCM_DEPRECATED_WARNING)
    if(NOT YCM_NO_DEPRECATED_WARNINGS)
        message(WARNING "${ARGN}")
    endif(NOT YCM_NO_DEPRECATED_WARNINGS)
endmacro()
