#=============================================================================
# Copyright 2013-2014 Istituto Italiano di Tecnologia (IIT)
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

  ##############################################################################
  # FindEigen3.cmake is taken from the Eigen3 repository.
  # It is no longer necessary since Eigen 3.3.1

  set(_files COPYING.BSD             8fa159b3e41e0a44e10ea224cbb83e66ae02885e
             cmake/FindEigen3.cmake  5ad2b8e1ddbd9f0468b21e9d5343d05eda6b9dd1)
  set(_ref 844c47cfd8d309fe4db5cc21dd7368759d0a7a00)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/eigen3")

  _ycm_download(3rdparty-eigen
                "Eigen mercurial repository"
                "https://bitbucket.org/eigen/eigen/raw/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")
  file(WRITE "${_dir}/README.Eigen"
"Some of the files in this folder and its subfolder come from the Eigen mercurial
repository (ref ${_ref}):

  https://bitbucket.org/eigen/eigen

Redistribution and use is allowed according to the terms of the 2-clause
BSD license. See accompanying file COPYING.Eigen for details.
")

  _ycm_install(3rdparty-eigen FILES "${_dir}/cmake/FindEigen3.cmake"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-eigen FILES "${_dir}/COPYING.BSD"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                              RENAME COPYING.Eigen)

  _ycm_install(3rdparty-eigen FILES "${_dir}/README.Eigen"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  ##############################################################################
  # FindQCustomPlot.cmake is installed automatically by libqcustomplot-dev on
  # some old Debian and Ubuntu releases (replaced by QCustomPlotConfig.cmake on
  # newer releases). Anyway it does not define QCustomPlot_INCLUDE_DIRS,
  # therefore it is always imported.

  set(_files LICENSE.txt                 8624bcdae55baeef00cd11d5dfcfa60f68710a02
             cmake/FindQCustomPlot.cmake a59dd4d955a5e775270a4f2656a039ae490e03ed)
  set(_ref 8689fcb1fdd2e8dc748e76d54d3b77a3f87d384c)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/ovito")

  _ycm_download(3rdparty-ovito
                "OVITO (The Open Visualization Tool) git repository"
                "https://gitlab.com/stuko/ovito/raw/<REF>/<FILE>"
                  ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.OVITO"
"Some of the files in this folder and its subfolder come from the OVITO git
repository (ref ${_ref}):

  https://sourceforge.net/projects/ovito/

Redistribution and use is allowed according to the terms of the GPL3 license.
See accompanying file COPYING.OVITO for details.
")

  _ycm_install(3rdparty-ovito FILES "${_dir}/cmake/FindQCustomPlot.cmake"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-ovito FILES "${_dir}/LICENSE.txt"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                              RENAME COPYING.OVITO)

  _ycm_install(3rdparty-ovito FILES "${_dir}/README.OVITO"
                              DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  ##############################################################################
  # FindGStreamer.cmake and FindGStreamerPluginsBase.cmake and their
  # dependencies are taken from the qt-gstreamer repository

  set(_files cmake/modules/COPYING-CMAKE-SCRIPTS           ff3ed70db4739b3c6747c7f624fe2bad70802987
             cmake/modules/FindGLIB2.cmake                 df497ba5188a8a98cb60d35a096680fd2e3140ce
             cmake/modules/FindGStreamer.cmake             21bc9cbec706b467fbc748dc7817e57648952dd1
             cmake/modules/FindGStreamerPluginsBase.cmake  75d8fbd4e20afdd624e538d935f3ebabb10c2778
             cmake/modules/MacroFindGStreamerLibrary.cmake 0b9cca5a62c8d4ccec99e875a36d1531e5a899a1)
  set(_ref a0e95b202a72b6d9e48bd1949ab6811c0f3c91c3)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/qt-gstreamer")
  _ycm_download(3rdparty-qt-gstreamer
                "qt-gstreamer git repository"
                "https://raw.githubusercontent.com/GStreamer/qt-gstreamer/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.qt-gstreamer"
"Some of the files in this folder and its subfolder come from the qt-gstreamer
git repository (ref ${_ref}):

  https://github.com/GStreamer/qt-gstreamer

Redistribution and use is allowed according to the terms of the 3-clause
BSD license. See accompanying file COPYING.qt-gstreamer for details.
")

  _ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/cmake/modules/FindGLIB2.cmake"
                                           "${_dir}/cmake/modules/FindGStreamer.cmake"
                                           "${_dir}/cmake/modules/FindGStreamerPluginsBase.cmake"
                                           "${_dir}/cmake/modules/MacroFindGStreamerLibrary.cmake"
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/cmake/modules/COPYING-CMAKE-SCRIPTS"
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                                     RENAME COPYING.qt-gstreamer)

  _ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/README.qt-gstreamer"
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  ##############################################################################
  # FindOctave.cmake is taken from CMake wiki:
  # https://cmake.org/Wiki/CMakeUserFindOctave

  _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/FindOctave.cmake
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/COPYING.CMake-wiki
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/README.CMake-wiki
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  # Catch2 contrib modules
  set(_files contrib/Catch.cmake                 6f80938187f2fe004db163481ad7b468c6f22ea4
             contrib/CatchAddTests.cmake         66d163633c3e1e051885f7b0a458e6dddb42c0cc
             contrib/ParseAndAddCatchTests.cmake 7dc1d1eeb6351dfedec5a34bb55920ba516f0d3f
             LICENSE.txt                         3cba29011be2b9d59f6204d6fa0a386b1b2dbd90)
  set(_ref 76790604f523f7fb63741aca5fc7fc1cbc140763)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/catch2")

  _ycm_download(3rdparty-catch2
                "Catch2 (C++ Automated Test Cases in a Header) git repository"
                "https://raw.githubusercontent.com/catchorg/Catch2/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.Catch2"
"Some of the files in this folder and its subfolder come from the Catch2 git
repository (ref ${_ref}):

  https://github.com/catchorg/Catch2/

Redistribution and use is allowed according to the terms of the Boost Software
License. See accompanying file COPYING.Catch2 for details.
")


  ##############################################################################
  # Catch2 related modules are taken from the Catch2 repository.

  _ycm_install(3rdparty-catch2 FILES "${_dir}/contrib/Catch.cmake"
                                     "${_dir}/contrib/CatchAddTests.cmake"
                                     "${_dir}/contrib/ParseAndAddCatchTests.cmake"
                               DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-catch2 FILES "${_dir}/LICENSE.txt"
                               DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                               RENAME COPYING.Catch2)

  _ycm_install(3rdparty-catch2 FILES "${_dir}/README.Catch2"
                               DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  ##############################################################################
  # FindFFMPEG.cmake is taken from the VTK repository

  set(_files Copyright.txt                       73e1eb91dcdfcedf106ced4e67bc691614f0a3b3
             CMake/FindFFMPEG.cmake              7a979800a51b0fd7af24be3ee88ea37309294695)
  set(_ref v8.1.1)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/vtk")

  _ycm_download(3rdparty-vtk
                "VTK (Visualization Toolkit) git repository"
                "https://gitlab.kitware.com/vtk/vtk/raw/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.VTK"
"Some of the files in this folder and its subfolder come from the VTK git
repository (ref ${_ref}):

  https://gitlab.kitware.com/vtk/vtk/

Redistribution and use is allowed according to the terms of the Boost Software
License. See accompanying file COPYING.Catch2 for details.
")

  _ycm_install(3rdparty-vtk FILES "${_dir}/CMake/FindFFMPEG.cmake"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-vtk FILES "${_dir}/Copyright.txt"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                            RENAME COPYING.VTK)

  _ycm_install(3rdparty-vtk FILES "${_dir}/README.VTK"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")


  ##############################################################################
  # FindGraphviz.cmake is taken from the qgv repository

  set(_files LICENSE.txt                       f45ee1c765646813b442ca58de72e20a64a7ddba
             cmake/modules/FindGraphviz.cmake  7da6123d62e38221440abdded30e40d5d732f49d)
  set(_ref 85a43982f69d541044c8bfa08c87cb0c6108be9c)
  set(_dir "${CMAKE_CURRENT_BINARY_DIR}/qgv")

  _ycm_download(3rdparty-qgv
                "qgv (Interactive Qt graphViz display) git repository"
                "https://raw.githubusercontent.com/nbergont/qgv/<REF>/<FILE>"
                ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.qgv"
"Some of the files in this folder and its subfolder come from the qgv git
repository (ref ${_ref}):

  https://github.com/nbergont/qgv/

Redistribution and use is allowed according to the terms of the Boost Software
License. See accompanying file COPYING.qgv for details.
")

  _ycm_install(3rdparty-qgv FILES "${_dir}/cmake/modules/FindGraphviz.cmake"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

  _ycm_install(3rdparty-qgv FILES "${_dir}/LICENSE.txt"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                            RENAME COPYING.qgv)

  _ycm_install(3rdparty-qgv FILES "${_dir}/README.qgv"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

endif()
