# SPDX-FileCopyrightText: 2023 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FinduSockets
-----------

The following imported targets are created:

uSockets::uSockets

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_path(uSockets_INCLUDE_DIR libusockets.h)
mark_as_advanced(uSockets_INCLUDE_DIR)
find_library(uSockets_LIBRARY uSockets libuSockets)
mark_as_advanced(uSockets_LIBRARY)

find_package_handle_standard_args(uSockets DEFAULT_MSG uSockets_INCLUDE_DIR uSockets_LIBRARY)

if(uSockets_FOUND)
    if(NOT TARGET uSockets::uSockets)
      add_library(uSockets::uSockets UNKNOWN IMPORTED)
      set_target_properties(uSockets::uSockets PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${uSockets_INCLUDE_DIR}")
      set_property(TARGET uSockets::uSockets PROPERTY
        IMPORTED_LOCATION "${uSockets_LIBRARY}")
    endif()
endif()
