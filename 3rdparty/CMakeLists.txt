#=============================================================================
# Copyright 2013-2018 Istituto Italiano di Tecnologia (IIT)
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


option(YCM_NO_3RDPARTY "Disable 3rd party modules." FALSE)
mark_as_advanced(YCM_NO_3RDPARTY)

# Useful 3rd party modules
if(NOT YCM_NO_3RDPARTY OR YCM_MAINTAINER_MODE)

  include("${CMAKE_CURRENT_LIST_DIR}/eigen3.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/ovito.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/qt-gstreamer.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmake-wiki.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/catch2.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/vtk.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/qgv.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmrc.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/uselatex.cmake")

  # Print a warning if we are overriding some module from CMake
  file(GLOB_RECURSE _modules
       RELATIVE "${CMAKE_BINARY_DIR}/${YCM_INSTALL_MODULE_DIR}/3rdparty"
       "${CMAKE_BINARY_DIR}/${YCM_INSTALL_MODULE_DIR}/3rdparty/*.cmake")
  foreach(_module IN LISTS _modules)
    if(EXISTS ${CMAKE_ROOT}/Modules/${_module})
      message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT")
    endif()
  endforeach()

endif()
