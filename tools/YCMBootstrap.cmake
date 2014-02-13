# This module is intentionally kept as small as possible in order to
# avoid the spreading of different modules.
#
# The real bootstrap is performed by the ycm_bootstrap macro from the
# YCMEPHelper module that is downloaded from the YCM package.


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
    set(ENV{${_envvar}} ${_var_new})
endfunction()


# Remove binary dir from CMAKE_PREFIX_PATH and PATH before searching for
# YCM, in order to avoid to find the YCM version bootstrapped by YCM
# itself.
_ycm_clean_path("${CMAKE_BINARY_DIR}/install" CMAKE_PREFIX_PATH)
_ycm_clean_path("${CMAKE_BINARY_DIR}/install" PATH)


find_package(YCM QUIET)
set_package_properties(YCM PROPERTIES TYPE RECOMMENDED
                                      PURPOSE "Used by the build system")

if(YCM_FOUND)
    return()
endif()

message(STATUS "YCM not found. Bootstrapping it.")

set(YCM_BOOTSTRAP_BASE_ADDRESS "https://raw.github.com/robotology/ycm/HEAD/" CACHE STRING "Base address of YCM repository")
mark_as_advanced(YCM_BOOTSTRAP_BASE_ADDRESS)

include(IncludeUrl)
include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/modules/YCMEPHelper.cmake)
ycm_bootstrap()
