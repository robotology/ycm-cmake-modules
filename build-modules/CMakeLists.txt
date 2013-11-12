# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

set(YCM_BUILD_MODULES BuildECM.cmake
                      BuildGooCanvas.cmake
                      BuildTemplateExe.cmake
                      BuildTemplateLib.cmake
                      BuildTinyXML.cmake
                      BuildYARP.cmake
                      BuildICUB.cmake
                      BuildGazeboYARPPlugins.cmake)

install(FILES ${YCM_BUILD_MODULES}
        DESTINATION share/YCM/build-modules)
