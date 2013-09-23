# Files from CMake git, available only if required


################################################################################
# Files not available in CMake 2.8.7
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.8)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 2.8.8. You can remove this.")
endif()

set(YCM_CMAKE_2_8_8_FILES Modues/CMakePackageConfigHelpers.cmake)
if(CMAKE_VERSION VERSION_LESS 2.8.8)
    # We assume that the user won't downgrade his cmake, therefore it's not
    # necessary to install these files
    install(FILES ${YCM_CMAKE_NEXT_FILES}
            DESTINATION share/YCM/cmake-2.8.8/Modules)
endif()


################################################################################
# Files not yet available in current CMake release (2.8.12)
if(NOT CMAKE_VERSION VERSION_LESS 2.8.13)
    # Just a reminder to update files when a new cmake version is released
    message(AUTHOR_WARNING "A CMake version greater than 2.8.13. You should update this.")
endif()

set(YCM_CMAKE_NEXT_FILES Modules/FindGTK2.cmake
                         Modules/FindPackageHandleStandardArgs.cmake
                         Modules/FindPackageMessage.cmake
                         Modules/CMakeParseArguments.cmake
                         Modules/SelectLibraryConfigurations.cmake
                         Modules/FindFreetype.cmake)
# always installed
install(FILES ${YCM_CMAKE_NEXT_FILES}
        DESTINATION share/YCM/cmake-next/Modules)
