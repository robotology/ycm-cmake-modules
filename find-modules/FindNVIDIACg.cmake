# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2009 RobotCub Consortium
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindNVIDIACg
------------

Try to find NVIDIACg libraries
#]=======================================================================]

find_library(NVIDIACg_CgGL_LIBRARY CgGL)
find_library(NVIDIACg_pthread_LIBRARY pthread)
find_library(NVIDIACg_GL_LIBRARY GL)
find_library(NVIDIACg_glut_LIBRARY glut)
if(NOT WIN32)
  find_library(NVIDIACg_GLEW_LIBRARY GLEW)
endif()

set(NVIDIACg_LIBRARIES ${NVIDIACg_pthread_LIBRARY}
                       ${NVIDIACg_GL_LIBRARY}
                       ${NVIDIACg_glut_LIBRARY}
                       ${NVIDIACg_CgGL_LIBRARY})
if(NOT WIN32)
  list(APPEND NVIDIACg_LIBRARIES ${NVIDIACg_GLEW_LIBRARY})
endif()

find_path(NVIDIACg_INCLUDE_DIR "Cg/cg.h")
set(NVIDIACg_INCLUDE_DIRS ${NVIDIACg_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NVIDIACg DEFAULT_MSG NVIDIACg_LIBRARIES NVIDIACg_INCLUDE_DIRS)
