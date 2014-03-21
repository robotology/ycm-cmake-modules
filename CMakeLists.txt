cmake_minimum_required(VERSION 2.8.7)
project(YCM NONE)

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

# CMakePackageConfigHelpers is not available in CMake 2.8.7
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.8)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 2.8.8. You can remove this.")
endif()
if(CMAKE_VERSION VERSION_LESS 2.8.8)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/cmake-next/cmake-2.8.8/Modules") # For CMakePackageConfigHelpers.cmake
endif()

include(CMakePackageConfigHelpers)

# YCMConfigVersion.cmake file (same for build tree and intall)
write_basic_package_version_file(${CMAKE_BINARY_DIR}/YCMConfigVersion.cmake
                                 VERSION ${YCM_VERSION}
                                 COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_BINARY_DIR}/YCMConfigVersion.cmake
        DESTINATION ${YCM_INSTALL_MODULE_DIR}/cmake)

# YCMConfig.cmake (build tree)
set(PACKAGE_YCM_MODULE_DIR "${CMAKE_SOURCE_DIR}/cmake")
configure_package_config_file(YCMConfig.cmake.in ${CMAKE_BINARY_DIR}/YCMConfig.cmake
                              INSTALL_DESTINATION ${CMAKE_BINARY_DIR}
                              PATH_VARS YCM_BUILD_MODULE_DIR)

# YCMConfig.cmake (installed)
set(PACKAGE_YCM_MODULE_DIR "${YCM_INSTALL_MODULE_DIR}")
configure_package_config_file(YCMConfig.cmake.in ${CMAKE_BINARY_DIR}/YCMConfigInstall.cmake
                              INSTALL_DESTINATION ${YCM_INSTALL_MODULE_DIR}
                              PATH_VARS YCM_INSTALL_MODULE_DIR)

install(FILES ${CMAKE_BINARY_DIR}/YCMConfigInstall.cmake
        DESTINATION ${YCM_INSTALL_MODULE_DIR}/cmake
        RENAME YCMConfig.cmake)

include(AddUninstallTarget)

add_custom_target(update-sha1sums
                  COMMAND ${CMAKE_SOURCE_DIR}/tools/update_sha1sums.sh)
