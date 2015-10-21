include(IncludeUrl)
if(WIN32)
  set(_expected_hash 116aab141123ae903a2c81eb7a9f0d61bf4bb010)
else()
  set(_expected_hash fb50e20c99f1df15ea5f92475de13e07fab47edb)
endif()

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp_orig)


# file(TIMESTAMP) has a resolution of one second, therefore we have to
# wait one second between each test to ensure that the result is valid
execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# File has a different content (hash not specified => not downloaded)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 0)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if(NOT "${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR")
endif()


execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# Not existing file (simulate download failure) (we already have the
# file => not downloaded)
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if(NOT "${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR")
endif()


execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# Correct hash (not downloaded)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_HASH SHA1=${_expected_hash}
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if(NOT "${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR")
endif()


execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# Wrong hash (downloaded again)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
file(WRITE "${_result}" "set(FOO 0)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            EXPECTED_HASH SHA1=${_expected_hash}
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if("${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR")
endif()
