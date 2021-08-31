# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause


cmake_minimum_required(VERSION 3.16)
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
