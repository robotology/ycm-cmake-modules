#=============================================================================
# Copyright 2017 Istituto Italiano di Tecnologia (IIT)
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


set(STYLE_MODULES StyleBITBUCKET.cmake
                  StyleGITHUB.cmake
                  StyleGITLAB_ROBOTOLOGY.cmake
                  StyleGNOME.cmake
                  StyleKDE.cmake
                  StyleLOCAL.cmake
                  StyleNONE.cmake
                  StyleSOURCEFORGE.cmake)

_ycm_install(style-modules FILES ${STYLE_MODULES}
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/style-modules")
