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
#  FindMatlab                       3.7
#  FeatureSummary                   3.8
#  UseSWIG                          3.8
#  FindDoxygen                      3.9
#  FindOpenGL                       3.10
#  FindPython                       3.12
#  FindPython/Support               3.12
#  FindPython2                      3.12
#  FindPython3                      3.12
#  WriteBasicConfigVersionFile      3.14            Yes (CMAKE_ROOT)
#  FindGLEW                         3.15
#  CMakeParseArguments              ---             Yes
#
# Changes in dependencies
#  FindPackageHandleStandardArgs

# NOTE: keep CMake version values listed at root/YCMConfig.cmake.in up
# to date with changes in the previous table.


################################################################################
# Files not available or containing bugs in CMake 3.5.2
# Imported from CMake tag v3.6.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.6)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.5. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.6.3
# Imported from CMake tag v3.7.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.7)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.6. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
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
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.8)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.7. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.8 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               510b21e4b3a70f0288bac0d89de8c333a36b159a
             Modules/UseSWIG.cmake                       cf40cd32fdaa22c6c27887324983122ee9cde799
             Modules/FindSWIG.cmake                      dea8c36114b8fcd934118a0fc86c0641cd191c18  # Required to use this version of UseSWIG
             Modules/FindPackageHandleStandardArgs.cmake 53300617d441f9cd08375a3599d15e6f60187441  # Used by FindSWIG
             Modules/FindPackageMessage.cmake            68bfe02f96faabad103d59811b324d82d7c1d178  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           eaf4dbce829d0eca5db28fc4b1a36b42f7948ad3) # Used by FindPackageHandleStandardArgs

  _ycm_cmake_next_download(v3.8.2 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8" "${_files}")
  _ycm_cmake_next_install(v3.8.2 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.8"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.8.2
# Imported from CMake tag v3.9.6
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.9)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.8. You can remove this.")
endif()

if(CMAKE_VERSION VERSION_LESS 3.9 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               bfef1cd1e93d828699f2ceac1224a60c1a17a59a
             Modules/FindDoxygen.cmake                   04c149a2f570c19c8764547abad0f55312945ba7
             Modules/FindPackageHandleStandardArgs.cmake db0ca94cc4270ab386b3182f21ad7c01f7f7d604  # Used by FindDoxygen
             Modules/FindPackageMessage.cmake            68bfe02f96faabad103d59811b324d82d7c1d178  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           eaf4dbce829d0eca5db28fc4b1a36b42f7948ad3) # Used by FindPackageHandleStandardArgs

  _ycm_cmake_next_download(v3.9.6 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.9" "${_files}")
  _ycm_cmake_next_install(v3.9.6 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.9"
                                 DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()



################################################################################
# Files not available or containing bugs in CMake 3.9.6
# Imported from CMake tag v3.10.3
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.10)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.9. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.10 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                               17827332105eeec914e241e0a9c651690ae5b389
             Modules/FindOpenGL.cmake                    f4955a22a1f365f763506e6229c1eea5eea5b279
             Modules/FindPackageHandleStandardArgs.cmake 286ff571e093a25caaa4d2390d3b9729bc5ff44d  # Used by FindOpenGL
             Modules/FindPackageMessage.cmake            68bfe02f96faabad103d59811b324d82d7c1d178  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           eaf4dbce829d0eca5db28fc4b1a36b42f7948ad3) # Used by FindPackageHandleStandardArgs

  _ycm_cmake_next_download(v3.10.3 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.10" "${_files}")
  _ycm_cmake_next_install(v3.10.3 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.10"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.10.3
# Imported from CMake tag v3.11.4
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.11)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.10. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.11 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                                        adb9e42eb50d36c7934d78bc339214d1600f8cb3
             Modules/FetchContent.cmake                           a4a1f9ddcc762d7707544b8ecbed5659364d9df2
             Modules/FetchContent/CMakeLists.cmake.in             ddd8d6dfbe5665c770d7e6f8b4dcaac85cff3c44)

  _ycm_cmake_next_download(v3.11.4 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.11" "${_files}")
  _ycm_cmake_next_install(v3.11.4 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.11"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.11.4
# Imported from CMake tag v3.12.4
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.12)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.11. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.12 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                                        96563e603328872bc22d31a3445e23b438292751
             Modules/FindPython.cmake                             b55c8a5e7e32efa98c0a86f1e45e6498a13cb828
             Modules/FindPython/Support.cmake                     898f3255348384a03be0d0cab19b42af513b3440
             Modules/FindPython2.cmake                            b79f69806d150c759be0504e4a8f2e54553e9330
             Modules/FindPython3.cmake                            aaa31c35f5167b385018f0863676ac4baf9b22e2
             Modules/CMakeFindFrameworks.cmake                    053fd8fd4bb7bc08fb6595b0a212de097a86084f  # Used by FindPython/Support.cmake
             Modules/FindPackageHandleStandardArgs.cmake          286ff571e093a25caaa4d2390d3b9729bc5ff44d  # Used by FindPython/Support.cmake
             Modules/FindPackageMessage.cmake                     68bfe02f96faabad103d59811b324d82d7c1d178  # Used by FindPackageHandleStandardArgs
             Modules/SelectLibraryConfigurations.cmake            e09bf3cd3f1faa1f9cc8f5924216a7fe3e4594d4) # Used by FindPython/Support.cmake

  _ycm_cmake_next_download(v3.12.4 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.12" "${_files}")
  _ycm_cmake_next_install(v3.12.4 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.12"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not available or containing bugs in CMake 3.12.4
# Imported from CMake tag v3.13.0
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.13)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.12. You can remove this.")
endif()

# None


################################################################################
# Files not available or containing bugs in CMake 3.13.4
# Imported from CMake tag v3.14.0
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.14)
  # Just a reminder to remove this when we change cmake version
  message(AUTHOR_WARNING "CMake minimum required version greater than 3.13. You can remove this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.14 OR YCM_MAINTAINER_MODE)

  set(_files Copyright.txt                                        ef5e9cd05a459b23263ecc409da2b3bc51aec2e4
             Modules/BasicConfigVersion-SameMajorVersion.cmake.in f89dc13283012256d1cb702ffb0bc235cee5cc5a
             Modules/BasicConfigVersion-SameMinorVersion.cmake.in a3e9f395d5ce5c66eb5b3fa8df2e9dfa8548562e
             Modules/BasicConfigVersion-ExactVersion.cmake.in     c723920559d6f22af6a7d5f10deb26b4c170773d
             Modules/BasicConfigVersion-AnyNewerVersion.cmake.in  fb0c14d1c39a46d856a18bec3430c45045f29a45
             Modules/CMakePackageConfigHelpers.cmake              e85b785df2000c4524b44ae735112f795dd2e219) # Required to be in the same folder as WriteBasicConfigVersionFile

  file(COPY v3.14.0/WriteBasicConfigVersionFile.cmake
       DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14/Modules")

  # The files CMakePackageConfigHelpers.cmake and
  # BasicConfigVersion-AnyNewerVersion.cmake.in are downloaded, but are also
  # used by WriteBasicConfigVersionFile in YCM main CMakeLists.txt, therefore
  # they should all be in the same directory (v3.14.0)

  _ycm_cmake_next_download(v3.14.0 "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14" "${_files}")
  _ycm_cmake_next_install(v3.14.0 DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-3.14"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()


################################################################################
# Files not yet available or containing bugs in current CMake release (v3.14.0)
# Imported from latest revision tested
if(NOT CMAKE_VERSION VERSION_LESS 3.15)
    # Just a reminder to update files when a new cmake version is released
    message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
endif()

# We assume that the user won't downgrade his CMake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.15 OR YCM_MAINTAINER_MODE)

  set(_ref 52fb35bd69ec2fa1a5307695cb22c3f125debf4f)
  set(_files Copyright.txt                               ef5e9cd05a459b23263ecc409da2b3bc51aec2e4
             Modules/FindGLEW.cmake                      bece2c0fdd415f49d6b6d22da274dd8a9c248853
             Modules/FindPackageHandleStandardArgs.cmake 97e455f2849eac8ef1449cba5e49064149bd2099  # Used by FindGLEW
             Modules/FindPackageMessage.cmake            a3207b9d2996e4c5a2ecb254f9abf1e4ba037f0a  # Used by FindPackageHandleStandardArgs
             Modules/CMakeParseArguments.cmake           79a086a72f0ea821e2587ac96df080703a614108  # Used by FindPackageHandleStandardArgs
             Modules/SelectLibraryConfigurations.cmake   423e51063f8df2286ca8a693c2cbc6c3e12ec61f) # Used by FindGLEW

  _ycm_cmake_next_download(${_ref} "${CMAKE_CURRENT_BINARY_DIR}/cmake-next" "${_files}")
  _ycm_cmake_next_install(${_ref} DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/cmake-next"
                                  DESTINATION "${YCM_INSTALL_MODULE_DIR}")
endif()

# None

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
