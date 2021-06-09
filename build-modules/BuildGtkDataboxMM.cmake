# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildGtkDataboxMM
-----------------

GtkDataboxMM
#]=======================================================================]

include(YCMEPHelper)
include(ExternalProject)

find_or_build_package(GtkDatabox QUIET)
if(COMMAND set_package_properties)
    set_package_properties(GtkDatabox PROPERTIES PURPOSE "Used by GtkDatabox")
endif()

ycm_ep_helper(GtkDataboxMM TYPE GIT
                           STYLE SOURCEFORGE
                           REPOSITORY gtkdataboxmm/code
                           DEPENDS GtkDatabox
                           TAG v0.9.4
                           CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-maintainer-mode --prefix=<INSTALL_DIR>)

externalproject_add_step(GtkDataboxMM prepare
                         COMMAND NOCONFIGURE=1 <SOURCE_DIR>/autogen.sh
                         WORKING_DIRECTORY <SOURCE_DIR>
                         COMMENT "Performing prepare step (autogen.sh) for 'GtkDataboxMM'"
                         DEPENDEES update
                         DEPENDERS configure)

