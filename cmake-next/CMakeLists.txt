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


set(YCM_CMAKE_DOWNLOAD_URL "https://raw.githubusercontent.com/Kitware/CMake/<REF>/<FILE>"
    CACHE STRING "Url used to download CMake modules")
set_property(CACHE YCM_CMAKE_DOWNLOAD_URL PROPERTY
             STRINGS "https://raw.githubusercontent.com/Kitware/CMake/<REF>/<FILE>"
                     "http://cmake.org/gitweb?p=cmake.git\;a=blob_plain\;f=<FILE>\;hb=<REF>")
mark_as_advanced(YCM_CMAKE_DOWNLOAD_URL)

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
                "${YCM_CMAKE_DOWNLOAD_URL}"
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

    string(REPLACE "<REF>" "${_ref}" _src "${YCM_CMAKE_DOWNLOAD_URL}")
    string(REPLACE "<FILE>" "${_file}" _src "${_src}")
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
#  CMakeFindDependencyMacro         3.0
#  FindFreetype                     3.0
#  FindLua                          3.0
#  FeatureSummary                   3.1
#  CMakePackageConfigHelpers        3.1
#  FindPkgConfig                    3.1            New
#  FindMatlab                       3.3
#  ExternalProject                  3.3            New        Yes
#  GNUInstallDirs                   3.4
#  FindGTK2                         3.5
#  CMakeParseArguments              ---                       Yes
#  FindGLEW                         ---                       Yes

# WARNING FindPackageHandleStandardArgs 3.3 Comment Style -> New

################################################################################
# Files not available or containing bugs in CMake 2.8.11.2
# Imported from CMake tag v2.8.12.2
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
# Imported from CMake tag v3.0.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.0)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.0. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.0 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               84889816c71a04e30e715b89faf10d72a7334839
             Modules/CMakeFindDependencyMacro.cmake      deb8d8b27adeb39cffd9190916fd5f0e3eca4c24
             Modules/FindFreetype.cmake                  b1a41d0d1321356beccc077495aa0d4c3d57e3a6
             Modules/FindLua.cmake                       477a45a0d2554af399492fa2213da72b73315ed1
             Modules/FindPackageHandleStandardArgs.cmake 6f694a4c8de523b14ce1dbc44c3f5942fc467fc1  # Used by FindFreetype and FindLua
             Modules/FindPackageMessage.cmake            eceba493416b1ce30cecbbfad7d4835e80969195  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           00c393ca7dfd7f9ea9d1a5dc99702dcaffd289af) # Used by FindPackageHandleStandardArgs
  _ycm_cmake_next_download(v3.0.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0" "${_files}")
  _ycm_cmake_next_install(v3.0.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.0.2
# Imported from CMake tag v3.1.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.1)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.1. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.1 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               be2d273ed3c3559df71debc3f07fbe76a31dea28
             Modules/FeatureSummary.cmake                3aeab8c56de0ea21a489cc3d90ee47f833c699bc
             Modules/FindPackageHandleStandardArgs.cmake a8857b6817a645669f4fa5999081abf34fa25523  # Used by FindPkgConfig
             Modules/FindPackageMessage.cmake            dbc69daf94e8a4039286f4ae6a8702af418b253a  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           8adc20a6a6a0ca5a82338b6edc3cd6e24ba7b3f2) # Used by FeatureSummary and FindPackageHandleStandardArgs
  set(_now_files
             Modules/CMakePackageConfigHelpers.cmake     8d88059037b52bc607cc69ccb073adaef1206d99)

  # Some files cannot be parsed due to new-style cmake comments, so we ship
  # an old style commented version
  if(NOT CMAKE_VERSION VERSION_LESS 3.0 OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/FindPkgConfig.cmake    8fbef856c63483a208eddcd0e69ea29f59e48460)
  else()
    file(COPY Modules/FindPkgConfig.cmake DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1")
  endif()

  _ycm_cmake_next_download(v3.1.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1" "${_files}")
  _ycm_cmake_next_download_now(v3.1.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1" "${_now_files}")
  _ycm_cmake_next_install(v3.1.3 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.1"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.1.3
# Imported from CMake tag v3.2.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.2)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.2. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.2.3
# Imported from CMake tag v3.3.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.3)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.3. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.3.2
# Imported from CMake tag v3.4.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.4)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.4. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.4 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               be2d273ed3c3559df71debc3f07fbe76a31dea28
             Modules/FindMatlab.cmake                    83badb542408698081fd580d251a1672b92901d7
             Modules/GNUInstallDirs.cmake                8afc4cc7af34df7f5b4e94b1d51c98e72cf553da)
  _ycm_cmake_next_download(v3.4.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.4" "${_files}")
  _ycm_cmake_next_install(v3.4.3 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.4"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.4.3
# Imported from CMake tag v3.5.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.5)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.5. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.5 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               4a4e319a92c005163903c4ae537669d0026bae7d
             Modules/FindGTK2.cmake                      49af0a4282a353269ad0e938775c594d0e1319c7
             Modules/SelectLibraryConfigurations.cmake   4d1ee73df6dadcb2e51f12059cf48f5e9165bb1e  # Used by FindGTK2
             Modules/CMakeParseArguments.cmake           ed00144eafa83bd6653f3915456080265b54159b  # Used by FindGTK2 and FindPackageHandleStandardArgs
             Modules/FindPackageMessage.cmake            dbc69daf94e8a4039286f4ae6a8702af418b253a) # Used by FindPackageHandleStandardArgs
  # Some files cannot be parsed due to new-style cmake comments, so we ship
  # an old style commented version
  if(NOT CMAKE_VERSION VERSION_LESS 3.0 OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/FindPackageHandleStandardArgs.cmake 9a543ff079dc8e313f1dae812688f4be14e25134) # Used by FindGTK2
  else()
    file(COPY Modules/FindPackageHandleStandardArgs.cmake DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5")
  endif()

  _ycm_cmake_next_download(v3.5.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5" "${_files}")
  _ycm_cmake_next_install(v3.5.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")

endif()

################################################################################
# Files not available or containing bugs in CMake 3.5.2
# Imported from CMake tag v3.6.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.6)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.6. You can remove this.")
endif()

# None


################################################################################
# Files not yet available or containing bugs in current CMake release (v3.6.2)
# Imported from latest revision tested

# set(_ref 2d4aeb1ff1550f11ea84346fbe81b8bc34cc5ba7)
#
# if(NOT CMAKE_VERSION VERSION_LESS 3.7)
#     # Just a reminder to update files when a new cmake version is released
#     message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
# endif()
#
# # Always downloaded and installed until manually updated
# set(_files )
#
# _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_files}")
# _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-next"
#                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")


################################################################################
# Files with patches not yet merged in CMake master

# Always installed
set(YCM_CMAKE_PROPOSED_FILES Modules/ExternalProject.cmake
                             Modules/CMakeParseArguments.cmake
                             Modules/FindGLEW.cmake)
set(YCM_CMAKE_PROPOSED_EXTRA_FILES  Copyright.txt # Must be redistributed together with CMake files
                                    README)       # Overwrite README generated by _ycm_cmake_next_download
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed/Modules")
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_EXTRA_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed")
