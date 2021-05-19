# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildGtkDatabox
---------------

GtkDatabox
#]=======================================================================]

include(YCMEPHelper)
include(ExternalProject)

ycm_ep_helper(GtkDatabox TYPE GIT
                        STYLE SOURCEFORGE
                        REPOSITORY gtkdatabox/git
                        TAG GTK2
                        CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-maintainer-mode --prefix=<INSTALL_DIR>)

externalproject_add_step(GtkDatabox prepare
                         COMMAND autoreconf --force --install --verbose <SOURCE_DIR>
                         WORKING_DIRECTORY <SOURCE_DIR>
                         COMMENT "Performing prepare step (autogen.sh) for 'GtkDatabox'"
                         DEPENDEES update
                         DEPENDERS configure)

