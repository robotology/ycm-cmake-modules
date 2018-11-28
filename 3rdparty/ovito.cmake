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


##############################################################################
# FindQCustomPlot.cmake is installed automatically by libqcustomplot-dev on
# some old Debian and Ubuntu releases (replaced by QCustomPlotConfig.cmake on
# newer releases). Anyway it does not define QCustomPlot_INCLUDE_DIRS,
# therefore it is always imported.

set(_files LICENSE.txt                  8624bcdae55baeef00cd11d5dfcfa60f68710a02
           cmake/FindQCustomPlot.cmake  a59dd4d955a5e775270a4f2656a039ae490e03ed)
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
