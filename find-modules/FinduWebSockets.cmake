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

find_dependency(uSockets REQUIRED)
find_dependency(ZLIB REQUIRED)

# We do not use WebSocket.h as it has the same name of a
# Windows system header, found for example in
# C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/um
find_path(uWebSockets_INCLUDE_DIR WebSocketProtocol.h PATH_SUFFIXES uWebSockets uwebsockets)

mark_as_advanced(uWebSockets_INCLUDE_DIR)

find_package_handle_standard_args(uWebSockets DEFAULT_MSG uWebSockets_INCLUDE_DIR)

if(uWebSockets_FOUND)
    if(NOT TARGET uWebSockets::uWebSockets)
      add_library(uWebSockets::uWebSockets INTERFACE IMPORTED)
      set_target_properties(uWebSockets::uWebSockets PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${uWebSockets_INCLUDE_DIR}")
      set_target_properties(uWebSockets::uWebSockets PROPERTIES 
        INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
      set_property(TARGET uWebSockets::uWebSockets APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES uSockets::uSockets)
    endif()
endif()
