cmake_minimum_required(VERSION 2.8.7)
project(yarp-cmake-modules NONE)

set(YCM_MAJOR_VERSION 0)
set(YCM_MINOR_VERSION 0)
set(YCM_PATCH_VERSION 1)
set(YCM_VERSION ${YCM_MAJOR_VERSION}.${YCM_MINOR_VERSION}.${YCM_PATCH_VERSION})

set(YCM_BUILD_MODULE_DIR ${CMAKE_SOURCE_DIR})
set(YCM_INSTALL_MODULE_DIR "${CMAKE_INSTALL_PREFIX}/share/YCM")

add_subdirectory(modules)
add_subdirectory(find-modules)
add_subdirectory(build-modules)
add_subdirectory(deprecated)
add_subdirectory(cmake-next)

list(APPEND CMAKE_MODULE_PATH "${YCM_BUILD_MODULE_DIR}/modules")

include(CMakePackageConfigHelpers)
include(MacroUninstallTarget)

# YCMConfigVersion.cmake file (same for build tree and intall)
write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/YCMConfigVersion.cmake
                                 VERSION ${YCM_VERSION}
                                 COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/YCMConfigVersion.cmake
        DESTINATION ${YCM_INSTALL_MODULE_DIR}/cmake)

# YCMConfig.cmake (build tree)
set(PACKAGE_YCM_MODULE_DIR "${CMAKE_SOURCE_DIR}/cmake")
configure_package_config_file(YCMConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/YCMConfig.cmake
                              INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
                              PATH_VARS YCM_BUILD_MODULE_DIR)

# YCMConfig.cmake (installed)
set(PACKAGE_YCM_MODULE_DIR "${YCM_INSTALL_MODULE_DIR}")
configure_package_config_file(YCMConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/YCMConfigInstall.cmake
                              INSTALL_DESTINATION ${YCM_INSTALL_MODULE_DIR}
                              PATH_VARS YCM_INSTALL_MODULE_DIR)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/YCMConfigInstall.cmake
        DESTINATION ${YCM_INSTALL_MODULE_DIR}/cmake
        RENAME YCMConfig.cmake)

macro_uninstall_target(YCM)
