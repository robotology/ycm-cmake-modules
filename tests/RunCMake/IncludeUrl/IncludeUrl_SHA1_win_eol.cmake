include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\r\n")
unset(FOO)
set(_expected_hash fb50e20c99f1df15ea5f92475de13e07fab47edb)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_HASH SHA1=${_expected_hash})
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
