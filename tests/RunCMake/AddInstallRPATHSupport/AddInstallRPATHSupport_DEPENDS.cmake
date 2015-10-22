include(AddInstallRPATHSupport)

set(FOO 0)
unset(CMAKE_MACOSX_RPATH)
add_install_rpath_support(BIN_DIRS ${CMAKE_CURRENT_BINARY_DIR}/bin
                                   ${CMAKE_CURRENT_BINARY_DIR}/lib
                          LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib
                          DEPENDS FOO)
if(CMAKE_MACOSX_RPATH)
  message(FATAL_ERROR "add_install_rpath_support: RPATH should be disabled")
endif()

set(FOO 1)
unset(CMAKE_MACOSX_RPATH)
add_install_rpath_support(BIN_DIRS ${CMAKE_CURRENT_BINARY_DIR}/bin
                                   ${CMAKE_CURRENT_BINARY_DIR}/lib
                          LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib
                          DEPENDS FOO)
if(NOT CMAKE_MACOSX_RPATH)
  message(FATAL_ERROR "add_install_rpath_support: RPATH should enabled")
endif()

set(BAR 0)
unset(CMAKE_MACOSX_RPATH)
add_install_rpath_support(BIN_DIRS ${CMAKE_CURRENT_BINARY_DIR}/bin
                                   ${CMAKE_CURRENT_BINARY_DIR}/lib
                          LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib
                          DEPENDS "FOO;BAR")
if(CMAKE_MACOSX_RPATH)
  message(FATAL_ERROR "add_install_rpath_support: RPATH should be disabled")
endif()

unset(CMAKE_MACOSX_RPATH)
add_install_rpath_support(BIN_DIRS ${CMAKE_CURRENT_BINARY_DIR}/bin
                                   ${CMAKE_CURRENT_BINARY_DIR}/lib
                          LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib
                          DEPENDS "FOO;NOT BAR")
if(NOT CMAKE_MACOSX_RPATH)
  message(FATAL_ERROR "add_install_rpath_support: RPATH should enabled")
endif()

unset(CMAKE_MACOSX_RPATH)
add_install_rpath_support(BIN_DIRS ${CMAKE_CURRENT_BINARY_DIR}/bin
                                   ${CMAKE_CURRENT_BINARY_DIR}/lib
                          LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib
                          DEPENDS ${FOO})
if(NOT CMAKE_MACOSX_RPATH)
  message(FATAL_ERROR "add_install_rpath_support: RPATH should enabled")
endif()
