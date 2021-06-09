# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2010 Jan Woetzel
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindGSL
-------

Try to find GSL library
Once run this will define::

 GSL_FOUND
 GSL_INCLUDE_DIR
 GSL_INCLUDE_DIRS
 GSL_LIBRARIES
 GSL_LINK_DIRECTORIES
 GSLCBLAS_LIBRARY
 GSL_LIBRARY

#]=======================================================================]

##### check GSL_ROOT
if(EXISTS "$ENV{GSL_ROOT}")
    set(GSL_POSSIBLE_INCDIRS
        "$ENV{GSL_ROOT}/include"
        "$ENV{GSL_ROOT}")

    set(GSL_POSSIBLE_LIBRARY_PATHS
        "$ENV{GSL_ROOT}/Release"
        "$ENV{GSL_ROOT}/lib")
endif(EXISTS "$ENV{GSL_ROOT}")

##### check GSL_DIR
if(EXISTS "$ENV{GSL_DIR}")
    set(GSL_POSSIBLE_INCDIRS
        "$ENV{GSL_DIR}/include"
        "$ENV{GSL_DIR}")

    set(GSL_POSSIBLE_LIBRARY_PATHS
        "$ENV{GSL_DIR}/lib"
        "$ENV{GSL_DIR}/Release")
endif(EXISTS "$ENV{GSL_DIR}")

if(GSL_DIR)
    set(GSL_POSSIBLE_INCDIRS
        "${GSL_DIR}/include"
        "${GSL_DIR}")

    set(GSL_POSSIBLE_LIBRARY_PATHS
        "${GSL_DIR}/lib"
        "${GSL_DIR}/Release")
endif(GSL_DIR)

find_path(GSL_BLAS_HEADER gsl/gsl_blas.h
          ${GSL_POSSIBLE_INCDIRS}
          /usr/include
          /usr/local/include)

find_library(GSL_LIBRARY
             NAMES libgsl libgsl.lib gsl
             PATHS ${GSL_POSSIBLE_LIBRARY_PATHS}
                   /usr/lib
                   /usr/local/lib
             DOC "Location of the gsl lib")

find_library(GSLCBLAS_LIBRARY
             NAMES libgslcblas libgslcblas.lib gslcblas
             PATHS ${GSL_POSSIBLE_LIBRARY_PATHS}
                   /usr/lib
                   /usr/local/lib
             DOC "Location of the gsl lib")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GSL
                                  DEFAULT_MSG
                                  GSL_LIBRARY
                                  GSLCBLAS_LIBRARY
                                  GSL_BLAS_HEADER
)

if(GSL_FOUND)
    set(GSL_INCLUDE_DIR "${GSL_BLAS_HEADER}")
    set(GSL_INCLUDE_DIRS "${GSL_BLAS_HEADER}")
    set(GSL_LINK_DIRECTORIES "$ENV{GSL_ROOT}/lib")
    set(GSL_LIBRARIES "${GSL_LIBRARY}")
    set(GSL_LIBRARIES "${GSL_LIBRARIES}" "${GSLCBLAS_LIBRARY}")
    set(GSL_FOUND ON)
    set(GSL_DIR "$ENV{GSL_ROOT}")
endif()

set(GSL_MARK)


if(GSL_FOUND)
    # nothing to say
    if(NOT GSL_DIR)
        mark_as_advanced(GSL_DIR)
    endif(NOT GSL_DIR)
else(GSL_FOUND)
    set(GSL_DIR "" CACHE PATH "Location of GSL")
    if(GSL_FIND_REQUIRED OR GSL_DIR)
        set(GSL_MARK CLEAR)
        message(FATAL_ERROR "GSL library or headers not found. Please search manually or set env. variable GSL_DIR to guide search." )
    endif(GSL_FIND_REQUIRED OR GSL_DIR)
endif(GSL_FOUND)

mark_as_advanced(${GSL_MARK}
                 GSL_INCLUDE_DIR
                 GSL_INCLUDE_DIRS
                 GSL_LINK_DIRECTORIES
                 GSL_LIBRARIES
                 GSLCBLAS_LIBRARIES
                 GSLCBLAS_LIBRARY
                 GSL_BLAS_HEADER
                 GSL_LIBRARY)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(GSL PROPERTIES DESCRIPTION "GNU Scientific Library, a numerical library for C and C++ programmers"
                                          URL "https://www.gnu.org/software/gsl/")
endif()
