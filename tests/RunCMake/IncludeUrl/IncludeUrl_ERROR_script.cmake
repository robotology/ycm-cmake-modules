file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/script.cmake" "include(IncludeUrl)
include_url(\"file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake\" DOWNLOAD_ALWAYS)
")
execute_process(COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/script.cmake"
                RESULT_VARIABLE _res
                ERROR_QUIET)
if(NOT _res)
  message(FATAL_ERROR "include_url: ERROR (script did not return an error)")
endif()
