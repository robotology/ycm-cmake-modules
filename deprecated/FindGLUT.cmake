# SPDX-FileCopyrightText: 2010 RobotCub Consortium
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindGLUT
--------

Wrap kitware's original ``FindGLUT`` script to work on windows with
binary distribution. Standardize variables.

In windows require you set ``GLUT_DIR``

Set::

 GLUT_FOUND
 GLUT_LIBRARIES
 GLUT_INCLUDE_DIRS

.. todo:: Check if this module is still needed with recent CMake releases.
#]=======================================================================]


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



