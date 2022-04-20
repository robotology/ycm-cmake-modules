# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module is intentionally kept as small as possible in order to
# avoid the spreading of different modules.
#

# CMake variables read as input by this module:
# YCM_MINIMUM_VERSION : minimum version of YCM requested to use a system YCM
# YCM_REPOSITORY : if no suitable system YCM was found, bootstrap from this
#             : GitHub reporitory of YCM
# YCM_TAG     : if no suitable system YCM was found, bootstrap from this
#             : TAG (either branch, commit or tag) of YCM repository
# USE_SYSTEM_YCM : if defined and set FALSE, skip searching for a system
#                  YCM and always bootstrap


if(DEFINED __YCMBOOTSTRAP_INCLUDED)
  return()
endif()
set(__YCMBOOTSTRAP_INCLUDED TRUE)


########################################################################
# _YCM_CLEAN_PATH
#
# Internal function that removes a directory and its subfolder from an
# environment variable.
# This is useful because will stop CMake from finding the external
# projects built in the main project on the second CMake run.
#
# _path: path that should be removed
# _envvar: environment variable to clean

function(_YCM_CLEAN_PATH _path _envvar)
    get_filename_component(_path ${_path} REALPATH)
    set(_var_new "")
    if(NOT "$ENV{${_envvar}}" MATCHES "^$")
        file(TO_CMAKE_PATH "$ENV{${_envvar}}" _var_old)
        if(NOT WIN32)
            # CMake handles correctly ":" except for the first character
            string(REPLACE ":" ";" _var_old "${_var_old}")
        endif()
        foreach(_dir ${_var_old})
            get_filename_component(_dir ${_dir} REALPATH)
            if(NOT "${_dir}" MATCHES "^${_path}")
                list(APPEND _var_new ${_dir})
            endif()
        endforeach()
    endif()
    list(REMOVE_DUPLICATES _var_new)
    file(TO_NATIVE_PATH "${_var_new}" _var_new)
    if(NOT WIN32)
        string(REPLACE ";" ":" _var_new "${_var_new}")
    endif()
    set(ENV{${_envvar}} "${_var_new}")
endfunction()


# Remove binary dir from CMAKE_PREFIX_PATH and PATH before searching for
# YCM, in order to avoid to find the YCM version bootstrapped by YCM
# itself.
_ycm_clean_path("${CMAKE_BINARY_DIR}/install" CMAKE_PREFIX_PATH)
_ycm_clean_path("${CMAKE_BINARY_DIR}/install" PATH)


# If the USE_SYSTEM_YCM is explicitly set to false, we just skip to bootstrap.
if(NOT DEFINED USE_SYSTEM_YCM OR USE_SYSTEM_YCM)
    find_package(YCM ${YCM_MINIMUM_VERSION} QUIET)
    if(COMMAND set_package_properties)
        set_package_properties(YCM PROPERTIES TYPE RECOMMENDED
                                              PURPOSE "Used by the build system")
    endif()
    if(YCM_FOUND)
        message(STATUS "YCM found in ${YCM_MODULE_DIR}.")
        set_property(GLOBAL APPEND PROPERTY YCM_PROJECTS YCM)
        return()
    endif()
endif()

message(STATUS "YCM not found. Bootstrapping it.")

# Download and use a copy of the YCM library for bootstrapping
# This is different from the YCM that will be downloaded as part of the superbuild
include(FetchContent)
if(DEFINED YCM_REPOSITORY)
  set(YCM_FETCHCONTENT_REPOSITORY ${YCM_REPOSITORY})
else()
  set(YCM_FETCHCONTENT_REPOSITORY robotology/ycm.git)
endif()
if(DEFINED YCM_TAG)
  set(YCM_FETCHCONTENT_TAG ${YCM_TAG})
else()
  set(YCM_FETCHCONTENT_TAG master)
endif()
FetchContent_Declare(YCM
                     GIT_REPOSITORY https://github.com/${YCM_FETCHCONTENT_REPOSITORY}
                     GIT_TAG ${YCM_FETCHCONTENT_TAG})

FetchContent_GetProperties(YCM)
if(NOT YCM_POPULATED)
    message(STATUS "Fetching YCM.")
    FetchContent_Populate(YCM)
    # Add YCM modules in CMAKE_MODULE_PATH
    include(${ycm_SOURCE_DIR}/tools/UseYCMFromSource.cmake)
endif()

