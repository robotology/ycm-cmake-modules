#=============================================================================
# Copyright 2013-2019 Istituto Italiano di Tecnologia (IIT)
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


##############################################################################
# FindFFMPEG.cmake is taken from the VTK repository

set(_files Copyright.txt                       73e1eb91dcdfcedf106ced4e67bc691614f0a3b3
           CMake/FindFFMPEG.cmake              08ef5c25b33a4ee3cd4d65027412d2ef60c46281)
set(_ref v9.0.1)
set(_dir "${CMAKE_CURRENT_BINARY_DIR}/vtk")

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

_ycm_install(3rdparty-vtk FILES "${_dir}/CMake/FindFFMPEG.cmake"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-vtk FILES "${_dir}/Copyright.txt"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                          RENAME COPYING.VTK)

_ycm_install(3rdparty-vtk FILES "${_dir}/README.VTK"
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
