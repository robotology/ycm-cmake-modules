# - Extracts version numbers from a version string
#
# MACRO_EXTRACT_VERSION(<name> [REVERSE_NAME])
# Tries to extract the following variables (the second version is used if
# REVERSE_NAME is set as argument)
#
#  <name>_MAJOR_VERSION or <name>_VERSION_MAJOR - <name> major version
#  <name>_MINOR_VERSION or <name>_VERSION_MINOR - <name> minor version
#  <name>_PATCH_VERSION or <name>_VERSION_PATCH - <name> patch version
#  <name>_TWEAK_VERSION or <name>_VERSION_TWEAK - <name> tweak version
#  <name>_VERSION_COUNT - number of version components, 0 to 4

# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Author: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

macro(MACRO_EXTRACT_VERSION _name)
    if("x${ARG2}" STREQUAL "xREVERSE_NAME")
        set(_reverse 1)
    endif()

    if(${_name}_VERSION)
        string(REPLACE "." ";" X_${_name}_VERSION_LIST ${${_name}_VERSION})
        list(LENGTH X_${_name}_VERSION_LIST X_${_name}_VERSION_SIZE)
        if (X_${_name}_VERSION_SIZE GREATER 0)
            if(NOT _reverse)
                list(GET X_${_name}_VERSION_LIST 0 ${_name}_MAJOR_VERSION)
            else()
                list(GET X_${_name}_VERSION_LIST 0 ${_name}_VERSION_MAJOR)
            endif()
        endif()
        if (X_${_name}_VERSION_SIZE GREATER 1)
            if(NOT _reverse)
                list(GET X_${_name}_VERSION_LIST 1 ${_name}_MINOR_VERSION)
            else()
                list(GET X_${_name}_VERSION_LIST 1 ${_name}_VERSION_MINOR)
            endif()
        endif()
        if (X_${_name}_VERSION_SIZE GREATER 2)
            if(NOT _reverse)
                list(GET X_${_name}_VERSION_LIST 2 ${_name}_PATCH_VERSION)
            else()
                list(GET X_${_name}_VERSION_LIST 2 ${_name}_VERSION_PATCH)
            endif()
        endif()
        if (X_${_name}_VERSION_SIZE GREATER 3)
            if(NOT _reverse)
                list(GET X_${_name}_VERSION_LIST 3 ${_name}_TWEAK_VERSION)
            else()
                list(GET X_${_name}_VERSION_LIST 3 ${_name}_VERSION_TWEAK)
            endif()
        endif()

        if(${X_${_name}_VERSION_SIZE} GREATER 4)
            set(${_name}_VERSION_COUNT 4)
        else()
            set(${_name}_VERSION_COUNT ${X_${_name}_VERSION_SIZE})
        endif()
    else()
        set(${_name}_VERSION_COUNT 0)
    endif()
endmacro()
