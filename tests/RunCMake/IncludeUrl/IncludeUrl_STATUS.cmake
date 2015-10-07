include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            STATUS _status)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT _status EQUAL 0)
  list(GET 0 _status _status_0)
  list(GET 1 _status _status_1)
  message(FATAL_ERROR "include_url: ERROR (download failed with ${_status_0}: ${_status_1})")
endif()


# Not existing file (simulate download failure). File already downloaded
# (old file included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            STATUS _status)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(_status EQUAL 0)
  message(FATAL_ERROR "include_url: ERROR (should be error)")
endif()


# Not existing file (simulate download failure). File already downloaded
# and DOWNLOAD_ONCE enabled (old file included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ONCE
            STATUS _status)
if(NOT FOO)
  message(FATAL_ERROR "include_url: ERROR (not included or unexpected content)")
endif()
if(NOT _status EQUAL 0)
  list(GET 0 _status _status_0)
  list(GET 1 _status _status_1)
  message(FATAL_ERROR "include_url: ERROR (download failed with ${_status_0}: ${_status_1})")
endif()


# Not existing file (simulate download failure).  File already downloaded
# and DOWNLOAD_ALWAYS and OPTIONAL enabled (old file NOT included).
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake")
unset(FOO)
set(_result_orig _result)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DOWNLOAD_ALWAYS
            OPTIONAL
            STATUS _status)
if(FOO)
  message(FATAL_ERROR "include_url: ERROR (wrong file included)")
endif()
if(_status EQUAL 0)
  message(FATAL_ERROR "include_url: ERROR (should be error)")
endif()
