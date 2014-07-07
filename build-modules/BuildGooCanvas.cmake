#.rst:
# BuildGooCanvas
# --------------
#
# GooCanvas

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

include(YCMEPHelper)
include(ExternalProject)

ycm_ep_helper(GooCanvas TYPE GIT
                        STYLE GNOME
                        REPOSITORY goocanvas.git
                        TAG goocanvas-1.0
                        CONFIGURE_COMMAND @GooCanvas_SOURCE_DIR@/configure --enable-maintainer-mode --prefix=@GooCanvas_INSTALL_DIR@)

externalproject_add_step(GooCanvas prepare
                         COMMAND NOCONFIGURE=1 ${GooCanvas_SOURCE_DIR}/autogen.sh
                         WORKING_DIRECTORY ${GooCanvas_SOURCE_DIR}
                         COMMENT "Performing prepare step (autogen.sh) for 'GooCanvas'"
                         DEPENDEES update
                         DEPENDERS configure)

