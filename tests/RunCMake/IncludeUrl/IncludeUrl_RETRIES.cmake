include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RETRIES 5)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()

file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RETRIES 500
            QUIET)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()

file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RETRIES 5
            OPTIONAL)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()

file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RETRIES 5)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()
