#=============================================================================
# Copyright 2013-2014 Istituto Italiano di Tecnologia (IIT)
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


# Downloaded modules               CMake Version  string(APPEND)  CMakeParseArguments  Uncommitted
#                                  Version                        without include      Changes
#                                                 (req 3.4)
#  FeatureSummary                   3.1                            3.8
#  CMakePackageConfigHelpers        3.1                            3.8
#  FindPkgConfig                    3.1
#  ExternalProject                  3.3                                                 Yes
#  GNUInstallDirs                   3.4
#  FindGTK2                         3.5                            3.8
#  FindMatlab                       3.7
#  UseSWIG                          3.8            Yes             3.8
#  WriteBasicConfigVersionFile      3.11                                                Yes (CMAKE_ROOT)
#  CMakeParseArguments              ---                                                 Yes
#  FindGLEW                         ---                                                 Yes
#
# Changes in dependencies
#  FindPackageHandleStandardArgs                   3.7


################################################################################
# Files not available or containing bugs in CMake 3.1.3
# Imported from CMake tag v3.2.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.1)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.1. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.2.3
# Imported from CMake tag v3.3.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.2)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.2. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.3.2
# Imported from CMake tag v3.4.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.3)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.3. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.4 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               be2d273ed3c3559df71debc3f07fbe76a31dea28
             Modules/GNUInstallDirs.cmake                8afc4cc7af34df7f5b4e94b1d51c98e72cf553da)
  _ycm_cmake_next_download(v3.4.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.4" "${_files}")
  _ycm_cmake_next_install(v3.4.3 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.4"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.4.3
# Imported from CMake tag v3.5.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.4)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.4. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.5 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               4a4e319a92c005163903c4ae537669d0026bae7d
             Modules/FindGTK2.cmake                      49af0a4282a353269ad0e938775c594d0e1319c7
             Modules/SelectLibraryConfigurations.cmake   4d1ee73df6dadcb2e51f12059cf48f5e9165bb1e  # Used by FindGTK2
             Modules/FindPackageHandleStandardArgs.cmake 9a543ff079dc8e313f1dae812688f4be14e25134  # Used by FindGTK2
             Modules/FindPackageMessage.cmake            dbc69daf94e8a4039286f4ae6a8702af418b253a) # Used by FindPackageHandleStandardArgs

  # Since CMake 3.5, CMakeParseArguments.cmake was replaced by the
  # cmake_parse_arguments command and the file is empty, therefore we import
  # the older version for CMake 3.4 and earlier
  if(CMAKE_SUPPORTS_CMAKE_PARSE_ARGUMENTS OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/CMakeParseArguments.cmake           ed00144eafa83bd6653f3915456080265b54159b)  # Used by FindGTK2 and FindPackageHandleStandardArgs
  else()
    file(COPY v3.4.3/CMakeParseArguments.cmake
         DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5/Modules")
  endif()

  _ycm_cmake_next_download(v3.5.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5" "${_files}")
  _ycm_cmake_next_install(v3.5.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.5"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")

endif()


################################################################################
# Files not available or containing bugs in CMake 3.5.2
# Imported from CMake tag v3.6.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.5)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.5. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.6.3
# Imported from CMake tag v3.7.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.6)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.6. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.7 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               142359ab254d35db46c6d3d29a06d6cf2d570919
             Modules/FindMatlab.cmake                    fab238dfd6bc346af6cfbc4c0a3b7af48f19c09c)
  _ycm_cmake_next_download(v3.7.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.7" "${_files}")
  _ycm_cmake_next_install(v3.7.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.7"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.7.2
# Imported from CMake tag v3.8.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.7)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.7. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.7 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               510b21e4b3a70f0288bac0d89de8c333a36b159a
             Modules/FindSWIG.cmake                      dea8c36114b8fcd934118a0fc86c0641cd191c18  # Required to use this version of UseSWIG
             Modules/FindPackageMessage.cmake            68bfe02f96faabad103d59811b324d82d7c1d178) # Used by FindPackageHandleStandardArgs

  # Since CMake 3.7, FindPackageHandleStandardArgs uses string(APPEND)
  if(CMAKE_SUPPORTS_STRING_APPEND OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/FindPackageHandleStandardArgs.cmake 53300617d441f9cd08375a3599d15e6f60187441)  # Used by FindSWIG
  else()
    file(COPY v3.7.0/FindPackageHandleStandardArgs.cmake
         DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8/Modules")
  endif()

  # UseSWIG uses "string(APPEND)"
  if(CMAKE_SUPPORTS_STRING_APPEND OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/UseSWIG.cmake                       cf40cd32fdaa22c6c27887324983122ee9cde799)
  else()
    file(COPY master/UseSWIG.cmake
         DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8/Modules")
  endif()

  # Since CMake 3.5, CMakeParseArguments.cmake was replaced by the
  # cmake_parse_arguments command and the file is empty, therefore we import
  # the older version for CMake 3.4 and earlier
  if(CMAKE_SUPPORTS_CMAKE_PARSE_ARGUMENTS OR YCM_MAINTAINER_MODE)
    list(APPEND _files  Modules/CMakeParseArguments.cmake           eaf4dbce829d0eca5db28fc4b1a36b42f7948ad3) # Used by FindPackageHandleStandardArgs
  else()
    file(COPY v3.4.3/CMakeParseArguments.cmake
         DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8/Modules")
  endif()

  _ycm_cmake_next_download(v3.8.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8" "${_files}")
  _ycm_cmake_next_install(v3.8.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()



################################################################################
# Files not yet available or containing bugs in current CMake release (v3.10)
# Imported from latest revision tested

set(_ref 51ccfaacb88303bb2774cead91069e1c25888137)

if(NOT CMAKE_VERSION VERSION_LESS 3.11)
    # Just a reminder to update files when a new cmake version is released
    message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.11 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                                        17827332105eeec914e241e0a9c651690ae5b389
             Modules/BasicConfigVersion-SameMinorVersion.cmake.in 9f8a3d2e75026677375705fa008325d18d24c3d7)

  file(COPY v3.11.0/WriteBasicConfigVersionFile.cmake
       DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-next/Modules")

  _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_files}")
  _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-next"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()

################################################################################
# Files with patches not yet merged in CMake master

# Always installed
set(YCM_CMAKE_PROPOSED_FILES proposed/ExternalProject.cmake
                             proposed/CMakeParseArguments.cmake
                             proposed/FindGLEW.cmake)
set(YCM_CMAKE_PROPOSED_EXTRA_FILES  Copyright.txt # Must be redistributed together with CMake files
                                    README)       # Overwrite README generated by _ycm_cmake_next_download
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed/Modules")
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_EXTRA_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed")
