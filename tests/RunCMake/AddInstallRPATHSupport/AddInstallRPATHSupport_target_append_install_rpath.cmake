enable_language(CXX)
include(AddInstallRPATHSupport)

add_library(foo)
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/foo.cpp "void foo() {}\n")
target_sources(foo PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/foo.cpp)

target_append_install_rpath(foo
                            INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/lib/foo
                            LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib)

get_target_property(foo_rpath foo INSTALL_RPATH)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  string(REGEX REPLACE "@loader_path" "_" foo_rpath_s "${foo_rpath}")
else()
  string(REGEX REPLACE "\\$ORIGIN" "_" foo_rpath_s "${foo_rpath}")
endif()

if (NOT "${foo_rpath_s}" STREQUAL "_/../")
  message(FATAL_ERROR "Unexpected rpath: ${foo_rpath}")
endif()

target_append_install_rpath(foo
                            INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/lib/foo
                            LIB_DIRS ${CMAKE_CURRENT_BINARY_DIR}/lib/bar)

get_target_property(foo_rpath foo INSTALL_RPATH)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  string(REGEX REPLACE "@loader_path" "_" foo_rpath_s "${foo_rpath}")
else()
  string(REGEX REPLACE "\\$ORIGIN" "_" foo_rpath_s "${foo_rpath}")
endif()

if (NOT "${foo_rpath_s}" STREQUAL "_/../;_/../bar")
  message(FATAL_ERROR "Unexpected rpath ${foo_rpath}")
endif()
