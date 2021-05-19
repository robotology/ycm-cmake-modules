# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildGooCanvasMM
----------------

GooCanvasMM
#]=======================================================================]

include(YCMEPHelper)
include(ExternalProject)

find_or_build_package(GooCanvas QUIET)
if(COMMAND set_package_properties)
    set_package_properties(GooCanvas PROPERTIES PURPOSE "Used by GooCanvasMM")
endif()

# TODO find_package(MMCommon required) -> mm-common
# TODO libgtkmm-2.4-dev

ycm_ep_helper(GooCanvasMM TYPE GIT
                          STYLE GNOME
                          REPOSITORY goocanvasmm.git
                          TAG goocanvasmm-1.0
                          DEPENDS GooCanvas
                          CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-maintainer-mode --prefix=<INSTALL_DIR>)

externalproject_add_step(GooCanvasMM prepare
                         COMMAND NOCONFIGURE=1 <SOURCE_DIR>/autogen.sh
                         WORKING_DIRECTORY <SOURCE_DIR>
                         COMMENT "Performing prepare step (autogen.sh) for 'GooCanvasMM'"
                         DEPENDEES update
                         DEPENDERS configure)

