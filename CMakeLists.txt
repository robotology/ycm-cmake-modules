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


cmake_minimum_required(VERSION 2.8.9)
project(YCM NONE)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/internal-modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules")

include(YCMVersion)
include(YCMInternal)

if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
    option(YCM_MAINTAINER_MODE "Enable maintainer mode (download all files and enable CPack)" FALSE)
    mark_as_advanced(YCM_MAINTAINER_MODE)
endif()

if(YCM_MAINTAINER_MODE)
    if(NOT EXISTS "${CMAKE_SOURCE_DIR}/.git")
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
add_subdirectory(docs)

# Use the new CMakePackageConfigHelpers from CMake repository in order to use
# the new INSTALL_PREFIX argument for configure_package_config_file
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.1)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 3.1. You can remove this.")
endif()
if(CMAKE_VERSION VERSION_LESS 3.1)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/cmake-next/cmake-3.1/Modules")
endif()
include(CMakePackageConfigHelpers)

# YCMConfigVersion.cmake file (same for build tree and intall)
write_basic_package_version_file("${YCM_BUILD_CMAKE_DIR}/YCMConfigVersion.cmake"
                                 VERSION ${YCM_VERSION}
                                 COMPATIBILITY AnyNewerVersion)
install(FILES "${YCM_BUILD_CMAKE_DIR}/YCMConfigVersion.cmake"
        DESTINATION "${YCM_INSTALL_CMAKE_DIR}")

# YCMConfig.cmake (build tree)
get_filename_component(YCM_MODULE_DIR "${YCM_BUILD_MODULE_DIR}" ABSOLUTE)
configure_package_config_file(YCMConfig.cmake.in "${YCM_BUILD_CMAKE_DIR}/YCMConfig.cmake"
                              INSTALL_DESTINATION "${YCM_BUILD_CMAKE_DIR}"
                              PATH_VARS YCM_MODULE_DIR
                              NO_CHECK_REQUIRED_COMPONENTS_MACRO
                              INSTALL_PREFIX "${CMAKE_BINARY_DIR}")

# YCMConfig.cmake (installed)
get_filename_component(YCM_MODULE_DIR "${CMAKE_INSTALL_PREFIX}/${YCM_INSTALL_MODULE_DIR}" ABSOLUTE)
configure_package_config_file(YCMConfig.cmake.in "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/YCMConfigInstall.cmake"
                              INSTALL_DESTINATION "${CMAKE_INSTALL_PREFIX}/${YCM_INSTALL_CMAKE_DIR}"
                              PATH_VARS YCM_MODULE_DIR
                              NO_CHECK_REQUIRED_COMPONENTS_MACRO)

install(FILES "${CMAKE_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/YCMConfigInstall.cmake"
        DESTINATION "${YCM_INSTALL_CMAKE_DIR}"
        RENAME YCMConfig.cmake)

include(AddUninstallTarget)

if(UNIX)
    # update-sha1sums target makes no sense on windows, since the .sh script
    # will fail to execute
    add_custom_target(update-sha1sums
                      COMMAND "${CMAKE_SOURCE_DIR}/tools/update_sha1sums.sh")
endif()

enable_testing()
include(CTest)
# Set up test-time configuration.
set_directory_properties(PROPERTIES TEST_INCLUDE_FILE "${CMAKE_BINARY_DIR}/tests/EnforceConfig.cmake")

add_subdirectory(tests)
