# YCM_EP_HELPER(<name>
#    [DOCS]
#   #--Git arguments-----------
#    [STYLE <style>]
#    [REPOSITORY <repo>]
#   #--CMake arguments---------
#    [CMAKE_ARGS]
#    [CMAKE_CACHE_ARGS]
#    [DEPENDS]
#
# YCM_BOOTSTRAP()
#
# NON_INTERACTIVE_BUILD

# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

include(CMakeParseArguments)
include(ExternalProject)

set_property(DIRECTORY PROPERTY EP_STEP_TARGETS update configure)
set_property(DIRECTORY PROPERTY EP_SOURCE_DIR_PRESERVE TRUE)

if(NOT TARGET update-all)
    add_custom_target(update-all)
endif()

if(NOT TARGET status-all)
    add_custom_target(status-all)
endif()

if(NOT TARGET fetch-all)
    add_custom_target(fetch-all)
endif()

if(NOT TARGET pull-all)
    add_custom_target(pull-all)
endif()


################################################################################
# Setup GIT

macro(_YCM_SETUP_GIT)

    if(NOT DEFINED YCM_GIT_SETUP)
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
        set(YCM_GIT_NONE_BASE_ADDRESS "" CACHE INTERNAL "Address to use for local git repositories")

        set(YCM_GIT_SETUP 1 CACHE INTERNAL "")
    endif()
endmacro()

################################################################################
# Setup SVN
# FIXME TODO

macro(_YCM_SETUP_SVN)
    if(NOT DEFINED YCM_SETUP_SVN)
        find_package(Svn QUIET)
        if(NOT SVN_EXECUTABLE)
            message(FATAL_ERROR "Please install Svn")
        endif()
    endif()

    message(FATAL_ERROR "NOT YET IMPLEMENTED")

endmacro()

################################################################################
# YCM_EP_HELPER

