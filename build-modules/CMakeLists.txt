# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

set(YCM_BUILD_MODULES BuildECM.cmake
                      BuildGooCanvas.cmake
                      BuildGooCanvasMM.cmake
                      BuildGtkDatabox.cmake
                      BuildGtkDataboxMM.cmake
                      BuildTinyXML.cmake
                      BuildYARP.cmake
                      BuildICUB.cmake
                      BuildGazeboYARPPlugins.cmake
                      BuildEigen3.cmake
                      BuildqpOASES.cmake)

_ycm_install(build-modules FILES ${YCM_BUILD_MODULES}
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/build-modules")

# Print a warning if we are overriding some module from CMake
foreach(_module IN LISTS YCM_BUILD_MODULES)
  if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
    message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
  endif()
endforeach()
