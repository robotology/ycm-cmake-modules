include(IncludeUrl)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/foo.cmake" "set(FOO 1)\n")
unset(FOO)
include_url("file://${CMAKE_CURRENT_BINARY_DIR}/foo.cmake"
            DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/bar.cmake"
            RETRIES 0)
