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
