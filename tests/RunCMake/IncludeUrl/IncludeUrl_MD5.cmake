include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
set(_expected_hash b2f9beea564803b1d50a53f913508cb3)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_MD5 b2f9beea564803b1d50a53f913508cb3
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(MD5 ${_result} _hash)
if(NOT "${_hash}" STREQUAL "${_expected_hash}")
  message(FATAL_ERROR "include_url: ERROR (wrong hash)")
endif()
