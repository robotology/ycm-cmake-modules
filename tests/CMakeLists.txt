# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2000-2014 Kitware Inc.
# SPDX-FileCopyrightText: 2000-2011 Insight Software Consortium
# SPDX-License-Identifier: BSD-3-Clause

# Set up test-time configuration.
set_directory_properties(PROPERTIES TEST_INCLUDE_FILE "${CMAKE_CURRENT_BINARY_DIR}/EnforceConfig.cmake")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/EnforceConfig.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/EnforceConfig.cmake @ONLY)

macro(ADD_TEST_MACRO NAME COMMAND)
  string(REPLACE "." "/" dir "${NAME}")
  string(REGEX REPLACE "[^.]*\\." "" proj "${NAME}")
  add_test(${NAME} ${CMAKE_CTEST_COMMAND}
    --build-and-test
    "${CMAKE_CURRENT_SOURCE_DIR}/${dir}"
    "${CMAKE_CURRENT_BINARY_DIR}/${dir}"
    --build-two-config
    ${build_generator_args}
    ${build_makeprogram_args}
    --build-project ${proj}
    ${${NAME}_CTEST_OPTIONS}
    --build-options ${build_options}
    ${${NAME}_BUILD_OPTIONS}
    --test-command ${COMMAND} ${ARGN})
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/${dir}")
endmacro()

# Fake a user home directory to avoid polluting the real one.
if(DEFINED ENV{HOME} AND NOT CTEST_NO_TEST_HOME)
  set(TEST_HOME "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/TestHome")
  file(MAKE_DIRECTORY "${TEST_HOME}")
endif()

# Choose a default configuration for CTest tests.
set(CTestTest_CONFIG Debug)
if(NOT CMAKE_CONFIGURATION_TYPES AND CMAKE_BUILD_TYPE)
  set(CTestTest_CONFIG ${CMAKE_BUILD_TYPE})
endif()

# Testing
if(BUILD_TESTING)
  set(YCM_TEST_DEVENV "")
  if(CMAKE_GENERATOR MATCHES "Visual Studio [7-9] " AND
      NOT CMAKE_MAKE_PROGRAM MATCHES "[mM][sS][bB][uU][iI][lL][dD]\\.[eE][xX][eE]")
    set(YCM_TEST_DEVENV "${CMAKE_MAKE_PROGRAM}")
  endif()

  set(YCM_TEST_EXPLICIT_MAKE_PROGRAM "${CMAKE_MAKE_PROGRAM}")

  if(NOT YCM_TEST_EXTERNAL_CMAKE)
    if("${CMAKE_GENERATOR}" MATCHES "Unix Makefiles" OR ("${CMAKE_GENERATOR}" MATCHES Ninja AND NOT WIN32))
      set(TEST_CompileCommandOutput 1)
    endif()
  endif()

  set(MAKE_IS_GNU )
  if(CMAKE_MAKE_PROGRAM MATCHES make)
    execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} no_such_target --version
      RESULT_VARIABLE res OUTPUT_VARIABLE out ERROR_VARIABLE out)
    if("${res}" STREQUAL "0")
      if("${out}" MATCHES "GNU")
        set(MAKE_IS_GNU 1)
      endif()
    endif()
  endif()

  # some old versions of make simply cannot handle spaces in paths
  if (MAKE_IS_GNU OR
      CMAKE_MAKE_PROGRAM MATCHES "nmake|gmake|wmake" OR
      CMAKE_GENERATOR MATCHES "Visual Studio|Xcode|Borland")
    set(MAKE_SUPPORTS_SPACES 1)
  else()
    set(MAKE_SUPPORTS_SPACES 0)
  endif()

  set(build_generator_args
    --build-generator ${CMAKE_GENERATOR}
    )
  if(CMAKE_GENERATOR_TOOLSET)
    list(APPEND build_generator_args
      --build-generator-toolset ${CMAKE_GENERATOR_TOOLSET}
      )
  endif()

  set(build_options)
  if(YCM_TEST_EXPLICIT_MAKE_PROGRAM)
    list(APPEND build_options -DCMAKE_MAKE_PROGRAM:FILEPATH=${YCM_TEST_EXPLICIT_MAKE_PROGRAM})
  endif()

  set(build_makeprogram_args
    --build-makeprogram ${YCM_TEST_EXPLICIT_MAKE_PROGRAM}
    )

  if(NOT WIN32)
    # sha1sums test is disabled on Windows, because it is an sh script
    add_test(NAME sha1sums
             WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/sha1sums"
             COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/sha1sums/check_sha1sums.sh ${YCM_SOURCE_DIR}/modules/YCMEPHelper.cmake)
  endif()

  add_test(YCMBootstrap-not-found ${CMAKE_CTEST_COMMAND}
           --build-and-test
           "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap"
           "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-not-found"
           ${build_generator_args}
           ${build_makeprogram_args}
           --build-project YCMBootstrap
           --build-option "-DYCM_BOOTSTRAP_TEST:STRING=NOT_FOUND")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-not-found")

  add_test(YCMBootstrap-build-dir ${CMAKE_CTEST_COMMAND}
           --build-and-test
           "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap"
           "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-build-dir"
           ${build_generator_args}
           ${build_makeprogram_args}
           --build-project YCMBootstrap
           --build-options "-DYCM_BOOTSTRAP_TEST:STRING=BUILD_DIR")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-build-dir")

  add_test(YCMBootstrap-install-dir ${CMAKE_CTEST_COMMAND}
           --build-and-test
           "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap"
           "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-install-dir"
           ${build_generator_args}
           ${build_makeprogram_args}
           --build-project YCMBootstrap
           --build-options "-DYCM_BOOTSTRAP_TEST:STRING=INSTALL_DIR")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-install-dir")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/TestPrefix")

  add_test(YCMBootstrap-not-use-system ${CMAKE_CTEST_COMMAND}
           --build-and-test
           "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap"
           "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-not-use-system"
           ${build_generator_args}
           ${build_makeprogram_args}
           --build-project YCMBootstrap
           --build-options "-DYCM_BOOTSTRAP_TEST:STRING=NOT_USE_SYSTEM")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-not-use-system")

  add_test(YCMBootstrap-disable-find ${CMAKE_CTEST_COMMAND}
           --build-and-test
           "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap"
           "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-disable-find"
           ${build_generator_args}
           ${build_makeprogram_args}
           --build-project YCMBootstrap
           --build-options "-DYCM_BOOTSTRAP_TEST:STRING=DISABLE_FIND")
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_BINARY_DIR}/YCMBootstrap-disable-find")

  # Add download folder to the list of files deleted by test_clean
  list(APPEND TEST_BUILD_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/YCMBootstrap/external")

  if(NOT EXISTS "${YCM_BINARY_DIR}/CMakeLists.txt")
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/test_clean.cmake.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/test_clean.cmake" @ONLY)
    add_custom_target(test_clean
      COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/test_clean.cmake"
      COMMENT "Removing test build directories."
      )
  endif()

  if(CMAKE_GENERATOR MATCHES "Visual Studio|Xcode")
    set(CMake_TEST_EXPLICIT_MAKE_PROGRAM "")
  else()
    set(CMake_TEST_EXPLICIT_MAKE_PROGRAM "${CMAKE_MAKE_PROGRAM}")
  endif()

  set(CMAKE_CMAKE_COMMAND "${CMAKE_COMMAND}")

  add_subdirectory(RunCMake)

endif()
