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


cmake_minimum_required(VERSION 3.5)
project(YCM NONE)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/internal-modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/modules")

include(YCMVersion)
include(YCMInternal)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
  option(YCM_MAINTAINER_MODE "Enable maintainer mode (download all files and enable CPack) - Latest CMake version is recommended" FALSE)
  mark_as_advanced(YCM_MAINTAINER_MODE)
endif()

if(YCM_MAINTAINER_MODE)
  if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    message(WARNING "Cannot enable maintainer mode outside a git repository. The YCM_MAINTAINER_MODE option will be disabled.")
    unset(YCM_MAINTAINER_MODE)
    unset(YCM_MAINTAINER_MODE CACHE)
  else()
    include(YCMPack)
  endif()
endif()

include(GNUInstallDirs)

set(YCM_BUILD_MODULE_DIR "${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_DATADIR}/YCM")
set(YCM_INSTALL_MODULE_DIR "${CMAKE_INSTALL_DATADIR}/YCM")

set(YCM_BUILD_CMAKE_DIR "${CMAKE_BINARY_DIR}")
set(YCM_INSTALL_CMAKE_DIR "${CMAKE_INSTALL_DATADIR}/YCM/cmake")


# FIXME
set(YCM_DOC_DIR ${CMAKE_INSTALL_DOCDIR})
set(YCM_MAN_DIR ${CMAKE_INSTALL_MANDIR})

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

add_subdirectory(modules)
add_subdirectory(find-modules)
add_subdirectory(cmake-next)
add_subdirectory(3rdparty)
add_subdirectory(deprecated)
add_subdirectory(build-modules)
add_subdirectory(style-modules)
add_subdirectory(docs)

# Use the new CMakePackageConfigHelpers from CMake repository in order to use
# the new ARCH_INDEPENDENT argument for write_basic_package_version_file
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.14)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 3.14. You can remove this.")
endif()
if(CMAKE_VERSION VERSION_LESS 3.14)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake-next/v3.14.4")
endif()
include(CMakePackageConfigHelpers)

include(InstallBasicPackageFiles)
install_basic_package_files(YCM
                            VERSION ${YCM_VERSION}
                            COMPATIBILITY AnyNewerVersion
                            ARCH_INDEPENDENT
                            NO_EXPORT
                            EXTRA_PATH_VARS_SUFFIX MODULE_DIR
                            NO_CHECK_REQUIRED_COMPONENTS_MACRO)

include(AddUninstallTarget)

if(UNIX)
  # update-sha1sums target makes no sense on windows, since the .sh script
  # will fail to execute
  add_custom_target(update-sha1sums
                    COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/tools/update_sha1sums.sh")
endif()

enable_testing()
include(CTest)

add_subdirectory(tests)
