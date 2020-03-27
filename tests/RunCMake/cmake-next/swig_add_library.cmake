if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
  cmake_policy(SET CMP0078 NEW)
endif()

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.14)
  cmake_policy(SET CMP0086 NEW)
endif()

find_package(SWIG QUIET)
if(SWIG_FOUND)
  if(NOT EXISTS "${SWIG_USE_FILE}")
    message(FATAL_ERROR "SWIG_USE_FILE not found (${SWIG_USE_FILE})")
  endif()
  include(${SWIG_USE_FILE})

  enable_language(C)
  swig_add_library(test_swig_add_library
                   LANGUAGE python
                   SOURCES swig_add_library.i)
endif()
