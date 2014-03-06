# YCM_EP_HELPER(<name>
#    [DOCS]
#    [TYPE <type>]
#    [STYLE <style>]
#    [COMPONENT <component>] (default = "external")
#    [REPOSITORY <repo>]
#    [EXCLUDE_FROM_ALL <0|1>]
#   #--Git only arguments-----------
#    [TAG <tag>]
#   #--Svn only arguments-----------
#    [REVISION <revision>]
#    [USERNAME <username>]
#    [PASSWORD <password>]
#    [TRUST_CERT <0|1>]
#   #--CMake arguments---------
#    [CMAKE_ARGS]
#    [CMAKE_CACHE_ARGS]
#    [DEPENDS]
#    [DOWNLOAD_COMMAND]
#    [UPDATE_COMMAND]
#    [PATCH_COMMAND]
#    [CONFIGURE_COMMAND]
#    [BUILD_COMMAND]
#    [INSTALL_COMMAND]
#    [TEST_COMMAND]
#    )
#
# YCM_BOOTSTRAP()
#
# Variables:
# NON_INTERACTIVE_BUILD
# YCM_BOOTSTRAP_BASE_ADDRESS
# YCM_SKIP_HASH_CHECK
# YCM_BOOTSTRAP_VERBOSE

# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT


if(DEFINED __YCMEPHELPER_INCLUDED)
  return()
endif()
set(__YCMEPHELPER_INCLUDED TRUE)



########################################################################
# Hashes of YCM files to be checked

# Files downloaded during YCM bootstrap
set(_ycm_CMakeParseArguments_sha1sum 0c4d3f7ed248145cbeb67cbd6fd7190baf2e4517)
set(_ycm_ExternalProject_sha1sum     e13485c3203f90e028baeffbf1a48a9f98995ed7)

# Files in all projects that need to bootstrap YCM
set(_ycm_IncludeUrl_sha1sum          7705c6eb8ed70694e2b9688a90f0731e37c7a8ac)
set(_ycm_YCMBootstrap_sha1sum        d1fd9afbbf290dbf6d6df5f3be7a24df971ea4fe)


########################################################################
# _YCM_INCLUDE
#
# Internal macro to include files from cmake-next.
# If YCM was not found, we are bootstrapping, therefore we need to
# download and use these modules instead of the ones found by cmake
# This must be a macro and not a function in order not to enclose in a
# new scope the variables added by the included files.

macro(_YCM_INCLUDE _module)
    if(YCM_FOUND)
        include(${_module})
    else()
        # We assume that YCMEPHelper was included using include_url, or that at
        # least the IncludeUrl command exists.
        if(NOT COMMAND include_url)
            include(IncludeUrl)
        endif()
        unset(_expected_hash_args)
        if(NOT YCM_SKIP_HASH_CHECK)
            set(_expected_hash_args EXPECTED_HASH SHA1=${_ycm_${_module}_sha1sum})
        endif()
        include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/cmake-next/Modules/${_module}.cmake
                    ${_expected_hash_args}
                    STATUS _download_status)
        if(NOT _download_status EQUAL 0)
            list(GET 0 _download_status _download_status_0)
            list(GET 1 _download_status _download_status_1)
            message(FATAL_ERROR "Download failed with ${_download_status_0}: ${_download_status_1}")
        endif()

        unset(_expected_hash_args)
        unset(_download_status)
        unset(_download_status_0)
        unset(_download_status_1)
    endif()
endmacro()


########################################################################
# _YCM_HASH_CHECK
#
# Internal function to check if a module in user repository is updated
# at the latest version and eventually print an AUTHOR_WARNING.
#
# if the variable YCM_SKIP_HASH_CHECK is set it does nothing

