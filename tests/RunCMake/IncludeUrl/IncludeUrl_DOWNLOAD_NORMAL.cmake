include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp_orig)


# file(TIMESTAMP) has a resolution of one second, therefore we have to
# wait one second between each test to ensure that the result is valid
execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# File has a different content => downloaded
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 0)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if("${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR (timestamp is the same)")
endif()
set(_timestamp_orig ${_timestamp})


execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

# Not existing file (download failure => use the version we already have)
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            RESULT_VARIABLE _result)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (unexpected content)")
endif()
file(TIMESTAMP "${_result}" _timestamp)
if(NOT "${_timestamp}" STREQUAL "${_timestamp_orig}")
  message(FATAL_ERROR "include_url: ERROR (timestamp is the same)")
endif()
