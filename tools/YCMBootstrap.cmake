# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module is intentionally kept as small as possible in order to
# avoid the spreading of different modules.
#
# The real bootstrap is performed by the ycm_bootstrap macro from the
# YCMEPHelper module that is downloaded from the YCM package.

# CMake variables read as input by this module:
# YCM_MINIMUM_VERSION : minimum version of YCM requested to use a system YCM 
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

set(YCM_BOOTSTRAP_BASE_ADDRESS "https://raw.githubusercontent.com/robotology/ycm/HEAD" CACHE STRING "Base address of YCM repository")
# Replace old raw.github address to support existing builds
if("${YCM_BOOTSTRAP_BASE_ADDRESS}" MATCHES "raw.github.com")
    string(REPLACE "raw.github.com" "raw.githubusercontent.com" _tmp ${YCM_BOOTSTRAP_BASE_ADDRESS})
    set_property(CACHE YCM_BOOTSTRAP_BASE_ADDRESS PROPERTY VALUE "${_tmp}")
endif()
# New github address does not accept "//" in the path, therefore we remove the last slash
if("${YCM_BOOTSTRAP_BASE_ADDRESS}" MATCHES "/$")
    string(REGEX REPLACE "/$" "" _tmp ${_tmp})
    set_property(CACHE YCM_BOOTSTRAP_BASE_ADDRESS PROPERTY VALUE "${_tmp}")
endif()
mark_as_advanced(YCM_BOOTSTRAP_BASE_ADDRESS)

if("${YCM_BOOTSTRAP_BASE_ADDRESS}" MATCHES "/HEAD$" AND YCM_TAG)
    string(REGEX REPLACE "/HEAD$" "/${YCM_TAG}" YCM_BOOTSTRAP_BASE_ADDRESS ${YCM_BOOTSTRAP_BASE_ADDRESS})
endif()

include(IncludeUrl)
include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/modules/YCMEPHelper.cmake)
ycm_bootstrap()
