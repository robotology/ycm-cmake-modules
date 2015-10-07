include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT "${_result}" MATCHES "foo.cmake")
  message(FATAL_ERROR "include_url: ERROR (unexpected RETURN_VARIABLE value)")
endif()

# DESTINATION enabled
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT "${_result}" MATCHES ".+/bar.cmake")
  message(FATAL_ERROR "include_url: ERROR (unexpected RETURN_VARIABLE value)")
endif()

# Not existing file (simulate download failure). File already downloaded
# (old file included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT "${_result}" MATCHES ".+/foo.cmake")
  message(FATAL_ERROR "include_url: ERROR (unexpected RETURN_VARIABLE value)")
endif()

# Not existing file (simulate download failure). File already downloaded
# and DOWNLOAD_ONCE enabled (old file included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ONCE
            RESULT_VARIABLE _result)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT "${_result}" MATCHES ".+/foo.cmake")
  message(FATAL_ERROR "include_url: ERROR (unexpected RETURN_VARIABLE value)")
endif()

# Not existing file (simulate download failure).  File already downloaded
# and DOWNLOAD_ALWAYS and OPTIONAL enabled (old file NOT included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
set(_result_orig _result)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ALWAYS
            OPTIONAL
            RESULT_VARIABLE _result)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()
if(EXISTS "${_result_orig}")
  message(FATAL_ERROR "include_url: ERROR (original file still exists)")
endif()
if(NOT "${_result}" STREQUAL "NOTFOUND")
  message(FATAL_ERROR "include_url: ERROR (unexpected RETURN_VARIABLE value)")
endif()
