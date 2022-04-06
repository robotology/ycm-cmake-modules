# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# FindFFMPEG.cmake is taken from the VTK repository

set(_dir "${CMAKE_CURRENT_SOURCE_DIR}/vtk")

if(YCM_DOWNLOAD_3RDPARTY)
  set(_files Copyright.txt                       73e1eb91dcdfcedf106ced4e67bc691614f0a3b3
             CMake/FindFFMPEG.cmake              08ef5c25b33a4ee3cd4d65027412d2ef60c46281)
  set(_ref v9.0.1)

  _ycm_download(3rdparty-vtk
                "VTK (Visualization Toolkit) git repository"
                "https://gitlab.kitware.com/vtk/vtk/raw/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.VTK"
"Some of the files in this folder and its subfolder come from the VTK git
repository (ref ${_ref}):

  https://gitlab.kitware.com/vtk/vtk/

Redistribution and use is allowed according to the terms of the 3-clause
BSD license. See accompanying file COPYING.VTK for details.
")
endif()

_ycm_install(3rdparty-vtk FILES "${_dir}/CMake/FindFFMPEG.cmake"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-vtk FILES "${_dir}/Copyright.txt"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                          RENAME COPYING.VTK)

_ycm_install(3rdparty-vtk FILES "${_dir}/README.VTK"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
