# Copyright (C) 2013-2014  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

set(YCM_BUILD_MODULES BuildECM.cmake
                      BuildGooCanvas.cmake
                      BuildTinyXML.cmake
                      BuildYARP.cmake
                      BuildICUB.cmake
                      BuildGazeboYARPPlugins.cmake)

_ycm_install(build-modules FILES ${YCM_BUILD_MODULES}
                           DESTINATION ${YCM_INSTALL_MODULE_DIR}/build-modules)
