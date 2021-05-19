# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# FindGraphviz.cmake is a modified version taken from the qgv repository

_ycm_install(3rdparty-qgv FILES qgv/FindGraphviz.cmake
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-qgv FILES qgv/LICENSE.txt
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                          RENAME COPYING.qgv)

_ycm_install(3rdparty-qgv FILES qgv/README.qgv
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
