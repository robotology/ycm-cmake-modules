#.rst:
# IncludeUrl
# ----------
#
# Download a file from given url and include it.
#
#
# ::
#
#  include_url(<url>                 # Url to be downloaded
#     [DESTINATION <destination>     # Where the file will be saved
#     [DOWNLOAD_ONCE]                # Download the file only once
#     [DOWNLOAD_ALWAYS]              # Download the file every time
#    #--Download arguments-----------
#     [INACTIVITY_TIMEOUT <timeout>] # Timeout after <timeout> seconds of inactivity
#     [TIMEOUT <timeout>]            # Timeout after <timeout> seconds
#     [STATUS <status>]              # Download status variable
#     [LOG <log>]                    # Download log variable
#     [SHOW_PROGRESS]                # Show download progress
#     [EXPECTED_HASH <ALGO=value>]   # Verify downloaded file's hash
#     [EXPECTED_MD5 <sum>]           # Short-hand for "EXPECTED_HASH MD5=sum"
#     [TLS_VERIFY <on|off>]          # Check certificates
#     [TLS_CAINFO <file>]            # Custom Certificate Authority file
#    #--Include arguments------------
#     [OPTIONAL]                     # Do not fail file cannot be included
#     [RESULT_VARIABLE <variable>]   # The local path for the file included
#     [NO_POLICY_SCOPE]              # Do not manage a new policy entry
#     )
#
# Download a file from given url and include it. If DESTINATION is specified,
# the file is saved at the given location with the original file name, if
# <destination> is a directory, or with the given file name, if <destination> is
# a file name. If not specified it will be saved with the original filename in
# ${CMAKE_BINARY_DIR}/CMakeFiles.
#
# If the DOWNLOAD_ONCE option is specified, the file is not downloaded if the
# file already exists. Normally the file is downloaded at every CMake execution,
# but no error is raised if the download fails if a version of the file already
# exists, unless the DOWNLOAD_ALWAYS.
#
# The arguments INACTIVITY_TIMEOUT, TIMEOUT, STATUS, LOG, SHOW_PROGRESS,
# EXPECTED_HASH, EXPECTED_MD5, TLS_VERIFY, and TLS_CAINFO are passed to the
# "file(DOWNLOAD)" command. See the documentation of the "file" command for a
# detailed description of these arguments.
#
# The arguments OPTIONAL, RESULT_VARIABLE, and NO_POLICY_SCOPE are passed to the
# "include" command. See the documentation of the "include" command for a
# detailed description of these arguments.

#=============================================================================
# Copyright 2013  iCub Facility, Istituto Italiano di Tecnologia
#     @author Daniele E. Domenichelli <daniele.domenichelli@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)


if(DEFINED __INCLUDE_URL_INCLUDED)
  return()
endif()
set(__INCLUDE_URL_INCLUDED TRUE)


include(CMakeParseArguments)

function(INCLUDE_URL _remotefile)

    set(_downloadOptions SHOW_PROGRESS)
    set(_downloadOneValueArgs INACTIVITY_TIMEOUT
                              TIMEOUT
                              LOG
                              EXPECTED_HASH
                              EXPECTED_MD5
                              TLS_VERIFY
                              TLS_CAINFO)
    set(_includeOptions NO_POLICY_SCOPE)
    set(_includeOneValueArgs RESULT_VARIABLE)

    set(_options DOWNLOAD_ONCE
                 DOWNLOAD_ALWAYS
                 ${_downloadOptions}
                 ${_includeOptions})
    set(_oneValueArgs DESTINATION
                      STATUS
                      OPTIONAL
                      ${_downloadOneValueArgs}
                      ${_includeOneValueArgs})
    set(_multiValueArgs )

    cmake_parse_arguments(_IU "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")

    if(DEFINED _IU_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown arguments:\n  ${_IU_UNPARSED_ARGUMENTS}\n")
    endif()

    if(_IU_DOWNLOAD_ONCE AND _IU_DOWNLOAD_ALWAYS)
        message(FATAL_ERROR "DOWNLOAD_ONCE and DOWNLOAD_ALWAYS cannot be specified at the same time")
    endif()

    get_filename_component(_filename ${_remotefile} NAME)
    if(DEFINED _IU_DESTINATION)
        if(IS_DIRECTORY ${_IU_DESTINATION})
            set(_localfile ${_IU_DESTINATION}/${_filename})
        else()
            set(_localfile ${_IU_DESTINATION})
        endif()
    else()
        set(_localfile ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_filename})
        set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${_localfile})
    endif()
    set(_tmpDir ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/)
    set(_tmpFile ${_tmpDir}${_filename})

    set(_downloadArgs STATUS _downloadResult)
    foreach(_arg ${_downloadOptions})
        if(_IU_${_arg})
            list(APPEND _downloadArgs ${_arg})
        endif()
    endforeach()
    foreach(_arg STATUS ${_downloadOneValueArgs})
        if(DEFINED _IU_${_arg})
            list(APPEND _downloadArgs ${_arg} ${_IU_${_arg}})
        endif()
    endforeach()

    set(_includeArgs )
    foreach(_arg OPTIONAL ${_includeOptions})
        if(_IU_${_arg})
            list(APPEND _includeArgs ${_arg})
        endif()
    endforeach()
    foreach(_arg ${_includeOneValueArgs})
        if(DEFINED _IU_${_arg})
            list(APPEND _includeArgs ${_arg} ${_IU_${_arg}})
        endif()
    endforeach()

    if(NOT EXISTS ${_localfile} OR _IU_DOWNLOAD_ALWAYS)
        set(_shouldDownload 1)
        set(_shouldFail 1)
    elseif(_IU_DOWNLOAD_ONCE)
        set(_shouldDownload 0)
        set(shouldFail 0)
    else()
        set(_shouldDownload 1)
        set(_shouldFail 0)
    endif()

    if(_shouldDownload)
        if(EXISTS ${_localfile})
            file(MAKE_DIRECTORY ${_tmpDir})
            file(RENAME ${_localfile} ${_tmpFile})
        endif()

        message(STATUS "Downloading ${_filename}")
        file(DOWNLOAD ${_remotefile} ${_localfile} ${_downloadArgs})

        # Set the LOG and the STATUS variables if requested by the user
        if(DEFINED _IU_LOG)
            set(${_IU_LOG} ${${_IU_LOG}} PARENT_SCOPE)
        endif()

        if(DEFINED _IU_STATUS)
            set(${_IU_STATUS} ${_downloadResult} PARENT_SCOPE)
        endif()

        list(GET _downloadResult 0 _downloadResult_0)
        if(NOT _downloadResult_0 EQUAL 0)
            list(GET _downloadResult 1 _downloadResult_1)
            set(_message "Downloading ${_filename} - ERROR ${_downloadResult_0}: ${_downloadResult_1}")
            if(_shouldFail OR NOT EXISTS ${_tmpFile})
                message(FATAL_ERROR ${_message})
            else()
                message(STATUS ${_message})
            endif()
        else()
            message(STATUS "Downloading ${_filename} - SUCCESS")
        endif()

        if(EXISTS ${_tmpFile})
            if(NOT EXISTS ${_localfile})
                file(RENAME ${_tmpFile} ${_localfile})
            else()
                file(REMOVE ${_tmpFile})
            endif()
        endif()
    endif()

    include(${_localfile} ${_includeArgs})

    # Set the RESULT_VARIABLE variable if requested by the user
    if(DEFINED _IU_RESULT_VARIABLE)
        set(${_IU_RESULT_VARIABLE} ${${_IU_RESULT_VARIABLE}} PARENT_SCOPE)
    endif()

endfunction()
