# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2010 RobotCub Consortium
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindOpenGL
----------

Wrap kitware's original FindOpenGL. Standardize variables.

In windows require you set ``OpenGL_DIR``

Set::

 OpenGL_FOUND
 OpenGL_LIBRARIES
 OpenGL_INCLUDE_DIRS

.. todo:: Check if this module is still needed with recent CMake releases.
#]=======================================================================]

# Save current CMAKE_MODULE_PATH, disable it 
# to avoid recursive calls to FindGLUT
set(_CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH "")

set(OpenGL_DIR $ENV{OpenGL_DIR})

if(OpenGL_DIR)
  message(${OpenGL_DIR})
endif(OpenGL_DIR)

find_package(OpenGL)

if(OPENGL_FOUND)
  set(OpenGL_FOUND TRUE)
  set(OpenGL_INCLUDE_DIRS ${OPENGL_INCLUDE_DIR})
  set(OpenGL_LIBRARIES ${OPENGL_LIBRARIES})
endif(OPENGL_FOUND)

# Push back original CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH ${_CMAKE_MODULE_PATH})
