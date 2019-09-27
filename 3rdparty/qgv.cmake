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
# FindGraphviz.cmake is a modified version taken from the qgv repository

_ycm_install(3rdparty-qgv FILES qgv/FindGraphviz.cmake
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-qgv FILES qgv/LICENSE.txt
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                          RENAME COPYING.qgv)

_ycm_install(3rdparty-qgv FILES qgv/README.qgv
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
