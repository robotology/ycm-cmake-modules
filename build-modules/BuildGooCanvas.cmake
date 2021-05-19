# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildGooCanvas
--------------

GooCanvas
#]=======================================================================]

include(YCMEPHelper)
include(ExternalProject)

ycm_ep_helper(GooCanvas TYPE GIT
                        STYLE GNOME
                        REPOSITORY goocanvas.git
                        TAG goocanvas-1.0
                        CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-maintainer-mode --prefix=<INSTALL_DIR>)

externalproject_add_step(GooCanvas prepare
                         COMMAND NOCONFIGURE=1 <SOURCE_DIR>/autogen.sh
                         WORKING_DIRECTORY <SOURCE_DIR>
                         COMMENT "Performing prepare step (autogen.sh) for 'GooCanvas'"
                         DEPENDEES update
                         DEPENDERS configure)
