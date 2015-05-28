#=============================================================================
# Copyright 2013-2014 iCub Facility, Istituto Italiano di Tecnologia
#   Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of YCM, substitute the full
#  License text for the above reference.)


function(_YCM_CMAKE_NEXT_WRITE_README _ref _dir)
    file(WRITE "${_dir}/README"
"Files in this folder and its subfolder come from CMake git repository
(ref ${_ref}):

  git://cmake.org/cmake.git

They were imported exactly as they are on the original repository, in
order to supply the new features and bugfix available in newer releases
to user with older cmake releases.

These files are distributed under the OSI-approved BSD License;
see accompanying file Copyright.txt for details.
")
endfunction()

function(_YCM_CMAKE_NEXT_DOWNLOAD _ref _dir _files)
    _ycm_download(cmake-${_ref} "CMake git repository"
                  "http://cmake.org/gitweb?p=cmake.git;a=blob_plain;f=<FILE>;hb=<REF>"
                  "${_ref}" "${_dir}" "${_files}")
    _ycm_cmake_next_write_readme(${_ref} "${_dir}")
endfunction()

function(_YCM_CMAKE_NEXT_INSTALL _ref)
    _ycm_install(cmake-${_ref} ${ARGN})
endfunction()

# Download and install files from CMake git at configure time, useful to
# download the modules used by the YCM build that are not available
# on older CMake versions
function(_YCM_CMAKE_NEXT_DOWNLOAD_NOW _ref _dir _files)
    # loop over a list of file and sha1
    list(LENGTH _files _size)
    foreach(_i RANGE 1 ${_size} 2)
        math(EXPR _j "${_i} - 1")
        list(GET _files ${_j} _file)
        list(GET _files ${_i} _sha1)

        set(_src "http://cmake.org/gitweb?p=cmake.git;a=blob_plain;f=${_file};hb=${_ref}")
        set(_dest "${_dir}/${_file}")
        set(_orig_dest "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/cmake-${_ref}.dir/downloads/${_file}")
        set(_offline_dest "${CMAKE_SOURCE_DIR}/downloads/cmake-${_ref}/${_file}")

        if(EXISTS "${_offline_dest}")
            execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_offline_dest}" "${_orig_dest}")
        endif()

        if(NOT EXISTS ${_orig_dest})
            message(STATUS "Downloading file ${_file} from CMake git repository (ref ${_ref})")
            file(DOWNLOAD "${_src}" "${_orig_dest}"
                 EXPECTED_HASH SHA1=${_sha1})
        endif()

        if(WIN32)
            # On Windows we change files end of lines to the windows ones
            file(READ "${_orig_dest}" _tmp)
            string(REPLACE "/r/n" "/n" _tmp "${_tmp}")
            file(WRITE "${_dest}" "${_tmp}")
        else()
            execute_process(COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_orig_dest}" "${_dest}")
        endif()

        execute_process(COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_orig_dest}" "${_offline_dest}")

        set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${_dest})
    endforeach()
    _ycm_cmake_next_write_readme(${_ref} "${_dir}")
endfunction()



# Downloaded modules               CMake Version  Comment    Uncommitted
#                                  Version        Style      Changes
#  SelectLibraryConfigurations      2.8.12
#  FindFreetype                     3.0
#  GNUInstallDirs                   3.0
#  FindLua                          3.0
#  FeatureSummary                   3.1
#  CMakePackageConfigHelpers        3.1
#  FindGTK2                         3.1
#  FindPkgConfig                    3.1            New
#  FindMatlab                       (3.3)
#  ExternalProject                  (3.3)          New        Yes
#  CMakeParseArguments              ---                       Yes