function(_YCM_HASH_CHECK _module)
    if(YCM_SKIP_HASH_CHECK)
        return()
    endif()

    # FIXME is there a way to find the module without including it?
    include(${_module} RESULT_VARIABLE _module_file OPTIONAL)
    if(_module_file)
        file(SHA1 ${_module_file} _module_sha1sum)
        if(NOT "${_module_sha1sum}" STREQUAL "${_ycm_${_module}_sha1sum}")
            message(AUTHOR_WARNING
"YCM_BOOTSTRAP HASH mismatch
  for file: [${_module_file}]
    expected hash: [${_ycm_${_module}_sha1sum}]
      actual hash: [${_module_sha1sum}]
Perhaps it is outdated or you have local modification. Please consider upgrading it, or contributing your changes to YCM.
")
        endif()
    endif()
endfunction()



########################################################################
# _YCM_SETUP
#
# Internal function to perform generic setup.
# This must be a macro and not a function in order not to enclose in a
# new scope the variables added by the included files.

unset(__YCM_SETUP_CALLED)
macro(_YCM_SETUP)
    if(DEFINED __YCM_SETUP_CALLED)
        return()
    endif()
    set(__YCM_SETUP_CALLED 1)

    _ycm_include(CMakeParseArguments)
    _ycm_include(ExternalProject)

    set_property(DIRECTORY PROPERTY EP_STEP_TARGETS configure)
    set_property(DIRECTORY PROPERTY EP_INDEPENDENT_STEP_TARGETS update)
    set_property(DIRECTORY PROPERTY EP_SOURCE_DIR_PRESERVE 1)
    set_property(DIRECTORY PROPERTY EP_SCM_DISCONNECTED 1)
    set_property(DIRECTORY PROPERTY CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY FALSE)

    if(NOT TARGET update-all)
        add_custom_target(update-all)
    endif()

    if(NOT TARGET fetch-all)
        add_custom_target(fetch-all)
    endif()

    if(NOT TARGET status-all)
        add_custom_target(status-all)
    endif()

    if(NOT TARGET print-directories-all)
        add_custom_target(print-directories-all)
    endif()

    if(NOT YCM_FOUND) # Useless if we don't need to bootstrap
        set(YCM_BOOTSTRAP_BASE_ADDRESS "https://raw.github.com/robotology/ycm/HEAD/" CACHE STRING "Base address of YCM repository")
        mark_as_advanced(YCM_BOOTSTRAP_BASE_ADDRESS)
    endif()
endmacro()


########################################################################
# _YCM_SETUP_GIT
#
# Internal function to perform GIT setup.

unset(__YCM_GIT_SETUP_CALLED CACHE)
function(_YCM_SETUP_GIT)
    if(DEFINED __YCM_GIT_SETUP_CALLED)
        return()
    endif()
    set(__YCM_GIT_SETUP_CALLED 1 CACHE INTERNAL "")

    find_package(Git QUIET)
    if(NOT GIT_EXECUTABLE)
        message(FATAL_ERROR "Please install Git")
    endif()

    execute_process(COMMAND ${GIT_EXECUTABLE} config --get user.name
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    RESULT_VARIABLE _error_code
                    OUTPUT_VARIABLE _output_name
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT NON_INTERACTIVE_BUILD AND _error_code)
        message(FATAL_ERROR "Failed to get name to use for git commits. Please set it with \"git config --global user.name Firstname Lastname\"")
    endif()

    execute_process(COMMAND ${GIT_EXECUTABLE} config --get user.email
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    RESULT_VARIABLE _error_code
                    OUTPUT_VARIABLE _output_email
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(NOT NON_INTERACTIVE_BUILD AND _error_code)
        message(FATAL_ERROR "Failed to get name to use for git commits. Please set it with \"git config --global user.email name@example.com\"")
    endif()

    set(YCM_GIT_COMMIT_NAME "${_output_name}" CACHE STRING "Name to use for git commits")
    set(YCM_GIT_COMMIT_EMAIL "${_output_email}" CACHE STRING "Email address to use for git commits")
    mark_as_advanced(YCM_GIT_COMMIT_NAME YCM_GIT_COMMIT_EMAIL)


    # TYPE GIT STYLE GITHUB
    set(YCM_GIT_GITHUB_USERNAME "" CACHE STRING "Username to use for github git repositories")
    set(YCM_GIT_GITHUB_COMMIT_NAME "" CACHE STRING "Name to use for git commits for github git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
    set(YCM_GIT_GITHUB_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for github git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
    set(YCM_GIT_GITHUB_BASE_ADDRESS "https://github.com/" CACHE STRING "Address to use for github git repositories")
    set_property(CACHE YCM_GIT_GITHUB_BASE_ADDRESS PROPERTY STRINGS "https://github.com/" "git://github.com/" "ssh://git@github.com/" "github:")
    mark_as_advanced(YCM_GIT_GITHUB_USERNAME YCM_GIT_GITHUB_COMMIT_NAME YCM_GIT_GITHUB_COMMIT_EMAIL YCM_GIT_GITHUB_BASE_ADDRESS)


    # TYPE GIT STYLE KDE
    set(YCM_GIT_KDE_USERNAME "" CACHE STRING "Username to use for kde git repositories")
    set(YCM_GIT_KDE_COMMIT_NAME "" CACHE STRING "Name to use for git commits for kde git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
    set(YCM_GIT_KDE_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for kde git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
    set(YCM_GIT_KDE_BASE_ADDRESS "git://anongit.kde.org/" CACHE STRING "Address to use for kde git repositories")
    set_property(CACHE YCM_GIT_KDE_BASE_ADDRESS PROPERTY STRINGS "git://anongit.kde.org/" "ssh://git@git.kde.org/" "kde:")
    mark_as_advanced(YCM_GIT_KDE_USERNAME YCM_GIT_KDE_COMMIT_NAME YCM_GIT_KDE_COMMIT_EMAIL YCM_GIT_KDE_BASE_ADDRESS)


    # TYPE GIT STYLE GNOME
    set(YCM_GIT_GNOME_USERNAME "" CACHE STRING "Username to use for gnome git repositories")
    set(YCM_GIT_GNOME_COMMIT_NAME "" CACHE STRING "Name to use for git commits for gnome git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
    set(YCM_GIT_GNOME_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for gnome git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
    set(YCM_GIT_GNOME_BASE_ADDRESS "git://git.gnome.org/" CACHE STRING "Address to use for gnome git repositories")
    set_property(CACHE YCM_GIT_GNOME_BASE_ADDRESS PROPERTY STRINGS "git://git.gnome.org/" "ssh://git@git.gnome.org/" "gnome:")
    mark_as_advanced(YCM_GIT_GNOME_USERNAME YCM_GIT_GNOME_COMMIT_NAME YCM_GIT_GNOME_COMMIT_EMAIL YCM_GIT_GNOME_BASE_ADDRESS)


    # TYPE GIT STYLE SOURCEFORGE
    set(YCM_GIT_SOURCEFORGE_USERNAME "" CACHE STRING "Username to use for sourceforge git repositories")
    set(YCM_GIT_SOURCEFORGE_COMMIT_NAME "" CACHE STRING "Name to use for git commits for sourceforge git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
    set(YCM_GIT_SOURCEFORGE_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for sourceforge git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
    set(YCM_GIT_SOURCEFORGE_BASE_ADDRESS "git://git.code.sf.net/p/" CACHE STRING "Address to use for sourceforge git repositories")
    set_property(CACHE YCM_GIT_SOURCEFORGE_BASE_ADDRESS PROPERTY STRINGS "git://git.code.sf.net/p/" "ssh://${YCM_GIT_SOURCEFORGE_USERNAME}@git.code.sf.net/p/" "sf:")
    mark_as_advanced(YCM_GIT_SOURCEFORGE_USERNAME YCM_GIT_SOURCEFORGE_COMMIT_NAME YCM_GIT_SOURCEFORGE_COMMIT_EMAIL YCM_GIT_SOURCEFORGE_BASE_ADDRESS)


    # TYPE GIT STYLE GITLAB_ICUB_ORG
    set(YCM_GIT_GITLAB_ICUB_ORG_USERNAME "" CACHE STRING "Username to use for IIT iCub Facility Gitlab git repositories")
    set(YCM_GIT_GITLAB_ICUB_ORG_COMMIT_NAME "" CACHE STRING "Name to use for git commits for IIT iCub Facility Gitlab git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
    set(YCM_GIT_GITLAB_ICUB_ORG_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for IIT iCub Facility Gitlab git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
    set(YCM_GIT_GITLAB_ICUB_ORG_BASE_ADDRESS "https://gitlab.icub.org/" CACHE STRING "Address to use for IIT iCub Facility Gitlab git repositories")
    set_property(CACHE YCM_GIT_GITLAB_ICUB_ORG_BASE_ADDRESS PROPERTY STRINGS "https://gitlab.icub.org/" "git://gitlab.icub.org/" "ssh://git@gitlab.icub.org/" "icub:")
    mark_as_advanced(YCM_GIT_GITLAB_ICUB_ORG_USERNAME YCM_GIT_GITLAB_ICUB_ORG_COMMIT_NAME YCM_GIT_GITLAB_ICUB_ORG_COMMIT_EMAIL YCM_GIT_GITLAB_ICUB_ORG_BASE_ADDRESS)


    # TYPE GIT STYLE LOCAL
    set(YCM_GIT_LOCAL_BASE_ADDRESS "" CACHE INTERNAL "Address to use for local git repositories")


    # TYPE GIT STYLE NONE
    set(YCM_GIT_NONE_BASE_ADDRESS "" CACHE INTERNAL "Address to use for other git repositories")

endfunction()


########################################################################
# _YCM_SETUP_SVN
#
# Internal function to perform SVN setup.

unset(__YCM_SVN_SETUP_CALLED CACHE)
function(_YCM_SETUP_SVN)
    if(DEFINED __YCM_SVN_SETUP_CALLED)
        return()
    endif()
    set(__YCM_SVN_SETUP_CALLED 1 CACHE INTERNAL "")

    find_package(Subversion QUIET)
    if(NOT Subversion_SVN_EXECUTABLE)
        message(FATAL_ERROR "Please install Svn")
    endif()

    # TYPE SVN STYLE SOURCEFORGE
    set(YCM_SVN_SOURCEFORGE_USERNAME "" CACHE STRING "Username to use for sourceforge svn repositories")
    set(YCM_SVN_SOURCEFORGE_PASSWORD "" CACHE STRING "Password to use for sourceforge svn repositories")
    set(YCM_SVN_SOURCEFORGE_BASE_ADDRESS "https://svn.code.sf.net/p/" CACHE INTERNAL "Address to use for sourceforge svn repositories")
    mark_as_advanced(YCM_SVN_SOURCEFORGE_USERNAME YCM_SVN_SOURCEFORGE_PASSWORD)
endfunction()


########################################################################
# YCM_EP_HELPER
#
# Helper function to add a repository using ExternalProject

function(YCM_EP_HELPER _name)
    # Adding target twice is not allowed
    if(TARGET ${_name})
        message(WARNING "Failed to add target ${_name}. A target with the same name already exists.")
        return()
    endif()
    # Check arguments
    set(_options )
    set(_oneValueArgs TYPE
                      STYLE
                      COMPONENT
                      REPOSITORY
                      EXCLUDE_FROM_ALL
                      TAG         # GIT only
                      REVISION    # SVN only
                      USERNAME    # SVN only
                      PASSWORD    # SVN only
                      TRUST_CERT) # SVN only
    set(_multiValueArgs CMAKE_ARGS
                        CMAKE_CACHE_ARGS
                        DEPENDS
                        DOWNLOAD_COMMAND
                        UPDATE_COMMAND
                        PATCH_COMMAND
                        CONFIGURE_COMMAND
                        BUILD_COMMAND
                        INSTALL_COMMAND
                        TEST_COMMAND)

    cmake_parse_arguments(_YH_${_name} "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")

    if(NOT DEFINED _YH_${_name}_TYPE)
        message(FATAL_ERROR "Missing TYPE argument")
    endif()
    if(NOT "x${_YH_${_name}_TYPE}" MATCHES "^x(GIT|SVN)$")
        message(FATAL_ERROR "Unsupported VCS TYPE:\n  ${_YH_${_name}_TYPE}\n")
    endif()
    if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
      # TODO Check GIT arguments
    elseif("${_YH_${_name}_TYPE}" STREQUAL "SVN")
      # TODO Check SVN arguments
    endif()

    if(NOT DEFINED _YH_${_name}_STYLE)
        message(FATAL_ERROR "Missing STYLE argument")
    endif()

    if(NOT DEFINED _YH_${_name}_REPOSITORY)
        message(FATAL_ERROR "Missing REPOSITORY argument")
    endif()

    if(NOT DEFINED _YH_${_name}_COMPONENT)
        set(_YH_${_name}_COMPONENT external)
#     elseif(NOT "x${_YH_${_name}_COMPONENT}" MATCHES "^x(external|documentation)$")
#         message(WARNING "Unknown component:\n  ${_YH_${_name}_COMPONENT}\n")
    endif()

    # Generic variables
    set(${_name}_PREFIX ${CMAKE_BINARY_DIR}/${_YH_${_name}_COMPONENT})
    set(${_name}_SOURCE_DIR ${CMAKE_SOURCE_DIR}/${_YH_${_name}_COMPONENT}/${_name})
    set(${_name}_DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/${_YH_${_name}_COMPONENT})
    set(${_name}_BINARY_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_COMPONENT}/${_name})
    set(${_name}_INSTALL_DIR ${CMAKE_BINARY_DIR}/install) # TODO Use a cached variable for installation outside build directory
    set(${_name}_TMP_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_COMPONENT}/${_name}${CMAKE_FILES_DIRECTORY}/YCMTmp)
    set(${_name}_STAMP_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_COMPONENT}/${_name}${CMAKE_FILES_DIRECTORY})

    set(${_name}_DIR_ARGS PREFIX ${${_name}_PREFIX}
                          SOURCE_DIR ${${_name}_SOURCE_DIR}
                          DOWNLOAD_DIR ${${_name}_DOWNLOAD_DIR}
                          BINARY_DIR ${${_name}_BINARY_DIR}
                          INSTALL_DIR ${${_name}_INSTALL_DIR}
                          TMP_DIR ${${_name}_TMP_DIR}
                          STAMP_DIR ${${_name}_STAMP_DIR})

    # ExternalProject does not handle correctly arguments containing ";" passed
    # using CMAKE_ARGS, and instead splits them into several arguments. This is
    # a workaround that replaces ";" with "|" and sets LIST_SEPARATOR "|" in
    # order to interpret them correctly.
    #
    # TODO FIXME check what happens when the "*_COMMAND" arguments are passed.
    file(TO_CMAKE_PATH "$ENV{CMAKE_PREFIX_PATH}" _CMAKE_PREFIX_PATH)
    list(APPEND _CMAKE_PREFIX_PATH ${${_name}_INSTALL_DIR})
    list(REMOVE_DUPLICATES _CMAKE_PREFIX_PATH)
    string(REPLACE ";" "|" _CMAKE_PREFIX_PATH "${_CMAKE_PREFIX_PATH}")
    set(${_name}_CMAKE_ARGS "--no-warn-unused-cli"
                            "-DCMAKE_PREFIX_PATH:PATH=${_CMAKE_PREFIX_PATH}"      # Path used by cmake for finding stuff
                            "-DCMAKE_INSTALL_PREFIX:PATH=${${_name}_INSTALL_DIR}" # Where to do the installation
                            "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"       # If there is a CMAKE_BUILD_TYPE it is important to ensure it is passed down.
                            "-DCMAKE_SKIP_RPATH:PATH=\"${CMAKE_SKIP_RPATH}\""
                            "-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}")
    if(_YH_${_name}_CMAKE_ARGS)
        list(APPEND ${_name}_CMAKE_ARGS ${_YH_${_name}_CMAKE_ARGS})
    endif()

    set(${_name}_ALL_CMAKE_ARGS CMAKE_ARGS ${${_name}_CMAKE_ARGS})

    if(_YH_${_name}_CMAKE_CACHE_ARGS)
        list(APPEND ${_name}_ALL_CMAKE_ARGS CMAKE_CACHE_ARGS ${_YH_${_name}_CMAKE_CACHE_ARGS})
    endif()
    list(APPEND ${_name}_ALL_CMAKE_ARGS LIST_SEPARATOR "|")

    foreach(_dep ${_YH_${_name}_DEPENDS})
        if(TARGET ${_dep})
            get_property(is_ep TARGET ${_dep} PROPERTY _EP_IS_EXTERNAL_PROJECT)
            if(is_ep)
                set(_YH_${_name}_DEPENDS_ARGS ${_YH_${_name}_DEPENDS_ARGS} ${_dep})
            endif()
        endif()
    endforeach()

    if(_YH_${_name}_DEPENDS_ARGS)
        set(${_name}_DEPENDS_ARGS DEPENDS ${_YH_${_name}_DEPENDS_ARGS})
    endif()

    unset(${_name}_COMMAND_ARGS)
    foreach(_step DOWNLOAD
                  UPDATE PATCH
                  CONFIGURE
                  BUILD
                  INSTALL
                  TEST)
        if(CMAKE_VERSION VERSION_LESS 3.0.0)
            # HACK: set(var "" PARENT_SCOPE) before CMake 3.0.0 did not set an empty string, but
            # instead unset the variable.
            # Therefore after cmake_parse_arguments, even if the variables are defined, they are not
            # set.
            if("${ARGN}" MATCHES ";?${_step}_COMMAND;"  AND  NOT DEFINED _YH_${_name}_${_step}_COMMAND)
                set(_YH_${_name}_${_step}_COMMAND "")
            endif()
        endif()
        if(DEFINED _YH_${_name}_${_step}_COMMAND)
            string(CONFIGURE "${_YH_${_name}_${_step}_COMMAND}" _YH_${_name}_${_step}_COMMAND @ONLY)
            list(APPEND ${_name}_COMMAND_ARGS ${_step}_COMMAND "${_YH_${_name}_${_step}_COMMAND}")
        endif()
    endforeach()

    unset(${_name}_COMPONENT_ARGS)
    if("${_YH_${_name}_COMPONENT}" STREQUAL "documentation")
        set(${_name}_COMPONENT_ARGS CONFIGURE_COMMAND ""
                                    BUILD_COMMAND ""
                                    INSTALL_COMMAND ""
                                    STEP_TARGETS ""
                                    INDEPENDENT_STEP_TARGETS "")
    endif()



    unset(${_name}_EXTRA_ARGS})
    if(DEFINED _YH_${_name}_EXCLUDE_FROM_ALL)
        list(APPEND ${_name}_EXTRA_ARGS EXCLUDE_FROM_ALL ${_YH_${_name}_EXCLUDE_FROM_ALL})
    endif()


    # Repository dependent variables
    unset(${_name}_REPOSITORY_ARGS)
    unset(_setup_devel_cmd)

    if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
        # Specific setup for GIT
        _ycm_setup_git()

        list(APPEND ${_name}_REPOSITORY_ARGS GIT_REPOSITORY ${YCM_GIT_${_YH_${_name}_STYLE}_BASE_ADDRESS}${_YH_${_name}_REPOSITORY})

        if(DEFINED _YH_${_name}_TAG)
            list(APPEND ${_name}_REPOSITORY_ARGS GIT_TAG ${_YH_${_name}_TAG})
        endif()

       if(YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_NAME)
            unset(${_name}_COMMIT_NAME)
            set(_setup_devel_cmd ${_setup_devel_cmd}
                                 COMMAND ${GIT_EXECUTABLE} config --local user.name ${YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_NAME})
        endif()

        if(YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_EMAIL)
            set(_setup_devel_cmd ${_setup_devel_cmd}
                                 COMMAND ${GIT_EXECUTABLE} config --local user.email ${YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_EMAIL})
       endif()
    elseif("${_YH_${_name}_TYPE}" STREQUAL "SVN")
        # Specific setup for SVN
        _ycm_setup_svn()

        list(APPEND ${_name}_REPOSITORY_ARGS SVN_REPOSITORY ${YCM_SVN_${_YH_${_name}_STYLE}_BASE_ADDRESS}${_YH_${_name}_REPOSITORY})

        if(YCM_SVN_${_YH_${_name}_STYLE}_USERNAME)
            list(APPEND ${_name}_REPOSITORY_ARGS SVN_USERNAME ${YCM_SVN_${_YH_${_name}_STYLE}_USERNAME})
        endif()

        if(YCM_SVN_${_YH_${_name}_STYLE}_PASSWORD)
            list(APPEND ${_name}_REPOSITORY_ARGS SVN_PASSWORD ${YCM_SVN_${_YH_${_name}_STYLE}_PASSWORD})
        endif()

        if(DEFINED _YH_${_name}_TRUST_CERT)
            list(APPEND ${_name}_REPOSITORY_ARGS SVN_TRUST_CERT ${_YH_${_name}_TRUST_CERT})
        endif()
    endif()


    unset(${_name}_ARGS)
    foreach(_arg IN LISTS ${_name}_REPOSITORY_ARGS
                          ${_name}_DIR_ARGS
                          ${_name}_ALL_CMAKE_ARGS
                          ${_name}_DEPENDS_ARGS
                          ${_name}_COMMAND_ARGS
                          ${_name}_COMPONENT_ARGS
                          ${_name}_EXTRA_ARGS)
        list(APPEND ${_name}_ARGS "${_arg}")
    endforeach()
    externalproject_add(${_name} "${${_name}_ARGS}")
    set_property(TARGET ${_name} PROPERTY FOLDER ${_name})

    if(TARGET update-all AND TARGET ${_name}-update)
        add_dependencies(update-all ${_name}-update)
    endif()

    if(_setup_devel_cmd)
        externalproject_add_step(${_name} setup-development
                                 ${_setup_devel_cmd}
                                 WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                                 COMMENT "Performing setup-development step for '${_name}'"
                                 DEPENDEES download
                                 DEPENDERS update)
    endif()


# Extra steps
    if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
        externalproject_add_step(${_name} fetch
                                 COMMAND ${GIT_EXECUTABLE} fetch --all --prune
                                 WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                                 COMMENT "Performing fetch step for '${_name}'"
                                 DEPENDEES download
                                 EXCLUDE_FROM_MAIN 1
                                 ALWAYS 1)
        externalproject_add_steptargets(${_name} NO_DEPENDS fetch)
        add_dependencies(fetch-all ${_name}-fetch)

        externalproject_add_step(${_name} status
                                 COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --switch=$(COLOR) --cyan "Working directory: ${${_name}_SOURCE_DIR}"
                                 COMMAND ${GIT_EXECUTABLE} status
                                 WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                                 DEPENDEES download
                                 EXCLUDE_FROM_MAIN 1
                                 ALWAYS 1)
        externalproject_add_steptargets(${_name} NO_DEPENDS status)
        add_dependencies(status-all ${_name}-status)
    elseif("${_YH_${_name}_TYPE}" STREQUAL "SVN")
        externalproject_add_step(${_name} status
                                 COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --switch=$(COLOR) --cyan "Working directory: ${${_name}_SOURCE_DIR}"
                                 COMMAND ${Subversion_SVN_EXECUTABLE} status
                                 WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                                 DEPENDEES download
                                 EXCLUDE_FROM_MAIN 1
                                 ALWAYS 1)
        externalproject_add_steptargets(${_name} NO_DEPENDS status)
        add_dependencies(status-all ${_name}-status)
    endif()


    externalproject_add_step(${_name} print-directories
                             COMMAND ${CMAKE_COMMAND} -E echo ""
                             COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --switch=$(COLOR) --cyan "${_name} SOURCE directory: "
                             COMMAND ${CMAKE_COMMAND} -E echo "    ${${_name}_SOURCE_DIR}"
                             COMMAND ${CMAKE_COMMAND} -E echo ""
                             COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --switch=$(COLOR) --cyan "${_name} BINARY directory: "
                             COMMAND ${CMAKE_COMMAND} -E echo "    ${${_name}_BINARY_DIR}"
                             COMMAND ${CMAKE_COMMAND} -E echo ""
                             WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                             DEPENDEES download
                             EXCLUDE_FROM_MAIN 1
                             COMMENT "Directories for ${_name}"
                             ALWAYS 1)
    externalproject_add_steptargets(${_name} NO_DEPENDS print-directories)
    add_dependencies(print-directories-all ${_name}-print-directories)


    # Set some useful variables in parent scope
    foreach(_d PREFIX
              SOURCE_DIR
              DOWNLOAD_DIR
              BINARY_DIR
              INSTALL_DIR
              TMP_DIR
              STAMP_DIR)
        set(${_name}_${_d} ${${_name}_${_d}} PARENT_SCOPE)
    endforeach()

endfunction()


########################################################################
# YCM_BOOTSTRAP
#
# Bootstrap YCM.
#
# If the variable YCM_BOOTSTRAP_VERBOSE is set it prints all the output
# from the commands executed.

unset(__YCM_BOOTSTRAPPED_CALLED CACHE)
macro(YCM_BOOTSTRAP)
    if(YCM_FOUND  OR  DEFINED __YCM_BOOTSTRAPPED_CALLED)
        return()
    endif()
    set(__YCM_BOOTSTRAPPED_CALLED TRUE CACHE INTERNAL "")

    _ycm_hash_check(IncludeUrl)
    _ycm_hash_check(YCMBootstrap)

    if(NOT YCM_BOOTSTRAP_VERBOSE)
        set(_quiet_args OUTPUT_QUIET ERROR_QUIET)
    else()
        set(_quiet_args )
    endif()

    ycm_ep_helper(YCM TYPE GIT
                      STYLE GITHUB
                      REPOSITORY robotology/ycm.git
                      TAG master
                      EXCLUDE_FROM_ALL 1)


    message(STATUS "Performing download step (git clone) for 'YCM'")
    execute_process(COMMAND ${CMAKE_COMMAND} -P ${YCM_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/YCMTmp/YCM-gitclone.cmake
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    if(_result)
        message(FATAL_ERROR "Cannot clone YCM repository (${_result})")
    endif()

    message(STATUS "Performing update step for 'YCM'")
    execute_process(COMMAND ${CMAKE_COMMAND} -P ${YCM_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/YCMTmp/YCM-gitupdate.cmake
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    if(_result)
        message(FATAL_ERROR "Cannot update YCM repository")
    endif()

    message(STATUS "Performing configure step for 'YCM'")
    file(READ ${YCM_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/YCMTmp/YCM-cfgcmd.txt _cmd)
    string(STRIP "${_cmd}" _cmd)
    string(REGEX REPLACE "^cmd='(.+)'" "\\1" _cmd "${_cmd}")
    execute_process(COMMAND ${_cmd}
                    WORKING_DIRECTORY ${YCM_BINARY_DIR}
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    if(_result)
        message(FATAL_ERROR "Cannot configure YCM repository")
    endif()

    message(STATUS "Performing uninstall step for 'YCM'")
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target uninstall
                    WORKING_DIRECTORY ${YCM_BINARY_DIR}
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    # If uninstall fails, YCM was not previously installed,
    # therefore do not fail with error

    message(STATUS "Performing build step for 'YCM'")
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR}
                    WORKING_DIRECTORY ${YCM_BINARY_DIR}
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    if(_result)
        message(FATAL_ERROR "Cannot build YCM")
    endif()

    message(STATUS "Performing install step for 'YCM'")
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target install
                    WORKING_DIRECTORY ${YCM_BINARY_DIR}
                    ${_quiet_args}
                    RESULT_VARIABLE _result)
    if(_result)
        message(FATAL_ERROR "Cannot install YCM")
    endif()

    # Find the package, so that can be used now.
    find_package(YCM PATHS ${YCM_INSTALL_DIR} NO_DEFAULT_PATH)

    # Reset YCM_DIR variable so that next find_package will fail to locate the package and this will be kept updated
    set(YCM_DIR "YCM_DIR-NOTFOUND" CACHE PATH "The directory containing a CMake configuration file for YCM." FORCE)

    # Trick FeatureSummary to believe that YCM was not found
    get_property(_packages_found GLOBAL PROPERTY PACKAGES_FOUND)
    get_property(_packages_not_found GLOBAL PROPERTY PACKAGES_NOT_FOUND)
    list(REMOVE_ITEM _packages_found YCM)
    list(APPEND _packages_not_found YCM)
    set_property(GLOBAL PROPERTY PACKAGES_FOUND ${_packages_found})
    set_property(GLOBAL PROPERTY PACKAGES_NOT_FOUND ${_packages_not_found})

    # Cleanup used variables
    unset(_quiet_args)
    unset(_result)
    unset(_packages_found)
    unset(_packages_not_found)

endmacro()


########################################################################
# Main

_ycm_setup()
