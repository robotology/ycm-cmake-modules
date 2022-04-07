# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

option(YCM_NO_3RDPARTY "Disable 3rd party modules." FALSE)
mark_as_advanced(YCM_NO_3RDPARTY)

option(YCM_DOWNLOAD_3RDPARTY "Download 3rd party modules instead of relying local copies." FALSE)
mark_as_advanced(YCM_DOWNLOAD_3RDPARTY)

# Useful 3rd party modules
if(NOT YCM_NO_3RDPARTY OR YCM_MAINTAINER_MODE)

  include("${CMAKE_CURRENT_LIST_DIR}/ovito.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/qt-gstreamer.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmake-wiki.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/catch2.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/vtk.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/qgv.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/cmrc.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/uselatex.cmake")
  include("${CMAKE_CURRENT_LIST_DIR}/ecm.cmake")

  # Print a warning if we are overriding some module from CMake
  file(GLOB_RECURSE _modules
       RELATIVE "${YCM_BINARY_DIR}/${YCM_INSTALL_MODULE_DIR}/3rdparty"
       "${YCM_BINARY_DIR}/${YCM_INSTALL_MODULE_DIR}/3rdparty/*.cmake")
  foreach(_module IN LISTS _modules)
    if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
      message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT")
    endif()
  endforeach()

endif()