################################################################################
# Files not available or containing bugs in CMake 2.8.11.2
# Imported from CMake 2.8.12.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 2.8.12. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 2.8.12 OR YCM_MAINTAINER_MODE)
    set(_files Copyright.txt                                cc156f64bf5196dfb35f7ae7a4081a434e128ef4
               Modules/SelectLibraryConfigurations.cmake    b0f24bea56e731e219506a1936c08817dc556d0a)
    _ycm_cmake_next_download(v2.8.12.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.12" "${_files}")
    _ycm_cmake_next_install(v2.8.12.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.12"
                                      DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 2.8.12.2
# Imported from CMake 3.0.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.0)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 3.0. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.0 OR YCM_MAINTAINER_MODE)

    set(_files Copyright.txt                               84889816c71a04e30e715b89faf10d72a7334839
               Modules/FindFreetype.cmake                  b1a41d0d1321356beccc077495aa0d4c3d57e3a6
               Modules/GNUInstallDirs.cmake                af110b1c08d2ae909dd12b3dff3b8f9ed0f1c335
               Modules/FindLua.cmake                       477a45a0d2554af399492fa2213da72b73315ed1)
    _ycm_cmake_next_download(v3.0.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0" "${_files}")
    _ycm_cmake_next_install(v3.0.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0"
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.0.2
# Imported from CMake 3.1.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.1)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 3.1. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.1 OR YCM_MAINTAINER_MODE)

    set(_files Copyright.txt                               be2d273ed3c3559df71debc3f07fbe76a31dea28
               Modules/FeatureSummary.cmake                3aeab8c56de0ea21a489cc3d90ee47f833c699bc
               Modules/FindGTK2.cmake                      ffd2211c30aed24d23570b71ed472c6169e1cdd8
               Modules/FindPackageHandleStandardArgs.cmake a8857b6817a645669f4fa5999081abf34fa25523  # Used by FindGTK2
               Modules/SelectLibraryConfigurations.cmake   4d1ee73df6dadcb2e51f12059cf48f5e9165bb1e  # Used by FindGTK2
               Modules/CMakeParseArguments.cmake           8adc20a6a6a0ca5a82338b6edc3cd6e24ba7b3f2  # Used by FindGTK2 and FeatureSummary
               Modules/FindPackageMessage.cmake            dbc69daf94e8a4039286f4ae6a8702af418b253a) # Used by FindPackageHandleStandardArgs

    set(_now_files
               Modules/CMakePackageConfigHelpers.cmake     8d88059037b52bc607cc69ccb073adaef1206d99)

    # Some files cannot be parsed due to new-style cmake comments, so we ship
    # an old style commented version
    if(NOT CMAKE_VERSION VERSION_LESS 3.0 OR YCM_MAINTAINER_MODE)
      list(APPEND _files  Modules/FindPkgConfig.cmake    8fbef856c63483a208eddcd0e69ea29f59e48460)
    else()
      file(COPY Modules/FindPkgConfig.cmake DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-next")
    endif()

    _ycm_cmake_next_download(v3.1.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1" "${_files}")
    _ycm_cmake_next_download_now(v3.1.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1" "${_now_files}")

    _ycm_cmake_next_install(v3.1.3 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1"
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.1.3
# Imported from CMake 3.2.2

# None


################################################################################
# Files not yet available or containing bugs in current CMake release (3.2.2)
# Imported from latest revision tested

set(_ref fcafd0cfc66050ed11c412e9441c4e4b8b54bad1)

if(NOT CMAKE_VERSION VERSION_LESS 3.3)
    # Just a reminder to update files when a new cmake version is released
    message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
endif()

# Always downloaded and installed until manually updated
set(_files Copyright.txt                               be2d273ed3c3559df71debc3f07fbe76a31dea28
           Modules/FindMatlab.cmake                    375f5e6cdc3f92b575b9427a677eae318a43dda3)

_ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_files}")
_ycm_cmake_next_download_now(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_now_files}")

_ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-next"
                                DESTINATION "${YCM_INSTALL_MODULE_DIR}")



################################################################################
# Files with patches not yet merged in CMake master

# Always installed
set(YCM_CMAKE_PROPOSED_FILES Modules/ExternalProject.cmake
                             Modules/CMakeParseArguments.cmake)
set(YCM_CMAKE_PROPOSED_EXTRA_FILES  Copyright.txt # Must be redistributed together with CMake files
                                    README)       # Overwrite README generated by _ycm_cmake_next_download
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed/Modules")
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_EXTRA_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed")
