cmake_minimum_required(VERSION 2.8.7)
project(YCM-bootstrap NONE)

include(FeatureSummary)

set(CMAKE_PREFIX_PATH )
set(ENV{CMAKE_PREFIX_PATH} )

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}/cmake")

get_filename_component(YCM_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../" REALPATH)
get_filename_component(YCM_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/../../" REALPATH)

file(COPY ${YCM_SOURCE_DIR}/tools/YCMBootstrap.cmake
          ${YCM_SOURCE_DIR}/modules/IncludeUrl.cmake
          DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/cmake)

set(YCM_BOOTSTRAP_BASE_ADDRESS file://${YCM_SOURCE_DIR} CACHE STRING "Base address of YCM repository")
set(YCM_BOOTSTRAP_VERBOSE TRUE)
set(YCM_STYLE LOCAL)
set(YCM_REPOSITORY file://${YCM_SOURCE_DIR})
set(NON_INTERACTIVE_BUILD TRUE)

if(YCM_BOOTSTRAP_TEST STREQUAL "BUILD_DIR")
    set(YCM_DIR ${YCM_BINARY_DIR} CACHE PATH "")
elseif(YCM_BOOTSTRAP_TEST STREQUAL "INSTALL_DIR")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/build")
    execute_process(COMMAND ${CMAKE_COMMAND} ${YCM_SOURCE_DIR} -DCMAKE_INSTALL_PREFIX=${YCM_BINARY_DIR}/tests/CMakeFiles/TestPrefix
                    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_BINARY_DIR}/build
                    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_BINARY_DIR}/build --target install
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/build
                    OUTPUT_QUIET
                    ERROR_QUIET)
    list(APPEND CMAKE_PREFIX_PATH "${YCM_BINARY_DIR}/tests/CMakeFiles/TestPrefix")
endif()

include(YCMBootstrap)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES)
