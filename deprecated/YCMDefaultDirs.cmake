# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
YCMDefaultDirs
--------------
#]=======================================================================]


include(${CMAKE_CURRENT_LIST_DIR}/YCMDeprecatedWarning.cmake)
ycm_deprecated_warning("YCMDefaultDirs.cmake is deprecated.")

include(GNUInstallDirs)

macro(YCM_DEFAULT_DIRS _prefix)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})

    set(${_prefix}_BUILD_LIBDIR ${CMAKE_INSTALL_LIBDIR})
    set(${_prefix}_BUILD_BINDIR ${CMAKE_INSTALL_BINDIR})
    set(${_prefix}_BUILD_INCLUDEDIR ${CMAKE_SOURCE_DIR}/src)

    set(${_prefix}_INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR})
    set(${_prefix}_INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR})
    set(${_prefix}_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR})
endmacro()
