#.rst:
# FindGLUT
# --------
#
# Wrap kitware's original ``FindGLUT`` script to work on windows with
# binary distribution. Standardize variables.
#
# In windows require you set ``GLUT_DIR``
#
# Set::
#
#  GLUT_FOUND
#  GLUT_LIBRARIES
#  GLUT_INCLUDE_DIRS
#
# .. todo:: Check if this module is still needed with recent CMake releases.


#=============================================================================
# Copyright 2010 RobotCub Consortium
#   Authors: Lorenzo Natale <lorenzo.natale@iit.it>
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

include(${CMAKE_ROOT}/Modules/FindGLUT.cmake)

if(NOT COMMAND _YCM_FIND_GLUT_DEPRECATED_VARIABLE_WARNING)
  # A macro to print a warning when using deprecated variables, called by
  # variable_watch
  macro(_YCM_FIND_GLUT_DEPRECATED_VARIABLE_WARNING _variable)
    message(DEPRECATION "The ${_variable} variable is deprecated. Use 'GLUT::GLUT' target instead.")
  endmacro()

  set(GLUT_INCLUDE_DIRS ${GLUT_INCLUDE_DIR})
  variable_watch(GLUT_INCLUDE_DIRS _ycm_find_glut_deprecated_variable_warning)
endif()



