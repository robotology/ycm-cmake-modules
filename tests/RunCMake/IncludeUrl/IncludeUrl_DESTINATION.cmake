include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RESULT_VARIABLE BAR)
if(NOT FOO)
  message(FATAL_ERROR "include_url ERROR (not included or unexpected content)")
endif()
if(NOT "${BAR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake")
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()
