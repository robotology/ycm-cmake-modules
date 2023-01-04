# SPDX-FileCopyrightText: 2023 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FinduWebSockets
-----------

Find the uWebSockets library.

The following imported targets are created:

uWebSockets::uWebSockets

#]=======================================================================]

include(FindPackageHandleStandardArgs)
include(CMakeFindDependencyMacro)

find_dependency(ZLIB REQUIRED)

find_path(uWebSockets_INCLUDE_DIR WebSocket.h PATH_SUFFIXES uwebsockets uWebSockets)
mark_as_advanced(uWebSockets_INCLUDE_DIR)

find_package_handle_standard_args(uWebSockets DEFAULT_MSG uWebSockets_INCLUDE_DIR)

if(uWebSockets_FOUND)
    if(NOT TARGET uWebSockets::uWebSockets)
      add_library(uWebSockets::uWebSockets INTERFACE IMPORTED)
      set_target_properties(uWebSockets::uWebSockets PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${uWebSockets_INCLUDE_DIR}")
      set_target_properties(uWebSockets::uWebSockets PROPERTIES 
        INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)  
    endif()
endif()
