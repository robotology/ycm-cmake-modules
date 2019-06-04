find_package(SWIG QUIET)
if(SWIG_FOUND)
  include(${SWIG_USE_FILE})
endif()

enable_language(C)
swig_add_library(test_swig_add_library
                 LANGUAGE python
                 SOURCES swig_add_library.i)
