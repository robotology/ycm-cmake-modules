# See adjacent README.rst for documentation of this test infrastructure.
macro(add_RunCMake_test test)
  set(TEST_ARGS ${ARGN})
  if ("${ARGV1}" STREQUAL "TEST_DIR")
    if ("${ARGV2}" STREQUAL "")
      message(FATAL_ERROR "Invalid args")
    endif()
    set(Test_Dir ${ARGV2})
    list(REMOVE_AT TEST_ARGS 0)
    list(REMOVE_AT TEST_ARGS 0)
  else()
    set(Test_Dir ${test})
  endif()
  add_test(NAME RunCMake.${test} COMMAND ${CMAKE_CMAKE_COMMAND}
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_SOURCE_DIR}
    -DYCM_SOURCE_DIR=${YCM_SOURCE_DIR}
    -DYCM_BINARY_DIR=${YCM_BINARY_DIR}
    -DRunCMake_GENERATOR=${CMAKE_GENERATOR}
    -DRunCMake_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
    -DRunCMake_GENERATOR_TOOLSET=${CMAKE_GENERATOR_TOOLSET}
    -DRunCMake_MAKE_PROGRAM=${CMake_TEST_EXPLICIT_MAKE_PROGRAM}
    -DRunCMake_MODULE_PATH=${YCM_SOURCE_DIR}/modules
    -DRunCMake_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}/${Test_Dir}
    -DRunCMake_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}/${test}
    ${${test}_ARGS}
    ${TEST_ARGS}
    -P "${CMAKE_CURRENT_SOURCE_DIR}/${Test_Dir}/RunCMakeTest.cmake"
    )
endmacro()

function(add_RunCMake_test_group test types)
  # create directory for common content
  set(TEST_CONFIG_DIR "${CMAKE_CURRENT_BINARY_DIR}/${test}/conf")
  file(REMOVE_RECURSE "${TEST_CONFIG_DIR}")
  file(MAKE_DIRECTORY "${TEST_CONFIG_DIR}")

  foreach(type IN LISTS types)
    # generate prerequirements config file in cmake as ctest doesn't have as
    # much system information so it is easier to set programs and environment
    # values here
    unset(${test}_${type}_FOUND_PREREQUIREMENTS)
    include("${CMAKE_CURRENT_SOURCE_DIR}/${test}/${type}/Prerequirements.cmake")
    get_test_prerequirements("${test}_${type}_FOUND_PREREQUIREMENTS"
        "${TEST_CONFIG_DIR}/${type}_config.cmake")

    # only add the test if prerequirements are met
    if(${test}_${type}_FOUND_PREREQUIREMENTS)
      add_test(NAME RunCMake.${test}_${type} COMMAND ${CMAKE_CMAKE_COMMAND}
        -DTEST_TYPE=${type}
        -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_SOURCE_DIR}
        -DYCM_SOURCE_DIR=${YCM_SOURCE_DIR}
        -DRunCMake_GENERATOR=${CMAKE_GENERATOR}
        -DRunCMake_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
        -DRunCMake_GENERATOR_TOOLSET=${CMAKE_GENERATOR_TOOLSET}
        -DRunCMake_MAKE_PROGRAM=${CMake_TEST_EXPLICIT_MAKE_PROGRAM}
        -DRunCMake_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}/${test}
        -DRunCMake_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}/${type}/${test}
        -Dconfig_file=${TEST_CONFIG_DIR}/${type}_config.cmake
        -P "${CMAKE_CURRENT_SOURCE_DIR}/${test}/RunCMakeTest.cmake"
        )
    endif()
  endforeach()
endfunction()

add_RunCMake_test(AddInstallRPATHSupport)
add_RunCMake_test(IncludeUrl)
add_RunCMake_test(cmake-next)
add_RunCMake_test(3rdparty)
