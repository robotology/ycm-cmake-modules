include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
set(_expected_hash 116aab141123ae903a2c81eb7a9f0d61bf4bb010)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_HASH SHA1=${_expected_hash})
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
