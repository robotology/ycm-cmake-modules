# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2009 Benoit Rat
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindOpenCV
----------

Find OpenCV - variables set::

 OpenCV_FOUND
 OpenCV_LIBS
 OpenCV_INCLUDE_DIRS

This script is a combination from multiple sources that use
different variable names; the names are reconciled at the end
of the script.

 OpenCV_LIBRARIES is defined, but its use is deprecated. Please use OpenCV_LIBS.

.. todo:: Check if this module is still needed with recent CMake releases.
.. todo:: Check if the license is correct
#]=======================================================================]

###########################################################
#                  Find OpenCV Library
# See http://sourceforge.net/projects/opencvlibrary/
#----------------------------------------------------------
#
## 1: Setup:
# The following variables are optionally searched for defaults
#  OpenCV_DIR:            Base directory of OpenCv tree to use.
#
## 2: Variable
# The following are set after configuration is done:
#
#  OpenCV_FOUND
#  OpenCV_LIBS
#  OpenCV_INCLUDE_DIR
#  OpenCV_VERSION (OpenCV_VERSION_MAJOR, OpenCV_VERSION_MINOR, OpenCV_VERSION_PATCH)
#
#
# Deprecated variable are used to maintain backward compatibility with
# the script of Jan Woetzel (2006/09): www.mip.informatik.uni-kiel.de/~jw
#  OpenCV_INCLUDE_DIRS
#  OpenCV_LIBRARIES
#  OpenCV_LINK_DIRECTORIES
#
## 3: Version
#
# 2010/04/07 Benoit Rat, Correct a bug when OpenCVConfig.cmake is not found.
# 2010/03/24 Benoit Rat, Add compatibility for when OpenCVConfig.cmake is not found.
# 2010/03/22 Benoit Rat, Creation of the script.
#
#
# tested with:
# - OpenCV 2.1:  MinGW, MSVC2008
# - OpenCV 2.0:  MinGW, MSVC2008, GCC4
#
#
## 4: Licence:
#
# SPDX-FileCopyrightText: 2009 Benoit Rat
# CopyPolicy: LGPLv2.1
# 
#----------------------------------------------------------

# Lorenzo Natale -- Feb 2011
# Improve compatibility with OpenCV package in Ubuntu 10.10
# Lorenzo Natale -- March 2011
# Removing OpenCV_INCLUDE_DIRS from required arguments
# Since not all version of OpenCV set OpenCV_INCLUDE_DIRS. Problem detected with OpenCV 2.0 OpenCVConfig.cmake
# directly calls INCLUDE_DIRECTORIES() and does not propagate any OpenCV_INCLUDE_ variable

# let's skip module mode, and see if a OpenCVConfig.cmake file is around
# this searches in system directories and ${OpenCV_DIR}

include(FindPackageHandleStandardArgs)

set(_OpenCV_FIND_QUIETLY ${OpenCV_FIND_QUIETLY})
find_package(OpenCV QUIET NO_MODULE)
set(OpenCV_FIND_QUIETLY ${_OpenCV_FIND_QUIETLY})

if(OpenCV_FOUND)
    set(OpenCV_CONFIG_MODE true)
    ## OpenCVConfig.cmake sets OpenCV_LIBS OpenCV_INCLUDE_DIRS
    ## but we need OpenCV_LIBRARIES
    if(NOT DEFINED OpenCV_LIBRARIES)
        set(OpenCV_LIBRARIES ${OpenCV_LIBS})
        if(NOT COMMAND _YCM_FindOpenCV_variable_deprecated)
          function(_YCM_FindOpenCV_variable_deprecated _variable)
            message(DEPRECATION "${_variable} is deprecated, please use ${OpenCV_LIBS} instead.")
          endfunction()
          variable_watch(OpenCV_LIBRARIES _YCM_FindOpenCV_variable_deprecated)
        endif()
    endif()
endif()

find_package_handle_standard_args(OpenCV DEFAULT_MSG OpenCV_CONFIG)

if(COMMAND set_package_properties)
    set_package_properties(OpenCV PROPERTIES DESCRIPTION "Open source computer vision library"
                                             URL "http://opencv.org/")
endif()
