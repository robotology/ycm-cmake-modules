# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT


# Download and install files from CMake git, only if required

macro(_YCM_CMAKE_NEXT_DOWNLOAD _ref _dir _files)
    # loop over a list of file and sha1
    list(LENGTH _files _size)
    foreach(_i RANGE 1 ${_size} 2)
        math(EXPR _j "${_i} - 1")
        list(GET _files ${_j} _file)
        list(GET _files ${_i} _sha1)

        set(_src "http://cmake.org/gitweb?p=cmake.git;a=blob_plain;f=${_file};hb=${_ref}")
        set(_dest "${_dir}/${_file}")

        if(NOT EXISTS ${_dest})
            message(STATUS "Downloading file ${_file} from CMake git repository (ref ${_ref})")
            file(DOWNLOAD "${_src}" "${_dest}"
                 EXPECTED_HASH SHA1=${_sha1})
        endif()
        set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${_dest})
    endforeach()
    file(WRITE ${_dir}/README
"Files in this folder and its subfolder come from CMake git repository
(ref ${_ref}):

  git://cmake.org/cmake.git

They were imported exactly as they are on the original repository, in
order to supply the new features and bugfix available in newer releases
to user with older cmake releases.

These files are distributed under the OSI-approved BSD License;
see accompanying file Copyright.txt for details.
")
endmacro()


################################################################################
# Files not available or containing bugs in CMake 2.8.7
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.8)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 2.8.8. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 2.8.8)
    set(_files Copyright.txt                                cc156f64bf5196dfb35f7ae7a4081a434e128ef4
               Modules/CMakePackageConfigHelpers.cmake      ccb9c0f5c8abaa958f3049e001eeecfc9dc9ec43)
    _ycm_cmake_next_download(v2.8.8 ${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.8 ${_files})
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.8
            DESTINATION share/YCM)
endif()


################################################################################
# Files not available or containing bugs in CMake 2.8.11.2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 2.8.12. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 2.8.12)
    set(_files Copyright.txt                                cc156f64bf5196dfb35f7ae7a4081a434e128ef4
               Modules/SelectLibraryConfigurations.cmake    b0f24bea56e731e219506a1936c08817dc556d0a)
    _ycm_cmake_next_download(v2.8.12 ${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.12 ${_files})
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake-2.8.12
            DESTINATION share/YCM)
endif()


################################################################################
# Files not available or containing bugs in CMake 3.0.0-rc2
if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.0.0)
    # Just a reminder to remove this when we change cmake version
    message(AUTHOR_WARNING "CMake minimum required version greater than 3.0.0. You can remove this.")
endif()

# We assume that the user won't downgrade his cmake, therefore it's not
# necessary to download and install these files if already included in CMake
if(CMAKE_VERSION VERSION_LESS 3.0.0)

    set(_files Copyright.txt                               84889816c71a04e30e715b89faf10d72a7334839
               Modules/FindGTK2.cmake                      15657c7891807e028b05841e52bc57448a17701a
               Modules/FindFreetype.cmake                  b1a41d0d1321356beccc077495aa0d4c3d57e3a6
               Modules/SelectLibraryConfigurations.cmake   4d1ee73df6dadcb2e51f12059cf48f5e9165bb1e  # Used by FindGTK2
               Modules/CMakeParseArguments.cmake           00c393ca7dfd7f9ea9d1a5dc99702dcaffd289af  # Used by FindGTK2
               Modules/FindPackageHandleStandardArgs.cmake 6f694a4c8de523b14ce1dbc44c3f5942fc467fc1  # Used by FindGTK2
               Modules/FindPackageMessage.cmake            eceba493416b1ce30cecbbfad7d4835e80969195  # Used by FindPackageHandleStandardArgs
               Modules/GNUInstallDirs.cmake                af110b1c08d2ae909dd12b3dff3b8f9ed0f1c335
               Modules/FindArmadillo.cmake                 bd42719aff81dccb0730c0cc1e52aa2efad64d48)
    _ycm_cmake_next_download(v3.0.0-rc2 ${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0.0 ${_files})
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake-3.0.0
            DESTINATION share/YCM)
endif()


################################################################################
# Files not yet available or containing bugs in current CMake release (2.8.12.2)

# Latest revision tested
set(_ref 0f79dab48bf17e867fe19a7b7140fa7513f4b72d)

if(NOT CMAKE_VERSION VERSION_LESS 3.1.0)
    # Just a reminder to update files when a new cmake version is released
    message(AUTHOR_WARNING "CMake version is ${CMAKE_VERSION}. You should update this.")
endif()

# Always downloaded and installed until manually updated
set(_files Copyright.txt                               84889816c71a04e30e715b89faf10d72a7334839
           Modules/FindPkgConfig.cmake                 a5650a2a89acd93f6f78fd7846b88aad5fac5d0e
           Modules/FindPackageHandleStandardArgs.cmake 6f694a4c8de523b14ce1dbc44c3f5942fc467fc1  # Used by FindGTK2
           Modules/FindPackageMessage.cmake            eceba493416b1ce30cecbbfad7d4835e80969195) # Used by FindPackageHandleStandardArgs
_ycm_cmake_next_download(${_ref} ${CMAKE_CURRENT_BINARY_DIR}/cmake-next ${_files})
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake-next
        DESTINATION share/YCM)


################################################################################
# Files with patches not yet merged in CMake master


# Always installed
set(YCM_CMAKE_PROPOSED_FILES Modules/ExternalProject.cmake
                             Modules/CMakeParseArguments.cmake)
install(FILES ${YCM_CMAKE_PROPOSED_FILES} DESTINATION share/YCM/cmake-proposed/Modules)
install(FILES Copyright.txt # Must be redistributed together with CMake files
              README        # Overwrite README generated by _ycm_cmake_next_download
        DESTINATION share/YCM/cmake-proposed)
