include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_HASH SHA1=0000000000000000000000000000000000000000
            OPTIONAL)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()
