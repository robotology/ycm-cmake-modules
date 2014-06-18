#.rst:
# BuildGooCanvas
# --------------
#
# GooCanvas
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

