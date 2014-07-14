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
# Download a file from given url and include it.  If ``DESTINATION`` is
# specified, the file is saved at the given location with the original
# file name, if ``<destination>`` is a directory, or with the given file
# name, if ``<destination>`` is a file name.  If not specified it will
# be saved with the original filename in
# ``${CMAKE_BINARY_DIR}/CMakeFiles``.
#
# If the ``DOWNLOAD_ONCE`` option is specified, the file is not
# downloaded if the file already exists.  Normally the file is
# downloaded at every CMake execution, but no error is raised if the
# download fails if a version of the file already exists, unless the
# ``DOWNLOAD_ALWAYS``.
#
# The arguments ``EXPECTED_HASH``, ``EXPECTED_MD5`` are used to ensure that the
# file included is the one expected. If the ``<url>`` is a local file (i.e.
# starts with ``file://``) the hash check is performed also on the file
# converted to the non-native end-of-line style.
#
# The arguments ``INACTIVITY_TIMEOUT``, ``TIMEOUT``, ``STATUS``, ``LOG``,
# ``SHOW_PROGRESS``, ``TLS_VERIFY``, and ``TLS_CAINFO`` are passed to the
# ``file(DOWNLOAD)`` command.  See the documentation of the ``file()``
# command for a detailed description of these arguments.
#
# The arguments ``OPTIONAL``, ``RESULT_VARIABLE``, and
# ``NO_POLICY_SCOPE`` are passed to the ``include()`` command.  See the
# documentation of the ``include()`` command for a detailed description
# of these arguments.

#=============================================================================
# Copyright 2013 iCub Facility, Istituto Italiano di Tecnologia
#   Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
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

# This must be a macro and not a function in order not to enclose in a
# new scope the variables added by the included files.
macro(INCLUDE_URL _remotefile)

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
                 QUIET
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
        # If the file is local, the hash check is disabled, since this could
        # fail because of different end of line styles
        if(DEFINED _IU_${_arg} AND NOT ("${_remotefile}" MATCHES "^file://" AND "${_arg}" MATCHES "^(EXPECTED_HASH|EXPECTED_MD5)$"))
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

        if(NOT _IU_QUIET)
            message(STATUS "Downloading ${_filename}")
        endif()
        file(DOWNLOAD ${_remotefile} ${_localfile} ${_downloadArgs})

        # Set the LOG and the STATUS variables if requested by the user
        if(DEFINED _IU_LOG)
            set(${_IU_LOG} ${${_IU_LOG}})
        endif()

        if(DEFINED _IU_STATUS)
            set(${_IU_STATUS} ${_downloadResult})
        endif()

        unset(_error_message)
        list(GET _downloadResult 0 _downloadResult_0)
        if(NOT _downloadResult_0 EQUAL 0)
            list(GET _downloadResult 1 _downloadResult_1)
            set(_error_message "Downloading ${_filename} - ERROR ${_downloadResult_0}: ${_downloadResult_1}")

        # BUG in CMake 2.8.12.2
        # CMake 2.8.12.2 or less does not give a fatal error if hash
        # of the downloaded file is wrong.
        # A new check is required in order not to include a "faulty"
        # file (it could be a security issue).
        elseif(DEFINED _IU_EXPECTED_HASH  OR  DEFINED _IU_EXPECTED_MD5)
            if(DEFINED _IU_EXPECTED_HASH)
                if("${_IU_EXPECTED_HASH}" MATCHES "^(.+)=([0-9a-fA-F]+)$")
                    set(_algo ${CMAKE_MATCH_1})
                    set(_expected_hash ${CMAKE_MATCH_2})
                else()
                    message(FATAL_ERROR "include_url EXPECTED_HASH expects ALGO=value but got: ${_IU_EXPECTED_HASH}")
                endif()
                if(NOT ${_algo} MATCHES "^(MD5|SHA1|SHA224|SHA256|SHA384|SHA512)$")
                    message(FATAL_ERROR "include_url EXPECTED_HASH given unknown ALGO: ${_algo}")
                endif()
            elseif(DEFINED _IU_EXPECTED_MD5)
                set(_algo MD5)
                set(_expected_hash ${_IU_EXPECTED_MD5})
            endif()

            file(${_algo} ${_localfile} _hash)
            if(NOT "${_hash}" STREQUAL "${_expected_hash}")
                set(_error_message
"include_url HASH mismatch
  for file: [${_localfile}]
    expected hash: [${_expected_hash}]
      actual hash: [${_hash}]
")
                if(NOT ("${_remotefile}" MATCHES "^file://" AND "${_arg}" MATCHES "^(EXPECTED_HASH|EXPECTED_MD5)$"))
                    file(READ ${_localfile} _tmp)
                    # Switch to the non-native end-of-line style and check again
                    if(WIN32)
                        string(REPLACE "/r/n" "/n" _tmp "${_tmp}")
                    else()
                        string(REPLACE "/n" "/r/n" _tmp "${_tmp}")
                    endif()
                    string(${_algo} _hash2 "${_tmp}")
                    if("${_hash2}" STREQUAL "${_expected_hash}")
                        # This is the same file but with changed end-of-line
                        # Do not print the error message
                        unset(_error_message)
                    endif()
                endif()
            endif()
        endif()
        if(DEFINED _error_message)
            if(_shouldFail  OR  NOT EXISTS ${_tmpFile})
                # Remove the faulty file to be sure that we'll never include it
                file(REMOVE ${_localfile})
                message(FATAL_ERROR ${_error_message})
            else()
                message(STATUS ${_error_message})
            endif()
        else()
            if(NOT _IU_QUIET)
                message(STATUS "Downloading ${_filename} - SUCCESS")
            endif()
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
        set(${_IU_RESULT_VARIABLE} ${${_IU_RESULT_VARIABLE}})
    endif()

endmacro()