macro(YCM_EP_HELPER _name)

    # Adding target twice is not allowed
    if(TARGET ${_name})
        return()
    endif()

    # Check arguments
    set(_options )
    set(_oneValueArgs TYPE
                      STYLE
                      REPOSITORY
                      TAG)
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

    cmake_parse_arguments(_${_name} "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})

    if(NOT DEFINED _${_name}_TYPE)
        message(FATAL_ERROR "Missing TYPE argument")
    endif()
    if(NOT "x${_${_name}_TYPE}" MATCHES "^x(GIT|SVN)$")
        message(FATAL_ERROR "Unsupported VCS TYPE:\n  ${_${_name}_TYPE}\n")
    endif()

    if(NOT DEFINED _${_name}_STYLE)
        message(FATAL_ERROR "Missing STYLE argument")
    endif()

    if(NOT DEFINED _${_name}_REPOSITORY)
        message(FATAL_ERROR "Missing REPOSITORY argument")
    endif()


    # Generic variables
    set(${_name}_PREFIX ${CMAKE_BINARY_DIR}/external)
    set(${_name}_SOURCE_DIR ${CMAKE_SOURCE_DIR}/external/${_name})
    set(${_name}_DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/external)
    set(${_name}_BINARY_DIR ${CMAKE_BINARY_DIR}/external/${_name})
    set(${_name}_INSTALL_DIR ${CMAKE_BINARY_DIR}/install) # TODO Use a cached variable for installation outside build directory
    set(${_name}_TMP_DIR ${CMAKE_BINARY_DIR}/external/${_name}/CMakeFiles/CMakeTmp)
    set(${_name}_STAMP_DIR ${CMAKE_BINARY_DIR}/external/${_name}/CMakeFiles/)

    set(${_name}_DIR_ARGS PREFIX ${${_name}_PREFIX}
                          SOURCE_DIR ${${_name}_SOURCE_DIR}
                          DOWNLOAD_DIR ${${_name}_DOWNLOAD_DIR}
                          BINARY_DIR ${${_name}_BINARY_DIR}
                          INSTALL_DIR ${${_name}_INSTALL_DIR}
                          TMP_DIR ${${_name}_TMP_DIR}
                          STAMP_DIR ${${_name}_STAMP_DIR})

    set(${_name}_CMAKE_ARGS CMAKE_ARGS
                            "--no-warn-unused-cli"
                            "-DCMAKE_PREFIX_PATH:PATH=${${_name}_INSTALL_DIR}"    # Path used by cmake for finding stuff
                            "-DCMAKE_INSTALL_PREFIX:PATH=${${_name}_INSTALL_DIR}" # Where to do the installation
                            "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"       # If there is a CMAKE_BUILD_TYPE it is important to ensure it is passed down.
                            "-DCMAKE_SKIP_RPATH:PATH=\"${CMAKE_SKIP_RPATH}\""
                            "-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}")

    if(_${_name}_CMAKE_ARGS)
        list(APPEND ${_name}_CMAKE_ARGS ${_${_name}_CMAKE_ARGS})
    endif()

    if(_${_name}_CMAKE_CACHE_ARGS)
        list(APPEND ${_name}_CMAKE_ARGS CMAKE_CACHE_ARGS ${_${_name}_CMAKE_CACHE_ARGS})
    endif()

    foreach(_dep ${_${_name}_DEPENDS})
        if(TARGET ${_dep})
            set(_${_name}_DEPENDS_ARGS ${_${_name}_DEPENDS_ARGS} ${_dep})
        endif()
    endforeach()

    if(_${_name}_DEPENDS_ARGS)
        set(${_name}_DEPENDS_ARGS DEPENDS ${_${_name}_DEPENDS_ARGS})
    endif()

    set(${_name}_COMMAND_ARGS )
    foreach(_step DOWNLOAD
                  UPDATE PATCH
                  CONFIGURE
                  BUILD
                  INSTALL
                  TEST)
        if(DEFINED _${_name}_${_step}_COMMAND)
            string(CONFIGURE "${_${_name}_${_step}_COMMAND}" _${_name}_${_step}_COMMAND @ONLY)
            list(APPEND ${_name}_COMMAND_ARGS ${_step}_COMMAND ${_${_name}_${_step}_COMMAND})
        endif()
    endforeach()

    # Repository variables
    set(${_name}_REPOSITORY_ARGS )
    set(_setup_devel_cmd )

    if("${_${_name}_TYPE}" STREQUAL "GIT")
        # Specific setup for GIT
        _ycm_setup_git()

        list(APPEND ${_name}_REPOSITORY_ARGS GIT_REPOSITORY ${YCM_GIT_${_${_name}_STYLE}_BASE_ADDRESS}${_${_name}_REPOSITORY})

        if(_${_name}_TAG)
            list(APPEND ${_name}_REPOSITORY_ARGS GIT_TAG ${_${_name}_TAG})
        endif()

        if(YCM_GIT_${_${_name}_STYLE}_COMMIT_NAME)
            set(${_name}_COMMIT_NAME )
            set(_setup_devel_cmd ${_setup_devel_cmd}
                                 COMMAND ${GIT_EXECUTABLE} config --local user.name ${YCM_GIT_${_${_name}_STYLE}_COMMIT_NAME})
        endif()

        if(YCM_GIT_${_${_name}_STYLE}_COMMIT_EMAIL)
            set(_setup_devel_cmd ${_setup_devel_cmd}
                                 COMMAND ${GIT_EXECUTABLE} config --local user.email ${YCM_GIT_${_${_name}_STYLE}_COMMIT_EMAIL})
        endif()

        if("${_${_name}_STYLE}" STREQUAL "GITLAB_ICUB_ORG")
            set(_setup_devel_cmd ${_setup_devel_cmd}
                                 COMMAND ${GIT_EXECUTABLE} config --local http.sslverify false)
        endif()
    elseif("${_${_name}_TYPE}" STREQUAL "SVN")
        # FIXME Implement SVN
        message(FATAL_ERROR "NOT YET IMPLEMENTED")
        # Specific setup for SVN
        _ycm_setup_svn()
    endif()

    externalproject_add(${_name}
                        ${${_name}_REPOSITORY_ARGS}
                        ${${_name}_DIR_ARGS}
                        ${${_name}_CMAKE_ARGS}
                        ${${_name}_DEPENDS_ARGS}
                        ${${_name}_COMMAND_ARGS})
    set_property(TARGET ${proj} PROPERTY FOLDER ${_name})

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


# TODO Enable extra steps
#     externalproject_add_step(${_name} fetch
#                              COMMAND ${GIT_EXECUTABLE} fetch --all --prune
#                              WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
#                              COMMENT "Performing fetch step for '${_name}'"
#                              DEPENDEES update)
#     externalproject_add_steptargets(${_name} fetch)
#     add_dependencies(fetch-all ${_name}-fetch)
#
#     externalproject_add_step(${_name} status
#                              COMMAND pwd
#                              COMMAND ${GIT_EXECUTABLE} status
#                              WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
#                              DEPENDEES fetch)
#     externalproject_add_steptargets(${_name} status)
#     add_dependencies(pull-all ${_name}-pull)
#
#     externalproject_add_step(${_name} pull
#                              COMMAND ${GIT_EXECUTABLE} pull --rebase
#                              WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
#                              COMMENT "Performing pull step for '${_name}'"
#                              DEPENDEES fetch)
#     externalproject_add_steptargets(${_name} pull)
#     add_dependencies(pull-all ${_name}-pull)

endmacro()


################################################################################
# YCM_BOOTSTRAP

macro(YCM_BOOTSTRAP)
    ycm_ep_helper(YCM TYPE GIT
                      STYLE GITHUB
                      REPOSITORY robotology/ycm.git
                      TAG master)

    if(NOT DEFINED YCM_BOOTSTRAPPED)

        message(STATUS "Performing download step (git clone) for 'YCM'")
        execute_process(COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/external/YCM/CMakeFiles/CMakeTmp/YCM-gitclone.cmake
                        OUTPUT_QUIET
                        ERROR_QUIET
                        RESULT_VARIABLE _result)
        if(_result)
            message(FATAL_ERROR "Cannot clone YCM repository (${_result})")
        endif()

#         message(STATUS "Performing update step for 'YCM'")
#         execute_process(COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/external/YCM/CMakeFiles/CMakeTmp/YCM-gitupdate.cmake
#                         OUTPUT_QUIET
#                         ERROR_QUIET
#                         RESULT_VARIABLE _result)
#         if(_result)
#             message(FATAL_ERROR "Cannot update YCM repository")
#         endif()

        message(STATUS "Performing configure step for 'YCM'")
        file(READ ${CMAKE_BINARY_DIR}/external/YCM/CMakeFiles/CMakeTmp/YCM-cfgcmd.txt _cmd)
        string(STRIP "${_cmd}" _cmd)
        string(REGEX REPLACE "^cmd='(.+)'" "\\1" _cmd "${_cmd}")
        execute_process(COMMAND ${_cmd}
                        WORKING_DIRECTORY ${YCM_BINARY_DIR}
                        OUTPUT_QUIET
                        RESULT_VARIABLE _result)
        if(_result)
            message(FATAL_ERROR "Cannot configure YCM repository")
        endif()

        message(STATUS "Performing uninstall step for 'YCM'")
        execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target uninstall
                        WORKING_DIRECTORY ${YCM_BINARY_DIR}
                        OUTPUT_QUIET
                        RESULT_VARIABLE _result)
        # If uninstall fails, YCM was not previously installed,
        # therefore do not fail with error

        message(STATUS "Performing build step for 'YCM'")
        execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR}
                        WORKING_DIRECTORY ${YCM_BINARY_DIR}
                        OUTPUT_QUIET
                        RESULT_VARIABLE _result)
        if(_result)
            message(FATAL_ERROR "Cannot build YCM")
        endif()

        message(STATUS "Performing install step for 'YCM'")
        execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target install
                        WORKING_DIRECTORY ${YCM_BINARY_DIR}
                        OUTPUT_QUIET
                        RESULT_VARIABLE _result)
        if(_result)
            message(FATAL_ERROR "Cannot install YCM")
        endif()

        set(YCM_BOOTSTRAPPED 1 CACHE INTERNAL "")
    endif()

    # Find the package, so that can be used now.
    find_package(YCM PATHS ${YCM_INSTALL_DIR} NO_DEFAULT_PATH)
    # Reset YCM_DIR variable so that next find_package will fail to locate the package and this will be kept updated
    set(YCM_DIR "YCM_DIR-NOTFOUND" CACHE PATH "The directory containing a CMake configuration file for YCM." FORCE)

endmacro()

