# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

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
    set(_offline_dest "${YCM_SOURCE_DIR}/downloads/cmake-${_ref}/${_file}")

    if(EXISTS "${_offline_dest}")
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_offline_dest}" "${_orig_dest}")
    endif()

    if(NOT EXISTS "${_orig_dest}")
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


# Downloaded modules               CMake Version   Uncommitted
#                                                  Changes
#
#  FindDoxygen                      3.13
#  WriteBasicConfigVersionFile      3.14            Yes (CMAKE_ROOT)
#  FindSWIG                         3.14.7
#  UseSWIG                          3.14.7          Yes (Policies)
#  FindGLEW                         3.15
#  CMakeParseArguments              ---             Yes
#
# Changes in dependencies
#  FindPackageHandleStandardArgs

# NOTE: keep CMake version values listed at root/YCMConfig.cmake.in up
# to date with changes in the previous table.


################################################################################
# Files not available or containing bugs in CMake 3.12.4
# Imported from CMake tag v3.13.5
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_GREATER_EQUAL 3.13)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.12. You can remove this.")
endif()

if(CMAKE_VERSION VERSION_LESS 3.13 OR YCM_MAINTAINER_MODE)

  set(_ref v3.13.5)
  set(_files Copyright.txt                               96563e603328872bc22d31a3445e23b438292751
             Modules/FindDoxygen.cmake                   5aa0b1f8cd5d4886da37fa8164be9d30bc196b82
             Modules/FindPackageHandleStandardArgs.cmake 97e455f2849eac8ef1449cba5e49064149bd2099  # Used by FindDoxygen
             Modules/FindPackageMessage.cmake            68bfe02f96faabad103d59811b324d82d7c1d178  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           eaf4dbce829d0eca5db28fc4b1a36b42f7948ad3) # Used by FindPackageHandleStandardArgs

  _ycm_cmake_next_download(v3.13.5 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.13" "${_files}")
  _ycm_cmake_next_install(v3.13.5 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.13"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.13.5
# Imported from CMake tag v3.14.7
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_GREATER_EQUAL 3.14)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.13. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.14 OR YCM_MAINTAINER_MODE)

  set(_ref v3.14.7)
  set(_files Copyright.txt                                        ef5e9cd05a459b23263ecc409da2b3bc51aec2e4
             Modules/BasicConfigVersion-SameMajorVersion.cmake.in f89dc13283012256d1cb702ffb0bc235cee5cc5a
             Modules/BasicConfigVersion-SameMinorVersion.cmake.in a3e9f395d5ce5c66eb5b3fa8df2e9dfa8548562e
             Modules/BasicConfigVersion-ExactVersion.cmake.in     c723920559d6f22af6a7d5f10deb26b4c170773d
             Modules/BasicConfigVersion-AnyNewerVersion.cmake.in  fb0c14d1c39a46d856a18bec3430c45045f29a45
             Modules/CMakePackageConfigHelpers.cmake              e85b785df2000c4524b44ae735112f795dd2e219  # Required to be in the same folder as WriteBasicConfigVersionFile
             Modules/FindSWIG.cmake                               2ed683e758d9caa88f0b11f8814617c1179de3ce
             Modules/FindPackageHandleStandardArgs.cmake          97e455f2849eac8ef1449cba5e49064149bd2099  # Used by FindSWIG
             Modules/FindPackageMessage.cmake                     a3207b9d2996e4c5a2ecb254f9abf1e4ba037f0a  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake                    79a086a72f0ea821e2587ac96df080703a614108) # Used by FindPackageHandleStandardArgs

  file(COPY v3.14/WriteBasicConfigVersionFile.cmake
            v3.14/UseSWIG.cmake
       DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14/Modules")

  # The files CMakePackageConfigHelpers.cmake and
  # BasicConfigVersion-AnyNewerVersion.cmake.in are downloaded, but are also
  # used by WriteBasicConfigVersionFile in YCM main CMakeLists.txt, therefore
  # they should all be in the same directory (${_ref})

  _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14" "${_files}")
  _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.14.7
# Imported from CMake tag v3.15.7
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_GREATER_EQUAL 3.14)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.13. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.15 OR YCM_MAINTAINER_MODE)

  set(_ref v3.15.7)
  set(_files Copyright.txt                               ef5e9cd05a459b23263ecc409da2b3bc51aec2e4
             Modules/FindGLEW.cmake                      2eaf07f660491dd3db44b0801292f8dabb627ce0
             Modules/FindPackageHandleStandardArgs.cmake 97e455f2849eac8ef1449cba5e49064149bd2099  # Used by FindGLEW
             Modules/FindPackageMessage.cmake            a3207b9d2996e4c5a2ecb254f9abf1e4ba037f0a  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           79a086a72f0ea821e2587ac96df080703a614108  # Used by FindPackageHandleStandardArgs
             Modules/SelectLibraryConfigurations.cmake   423e51063f8df2286ca8a693c2cbc6c3e12ec61f) # Used by FindGLEW

  _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.15" "${_files}")
  _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.15"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()



################################################################################
# Files not yet available or containing bugs in current CMake release (v3.15.7)
# Imported from latest revision tested

# None

# if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
#     # Just a reminder to update files when a new cmake version is released
#     message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
# endif()

# set(_ref f3ba8bf4024592fd7e09c1425258e67953839040)
# set(_files Copyright.txt                               ef5e9cd05a459b23263ecc409da2b3bc51aec2e4)
#
# _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_files}")
# _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-next"
#                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")


################################################################################
# Files with patches not yet merged in CMake master

# Always installed
set(YCM_CMAKE_PROPOSED_FILES proposed/ExternalProject.cmake
                             proposed/CMakeParseArguments.cmake)
set(YCM_CMAKE_PROPOSED_EXTRA_FILES  Copyright.txt # Must be redistributed together with CMake files
                                    README)       # Overwrite README generated by _ycm_cmake_next_download
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed/Modules")
_ycm_cmake_next_install(proposed FILES ${YCM_CMAKE_PROPOSED_EXTRA_FILES}
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}/cmake-proposed")
