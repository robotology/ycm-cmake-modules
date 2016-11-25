#=============================================================================
# Copyright 2013-2014 iCub Facility, Istituto Italiano di Tecnologia
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
    # FindEigen3.cmake is installed automatically by libeigen3-dev on some
    # Debian and Ubuntu releases
    if(NOT EXISTS "${CMAKE_ROOT}/FindEigen3.cmake" OR YCM_MAINTAINER_MODE)
        set(_files COPYING.BSD             8fa159b3e41e0a44e10ea224cbb83e66ae02885e
                   cmake/FindEigen3.cmake  b042fd7a06a98b114e3399fdf4c6202ce73eaa80)
        set(_ref 00094bd)
        set(_dir "${CMAKE_CURRENT_BINARY_DIR}/eigen3")

        _ycm_download(3rdparty-eigen "Eigen mercurial repository"
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

    endif()

    # FindQCustomPlot.cmake is installed automatically by libqcustomplot-dev on
    # some Debian and Ubuntu releases. Anyway it does not define
    # QCustomPlot_INCLUDE_DIRS, therefore it is always imported.
    set(_files LICENSE.txt                 8624bcdae55baeef00cd11d5dfcfa60f68710a02
               cmake/FindQCustomPlot.cmake a59dd4d955a5e775270a4f2656a039ae490e03ed)
    set(_ref 8689fcb1fdd2e8dc748e76d54d3b77a3f87d384c)
    set(_dir "${CMAKE_CURRENT_BINARY_DIR}/ovito")

    _ycm_download(3rdparty-ovito "OVITO (The Open Visualization Tool) git repository"
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


    # FindOctave.cmake is taken from CMake wiki:
    # https://cmake.org/Wiki/CMakeUserFindOctave
    _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/FindOctave.cmake
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

    _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/COPYING.CMake-wiki
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

    _ycm_install(3rdparty-cmake-wiki FILES cmake-wiki/README.CMake-wiki
                                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

endif()
