#=============================================================================
# Copyright 2013-2015 Istituto Italiano di Tecnologia (IIT)
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
