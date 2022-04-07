# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# FindQCustomPlot.cmake is installed automatically by libqcustomplot-dev on
# some old Debian and Ubuntu releases (replaced by QCustomPlotConfig.cmake on
# newer releases). Anyway it does not define QCustomPlot_INCLUDE_DIRS,
# therefore it is always imported.

set(_dir "${CMAKE_CURRENT_SOURCE_DIR}/ovito")

if(YCM_DOWNLOAD_3RDPARTY)
  set(_files LICENSE.txt                  8624bcdae55baeef00cd11d5dfcfa60f68710a02
             cmake/FindQCustomPlot.cmake  a59dd4d955a5e775270a4f2656a039ae490e03ed)
  set(_ref 8689fcb1fdd2e8dc748e76d54d3b77a3f87d384c)

  _ycm_download(3rdparty-ovito
               "OVITO (The Open Visualization Tool) git repository"
               "https://gitlab.com/stuko/ovito/raw/<REF>/<FILE>"
               ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.OVITO"
"Some of the files in this folder and its subfolder come from the OVITO git
repository (ref ${_ref}):

  https://gitlab.com/stuko/ovito

Redistribution and use is allowed according to the terms of the GPL3 license.
See accompanying file COPYING.OVITO for details.
")
endif()

_ycm_install(3rdparty-ovito FILES "${_dir}/cmake/FindQCustomPlot.cmake"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-ovito FILES "${_dir}/LICENSE.txt"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                            RENAME COPYING.OVITO)

_ycm_install(3rdparty-ovito FILES "${_dir}/README.OVITO"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
