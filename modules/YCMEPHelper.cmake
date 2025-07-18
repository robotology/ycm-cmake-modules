# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
YCMEPHelper
-----------

A helper for :module:`ExternalProject`::

 ycm_ep_helper(<name>
   [DOCS]
   [TYPE <type>]
   [STYLE <style>]
   [COMPONENT <component>] (default = "external")
   [FOLDER <folder>] (default = "<component>")
   [PROJECT_FOLDER_NAME <[project_folder_name]>] (default = "<name>")
   [REPOSITORY <repo>]
   [EXCLUDE_FROM_ALL <0|1>]
  #--Git only arguments-----------
   [SHALLOW <bool>]
  #--Git and Hg only arguments-----------
   [TAG <tag>]
  #--Svn only arguments-----------
   [REVISION <revision>]
   [USERNAME <username>]
   [PASSWORD <password>]
   [TRUST_CERT <0|1>]
  #--CMake arguments---------
   [CMAKE_GENERATOR]
   [CMAKE_GENERATOR_PLATFORM]
   [CMAKE_GENERATOR_TOOLSET]
   [CMAKE_GENERATOR_INSTANCE]
   [CMAKE_ARGS]
   [CMAKE_CACHE_ARGS]
   [CMAKE_CACHE_DEFAULT_ARGS]
   [DEPENDS]
   [DOWNLOAD_COMMAND]
   [UPDATE_COMMAND]
   [PATCH_COMMAND]
   [CONFIGURE_COMMAND]
   [BUILD_COMMAND]
   [BUILD_ALWAYS] (default = TRUE, while for ExternalProject the default is FALSE)
   [INSTALL_COMMAND]
   [TEST_COMMAND]
   [CLEAN_COMMAND] (not in ExternalProject)
   [TEST_AFTER_INSTALL]
   [TEST_BEFORE_INSTALL]
   [TEST_EXCLUDE_FROM_MAIN]
   )

   The location of the source directory by default is ``${CMAKE_SOURCE_DIR}/<component>/<name>``,
   while the build directory by default is ``${CMAKE_BINARY_DIR}/<component>/<name>``
   The ``<component>`` folder can be overriden with the ``FOLDER`` parameter, while the name part
   can be overriden by the ``PROJECT_FOLDER_NAME``.


 YCM_BOOTSTRAP()

.. variable:: NON_INTERACTIVE_BUILD

.. variable:: YCM_BOOTSTRAP_BASE_ADDRESS

.. variable:: YCM_SKIP_HASH_CHECK

.. variable:: YCM_BOOTSTRAP_VERBOSE

.. variable:: YCM_EP_INSTALL_DIR

.. variable:: YCM_EP_ADDITIONAL_CMAKE_ARGS

.. variable:: YCM_<COMPONENT>_COLOR

.. variable:: YCM_<COMPONENT>_BGCOLOR

.. variable:: YCM_<COMPONENT>_NODECOLOR

TODO Add variable YCM_INSTALL_PREFIX
#]=======================================================================]

if(DEFINED __YCMEPHELPER_INCLUDED)
  return()
endif()
set(__YCMEPHELPER_INCLUDED TRUE)

# Handle CMP0114 (see https://cmake.org/cmake/help/latest/policy/CMP0114.html
# and https://github.com/robotology/ycm-cmake-modules/pull/452)
get_property(_yeph_YCM_USE_CMAKE_NEXT GLOBAL PROPERTY YCM_USE_CMAKE_NEXT)

if(_yeph_YCM_USE_CMAKE_NEXT OR CMAKE_VERSION VERSION_LESS 3.18)
  # If we are using the vendored ExternalProject or CMake is 3.16 or 3.17, let's use NO_DEPENDS
  set_property(GLOBAL PROPERTY _yeph_NO_DEPENDS "NO_DEPENDS")
  set_property(GLOBAL PROPERTY _yeph_INDEPENDENT "")
else()
  # Otherwise let's use INDEPENDENT
  set_property(GLOBAL PROPERTY _yeph_NO_DEPENDS "")
  set_property(GLOBAL PROPERTY _yeph_INDEPENDENT "INDEPENDENT")
endif()




########################################################################
# Hashes of YCM files to be checked

# Files downloaded during YCM bootstrap
set(_ycm_CMakeParseArguments_sha1sum 0c4d3f7ed248145cbeb67cbd6fd7190baf2e4517)
set(_ycm_ExternalProject_sha1sum     ba8c547caa118c5ace50857c7839f76914926ef7)

# Files in all projects that need to bootstrap YCM
set(_ycm_IncludeUrl_sha1sum          997de3554f0d03ae22952a64fe26cdad118e8199)
set(_ycm_YCMBootstrap_sha1sum        59c6dfc84ec36518c5be5aef13af252a8250bad7)


########################################################################
# _YCM_INCLUDE
#
# Internal macro to include files from cmake-next.
# If YCM was not found, we are bootstrapping, therefore we need to
# download and use these modules instead of the ones found by cmake
# This must be a macro and not a function in order not to enclose in a
# new scope the variables added by the included files.

macro(_YCM_INCLUDE _module)
  if(YCM_FOUND OR DEFINED __USEYCMFROMSOURCE_INCLUDED)
    include(${_module})
  else()
    # We assume that YCMEPHelper was included using include_url, or that at
    # least the IncludeUrl module can be found by CMake.
    if(NOT COMMAND include_url)
      include(IncludeUrl)
    endif()
    unset(_expected_hash_args)
    if(NOT YCM_SKIP_HASH_CHECK)
      set(_expected_hash_args EXPECTED_HASH SHA1=${_ycm_${_module}_sha1sum})
    endif()
    include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/cmake-next/proposed/${_module}.cmake
                ${_expected_hash_args}
                DOWNLOAD_ONCE
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

  unset(_error_message)

  # FIXME is there a way to find the module without including it?
  include(${_module} RESULT_VARIABLE _module_file OPTIONAL)
  if(_module_file)
    file(SHA1 ${_module_file} _module_sha1sum)
    if(NOT "${_module_sha1sum}" STREQUAL "${_ycm_${_module}_sha1sum}")
      set(_error_message "YCM_BOOTSTRAP HASH mismatch
  for file: [${_module_file}]
    expected hash: [${_ycm_${_module}_sha1sum}]
      actual hash: [${_module_sha1sum}]
Perhaps it is outdated or you have local modification. Please consider upgrading it, or contributing your changes to YCM.
")
      if(WIN32)
        file(READ ${_module_file} _tmp)
        # On windows, the file could have windows-style EOL
        # This should work for any git configuration for core.autocrlf
        string(REPLACE "/r/n" "/n" _tmp "${_tmp}")
        string(SHA1 _module_sha1sum "${_tmp}")
        if("${_module_sha1sum}" STREQUAL "${_ycm_${_module}_sha1sum}")
          unset(_error_message)
        endif()
      endif()
    endif()

    if(DEFINED _error_message)
      message(AUTHOR_WARNING ${_error_message})
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

  if(NOT NON_INTERACTIVE_BUILD)
    # Non interactive builds should always perform the update step
    set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED 1)
  endif()
  set_property(DIRECTORY PROPERTY CMAKE_PARSE_ARGUMENTS_DEFAULT_SKIP_EMPTY FALSE)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)

  # Disable CMake cache registry.
  set(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY 1)
  set(CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY 1)

  option(YCM_EP_EXPERT_MODE "Enable all targets for projects in development mode" OFF)
  option(YCM_EP_MAINTAINER_MODE "Enable all targets for projects in development mode" OFF)
  mark_as_advanced(YCM_EP_EXPERT_MODE
                   YCM_EP_MAINTAINER_MODE)

  if("${CMAKE_GENERATOR}" MATCHES "^(Visual Studio|Xcode)")
    set(_update-all ALL_UPDATE)
    set(_fetch-all ALL_FETCH)
    set(_status-all ALL_STATUS)
    set(_clean-all ALL_CLEAN)
    set(_print-directories-all ALL_PRINT_DIRECTORIES)
  else()
    set(_update-all update-all)
    set(_fetch-all fetch-all)
    set(_status-all status-all)
    set(_clean-all clean-all)
    set(_print-directories-all print-directories-all)
  endif()

  if(NOT (YCM_FOUND OR DEFINED __USEYCMFROMSOURCE_INCLUDED)) # Useless if we don't need to bootstrap
    set(YCM_BOOTSTRAP_BASE_ADDRESS "https://raw.github.com/robotology/ycm/HEAD/" CACHE STRING "Base address of YCM repository")
    mark_as_advanced(YCM_BOOTSTRAP_BASE_ADDRESS)
  endif()

  # Install directory for all sub-projects
  # TODO Make this a cached variable for installation outside build
  #      directory
  set(YCM_EP_INSTALL_DIR "${CMAKE_BINARY_DIR}/install" CACHE PATH "Path to the superbuild installation directory. WARNING: If this path is not writable by the user, you will have to build as superuser")
  mark_as_advanced(YCM_EP_INSTALL_DIR)

  set(YCM_EP_ADDITIONAL_CMAKE_ARGS "" CACHE STRING "Additional CMake arguments that are passed to all CMake subprojects of the superbuild.")
  mark_as_advanced(YCM_EP_ADDITIONAL_CMAKE_ARGS)

  # ExternalProject does not handle correctly arguments containing ";" passed
  # using CMAKE_ARGS, and instead splits them into several arguments. This is
  # a workaround that replaces ";" with "|" and sets LIST_SEPARATOR "|" in
  # order to interpret them correctly.
  #
  # TODO FIXME check what happens when the "*_COMMAND" arguments are passed.
  file(TO_CMAKE_PATH "$ENV{CMAKE_PREFIX_PATH}" _CMAKE_PREFIX_PATH)
  list(INSERT _CMAKE_PREFIX_PATH 0 ${YCM_EP_INSTALL_DIR})
  list(REMOVE_DUPLICATES _CMAKE_PREFIX_PATH)
  string(REPLACE ";" "|" _CMAKE_PREFIX_PATH "${_CMAKE_PREFIX_PATH}")
  set(_YCM_EP_ALL_CMAKE_ARGS LIST_SEPARATOR "|")
  # YCM_EP_ADDITIONAL_CMAKE_ARGS contains the specified CMake options in a human-readable form,
  # so different options are separated by spaces, while lists are separated by ";", for example
  # -DYCM_EP_ADDITIONAL_CMAKE_ARGS:STRING="-DBUILD_TESTING:BOOL=ON -DTYPE_SUPPORTED=ZIP;QTIFW"
  # For this reason, first we substitute ";"  with "|", and only later " " with ";"
  set(_YCM_EP_ADDITIONAL_CMAKE_ARGS ${YCM_EP_ADDITIONAL_CMAKE_ARGS})
  string(REPLACE ";" "|" _YCM_EP_ADDITIONAL_CMAKE_ARGS "${_YCM_EP_ADDITIONAL_CMAKE_ARGS}")
  string(REPLACE " " ";" _YCM_EP_ADDITIONAL_CMAKE_ARGS "${_YCM_EP_ADDITIONAL_CMAKE_ARGS}")

  # Default CMAKE_ARGS (Passed to the command line)
  set(_YCM_EP_CMAKE_ARGS "--no-warn-unused-cli"
                         "-DCMAKE_PREFIX_PATH:PATH=${_CMAKE_PREFIX_PATH}") # Path used by cmake for finding stuff
  list(APPEND _YCM_EP_CMAKE_ARGS ${_YCM_EP_ADDITIONAL_CMAKE_ARGS})

  # If CMAKE_EXPORT_COMPILE_COMMANDS is defined, pass it along to the sub-projects
  # See https://github.com/robotology/robotology-superbuild/issues/1596
  if(DEFINED CMAKE_EXPORT_COMPILE_COMMANDS AND CMAKE_EXPORT_COMPILE_COMMANDS)
    list(APPEND _YCM_EP_CMAKE_ARGS "-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=${CMAKE_EXPORT_COMPILE_COMMANDS}")
  endif()

  # If CMAKE_LINKER_TYPE is defined, pass it along to sub-projects
  # this is done, as differently from compilers, there is no environment variable that is read
  # by cmake to specify which compiler to use
  if(DEFINED CMAKE_LINKER_TYPE)
    list(APPEND _YCM_EP_CMAKE_ARGS "-DCMAKE_LINKER_TYPE:PATH=${CMAKE_LINKER_TYPE}")
  endif()

  # Default CMAKE_CACHE_ARGS (Initial cache, forced)
  set(_YCM_EP_CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${YCM_EP_INSTALL_DIR}") # Where to do the installation

  if(DEFINED CMAKE_TOOLCHAIN_FILE)
    list(APPEND _YCM_EP_CMAKE_CACHE_ARGS "-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}")
  endif()

  # Default CMAKE_CACHE_DEFAULT_ARGS (Initial cache, default)
  unset(_YCM_EP_CMAKE_CACHE_DEFAULT_ARGS)
  if(NOT CMAKE_BUILD_TYPE STREQUAL "") # CMAKE_BUILD_TYPE is always defined
    list(APPEND _YCM_EP_CMAKE_CACHE_DEFAULT_ARGS "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}") # If there is a CMAKE_BUILD_TYPE it is important to ensure it is passed down.
  endif()
  if(DEFINED CMAKE_SKIP_RPATH)
    list(APPEND _YCM_EP_CMAKE_CACHE_DEFAULT_ARGS "-DCMAKE_SKIP_RPATH:PATH=${CMAKE_SKIP_RPATH}")
  endif()
  if(DEFINED CMAKE_SKIP_INSTALL_RPATH)
    list(APPEND _YCM_EP_CMAKE_CACHE_DEFAULT_ARGS "-DCMAKE_SKIP_INSTALL_RPATH:PATH=${CMAKE_SKIP_INSTALL_RPATH}")
  endif()
  if(DEFINED BUILD_SHARED_LIBS)
    list(APPEND _YCM_EP_CMAKE_CACHE_DEFAULT_ARGS "-DBUILD_SHARED_LIBS:PATH=${BUILD_SHARED_LIBS}")
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
  if(_error_code)
    set(_output_name "")
  endif()

  execute_process(COMMAND ${GIT_EXECUTABLE} config --get user.email
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                  RESULT_VARIABLE _error_code
                  OUTPUT_VARIABLE _output_email
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(_error_code)
    set(_output_email "")
  endif()

  set(YCM_GIT_COMMIT_NAME "${_output_name}" CACHE STRING "Name to use for git commits")
  set(YCM_GIT_COMMIT_EMAIL "${_output_email}" CACHE STRING "Email address to use for git commits")
  mark_as_advanced(YCM_GIT_COMMIT_NAME YCM_GIT_COMMIT_EMAIL)
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
endfunction()


########################################################################
# _YCM_SETUP_HG
#
# Internal function to perform HG setup.

unset(__YCM_HG_SETUP_CALLED CACHE)
function(_YCM_SETUP_HG)
  if(DEFINED __YCM_HG_SETUP_CALLED)
    return()
  endif()
  set(__YCM_GIT_SETUP_CALLED 1 CACHE INTERNAL "")

  find_package(Hg QUIET)
  if(NOT HG_EXECUTABLE)
    message(FATAL_ERROR "Please install Mercurial")
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_UPDATE_STEP
#
# Add "update" step for any repository.

function(_YCM_EP_ADD_UPDATE_STEP)
  if(NOT TARGET ${_update-all})
    add_custom_target(${_update-all})
    set_property(TARGET ${_update-all} PROPERTY FOLDER "YCMTargets")
  endif()

  get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)

  # The update step is automatically created, we just need to explicitly
  # make it a target
  ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} update)
  add_dependencies(${_update-all} ${_name}-update)
endfunction()


########################################################################
# _YCM_EP_ADD_CONFIGURE_STEP
#
# Add "configure" step for any repository.

function(_YCM_EP_ADD_CONFIGURE_STEP)
  # The configure step is automatically created, we just need to explicitly
  # make it a target
  ExternalProject_Add_StepTargets(${_name} configure)
endfunction()


########################################################################
# _YCM_EP_ADD_TEST_STEP
#
# Add "test" step for any repository.

function(_YCM_EP_ADD_TEST_STEP)
  if(DEFINED _YH_${_name}_TEST_COMMAND
     OR _YH_${_name}_TEST_BEFORE_INSTALL
     OR _YH_${_name}_TEST_AFTER_INSTALL
     OR _YH_${_name}_TEST_EXCLUDE_FROM_MAIN)
    # The test step is automatically created if one of the test
    # variables is set, we just need to explicitly make it a target
    ExternalProject_Add_StepTargets(${_name} test)

    # The test target does not exist, therefore add_dependencies
    # cannot be used. Instead we add a test.
    add_test(NAME ${_name}_test
             COMMAND ${CMAKE_COMMAND} --build ${CMAKE_CURRENT_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target ${_name}-test
             WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    set_property(TEST ${_name}_test APPEND PROPERTY LABELS ${_name})
    set_property(TEST ${_name}_test PROPERTY DEPENDS ${_name})
  endif()
endfunction()



########################################################################
# _YCM_EP_ADD_FETCH_STEP
#
# Add "fetch" step for git repositories.

function(_YCM_EP_ADD_FETCH_STEP _name)
  if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
    if(NOT TARGET ${_fetch-all})
      add_custom_target(${_fetch-all})
      set_property(TARGET ${_fetch-all} PROPERTY FOLDER "YCMTargets")
    endif()

    get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
    get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

    ExternalProject_Add_Step(${_name} fetch
                             COMMAND ${GIT_EXECUTABLE} fetch --all --prune
                             WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                             COMMENT "Performing fetch step for '${_name}'"
                             DEPENDEES download
                             ${_yeph_INDEPENDENT}
                             EXCLUDE_FROM_MAIN 1
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} fetch)
    add_dependencies(${_fetch-all} ${_name}-fetch)
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_STATUS_STEP
#
# Add "status" step for git, svn and hg repositories.

function(_YCM_EP_ADD_STATUS_STEP _name)
  unset(_cmd)
  if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
    set(_cmd COMMAND ${GIT_EXECUTABLE} status)
  elseif("${_YH_${_name}_TYPE}" STREQUAL "SVN")
    set(_cmd COMMAND ${Subversion_SVN_EXECUTABLE} status)
  elseif("${_YH_${_name}_TYPE}" STREQUAL "HG")
    set(_cmd COMMAND ${HG_EXECUTABLE} status)
  endif()

  if(DEFINED _cmd)
    if(NOT TARGET ${_status-all})
      add_custom_target(${_status-all})
      set_property(TARGET ${_status-all} PROPERTY FOLDER "YCMTargets")
    endif()

    get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
    get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

    if(CMAKE_GENERATOR STREQUAL "Unix Makefiles")
      set(_command_echo_color_if_supported cmake_echo_color --switch=$\(COLOR\) --cyan)
    else()
      set(_command_echo_color_if_supported "echo")
    endif()

    ExternalProject_Get_Property(${_name} source_dir)
    ExternalProject_Add_Step(${_name} status
                             COMMAND ${CMAKE_COMMAND} -E ${_command_echo_color_if_supported} "Working directory: ${source_dir}"
                             ${_cmd}
                             WORKING_DIRECTORY ${source_dir}
                             DEPENDEES download
                             ${_yeph_INDEPENDENT}
                             EXCLUDE_FROM_MAIN 1
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} status)
    add_dependencies(${_status-all} ${_name}-status)
    unset(_cmd)
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_CLEAN_STEP
#
# Add "clean" step for any repository.

function(_YCM_EP_ADD_CLEAN_STEP _name)
  unset(_cmd)
# FIXME is _YH_${_name}_CLEAN_COMMAND to the function?
# FIXME check if this works on MSVC and Xcode

  if(NOT DEFINED _YH_${_name}_CLEAN_COMMAND OR _YH_${_name}_CLEAN_COMMAND STREQUAL "_")
    set(_cmd ${CMAKE_COMMAND} --build ${${_name}_BINARY_DIR} --config ${CMAKE_CFG_INTDIR} --target clean)
  elseif(NOT "${_YH_${_name}_CLEAN_COMMAND}" STREQUAL "")
    set(_cmd ${_YH_${_name}_CLEAN_COMMAND})
  endif()
  if(DEFINED _cmd)
    if(NOT TARGET ${_clean-all})
      add_custom_target(${_clean-all})
      set_property(TARGET ${_clean-all} PROPERTY FOLDER "YCMTargets")
    endif()

    get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
    get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

    ExternalProject_Add_Step(${_name} clean
                             COMMAND ${_cmd}
                             WORKING_DIRECTORY ${${_name}_BINARY_DIR}
                             COMMENT "Performing clean step for '${_name}'"
                             DEPENDEES configure
                             EXCLUDE_FROM_MAIN 1
                             ${_yeph_INDEPENDENT}
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} clean)
    add_dependencies(${_clean-all} ${_name}-clean)
    unset(_cmd)
  endif()
endfunction()

########################################################################
# _YCM_EP_ADD_DEPENDEES_STEPS
#
# Add "dependees" and "dependees-update" steps for all the `DEPENDS` of any
# repository, if these are in development mode.

function(_YCM_EP_ADD_DEPENDEES_STEPS _name)
  get_property(_depends_set TARGET ${_name} PROPERTY _EP_DEPENDS SET)

  get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
  get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

  if(_depends_set)
    get_property(_binary_dir TARGET ${_name} PROPERTY _EP_BINARY_DIR)
    get_property(_depends TARGET ${_name} PROPERTY _EP_DEPENDS)

    # dependees step (build all packages required by this package)
    ExternalProject_Add_Step(${_name} dependees
                             WORKING_DIRECTORY ${_binary_dir}
                             COMMENT "Dependencies for '${_name}' built."
                             EXCLUDE_FROM_MAIN 1
                             ${_yeph_INDEPENDENT}
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} dependees)
    foreach(_dep ${_depends})
      if(TARGET ${_dep})
        ExternalProject_Add_StepDependencies(${_name} dependees ${_dep})
      endif()
    endforeach()

    # dependees-update step (update all packages required by this package)
    ExternalProject_Add_Step(${_name} dependees-update
                             WORKING_DIRECTORY ${binary_dir}
                             COMMENT "Dependencies for '${_name}' updated."
                             EXCLUDE_FROM_MAIN 1
                             ${_yeph_INDEPENDENT}
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} dependees-update)
    foreach(_dep ${_depends})
      if(TARGET ${_dep}-update) # only if the target update exists for the dependency
        ExternalProject_Add_StepDependencies(${_name} dependees-update ${_dep}-update)
      endif()
    endforeach()
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_DEPENDERS_STEPS
#
# Add "dependers" and "dependers-update" steps for any "DEPENDS" of this
# repository.

function(_YCM_EP_ADD_DEPENDERS_STEPS _name)
  get_property(_depends_set TARGET ${_name} PROPERTY _EP_DEPENDS SET)

  get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
  get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

  if(_depends_set)
    get_property(_depends TARGET ${_name} PROPERTY _EP_DEPENDS)
    foreach(_dep ${_depends})
      if(TARGET ${_dep})
        get_property(is_ep TARGET ${_dep} PROPERTY _EP_IS_EXTERNAL_PROJECT)
        if(is_ep)
          if(YCM_EP_DEVEL_MODE_${_dep} OR YCM_EP_MAINTAINER_MODE)
            get_property(_dep_binary_dir TARGET ${_dep} PROPERTY _EP_BINARY_DIR)

            # dependers step (build all packages that require this package)
            if(NOT TARGET ${_dep}-dependers)
              ExternalProject_Add_Step(${_dep} dependers
                                       WORKING_DIRECTORY ${_dep_binary_dir}
                                       COMMENT "Dependers for '${_dep}' built."
                                       EXCLUDE_FROM_MAIN 1
                                       ${_yeph_INDEPENDENT}
                                       ALWAYS 1)
              ExternalProject_Add_StepTargets(${_dep} ${_yeph_NO_DEPENDS} dependers)
            endif()
            ExternalProject_Add_StepDependencies(${_dep} dependers ${_name})

            # dependers-update step (update all packages that require this package)
            if(TARGET ${_name}-update)
              if(NOT TARGET ${_dep}-dependers-update)
                ExternalProject_Add_Step(${_dep} dependers-update
                                         WORKING_DIRECTORY ${${_dep}_BINARY_DIR}
                                         COMMENT "Dependers for '${_dep}' updated."
                                         EXCLUDE_FROM_MAIN 1
                                         ${_yeph_INDEPENDENT}
                                         ALWAYS 1)
                ExternalProject_Add_StepTargets(${_dep} ${_yeph_NO_DEPENDS} dependers-update)
              endif()
              ExternalProject_Add_StepDependencies(${_dep} dependers-update ${_name}-update)
            endif()
          endif()
        endif()
      endif()
    endforeach()
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_EDIT_CACHE_STEP
#
# Add "edit_cache" step for cmake repositories.

function(_YCM_EP_ADD_EDIT_CACHE_STEP _name)
  # edit cache target for cmake projects
  _ep_get_configure_command_id(${_name} _${_name}_configure_command_id)
  if(_${_name}_configure_command_id STREQUAL "cmake")

    get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
    get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

    get_property(_source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)
    get_property(_source_subdir TARGET ${_name} PROPERTY _EP_SOURCE_SUBDIR)
    get_property(_binary_dir TARGET ${_name} PROPERTY _EP_BINARY_DIR)

    ExternalProject_Add_Step(${_name} edit_cache
                             COMMAND ${CMAKE_EDIT_COMMAND} -H${_source_dir}${_source_subdir} -B${_binary_dir}
                             WORKING_DIRECTORY ${_binary_dir}
                             DEPENDEES configure
                             EXCLUDE_FROM_MAIN 1
                             COMMENT "Running CMake cache editor for ${_name}..."
                             ${_yeph_INDEPENDENT}
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} edit_cache)
  endif()
endfunction()


########################################################################
# _YCM_EP_ADD_PRINT_DIRECTORIES_STEP
#
# Add "print-directories" step for any repository.
# This step prints source and build directories for an external project.

function(_YCM_EP_ADD_PRINT_DIRECTORIES_STEP _name)
  if(NOT TARGET ${_print-directories-all})
    add_custom_target(${_print-directories-all})
    set_property(TARGET ${_print-directories-all} PROPERTY FOLDER "YCMTargets")
  endif()

  get_property(_source_dir TARGET ${_name} PROPERTY _EP_SOURCE_DIR)
  get_property(_source_subdir TARGET ${_name} PROPERTY _EP_SOURCE_SUBDIR)
  get_property(_binary_dir TARGET ${_name} PROPERTY _EP_BINARY_DIR)
  get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
  get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

  if(CMAKE_GENERATOR STREQUAL "Unix Makefiles")
    set(_command_echo_color_if_supported "cmake_echo_color --switch=$\(COLOR\) --cyan")
  else()
    set(_command_echo_color_if_supported "echo")
  endif()

  if("${_source_dir}" STREQUAL "${_source_subdir}")
    set(_source_cmd COMMAND ${CMAKE_COMMAND} -E ${_command_echo_color_if_supported} "${_name} SOURCE directory: "
                    COMMAND ${CMAKE_COMMAND} -E echo "    ${_source_dir}")
  else()
    set(_source_cmd COMMAND ${CMAKE_COMMAND} -E ${_command_echo_color_if_supported} "${_name} REPOSITORY directory: "
                    COMMAND ${CMAKE_COMMAND} -E echo "    ${_source_dir}"
                    COMMAND ${CMAKE_COMMAND} -E echo ""
                    COMMAND ${CMAKE_COMMAND} -E ${_command_echo_color_if_supported} "${_name} SOURCE directory: "
                    COMMAND ${CMAKE_COMMAND} -E echo "    ${_source_subdir}")
  endif()
  set(_binary_cmd COMMAND ${CMAKE_COMMAND} -E ${_command_echo_color_if_supported} "${_name} BINARY directory: "
                  COMMAND ${CMAKE_COMMAND} -E echo "    ${_binary_dir}")

  ExternalProject_Add_Step(${_name} print-directories
                           COMMAND ${CMAKE_COMMAND} -E echo ""
                           ${_source_cmd}
                           COMMAND ${CMAKE_COMMAND} -E echo ""
                           ${_binary_cmd}
                           COMMAND ${CMAKE_COMMAND} -E echo ""
                           WORKING_DIRECTORY ${_source_dir}
                           EXCLUDE_FROM_MAIN 1
                           COMMENT "Directories for ${_name}"
                           ${_yeph_INDEPENDENT}
                           ALWAYS 1)
  ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} print-directories)
  add_dependencies(${_print-directories-all} ${_name}-print-directories)
endfunction()


########################################################################
# _YCM_EP_ADD_OPEN_STEP
#
# Add "open" step for any repository.
# This step opens the external project for editing

function(_YCM_EP_ADD_OPEN_STEP _name)
  get_property(_binary_dir TARGET ${_name} PROPERTY _EP_BINARY_DIR)

  unset(_cmd)
  if("${CMAKE_GENERATOR}" MATCHES "Xcode")
    set(_cmd open "${_binary_dir}/${_name}.xcodeproj")
  elseif("${CMAKE_GENERATOR}" MATCHES "Visual Studio")
    set(_cmd "${_binary_dir}/${_name}.sln")
  endif()

  if(DEFINED _cmd)
    get_property(_yeph_NO_DEPENDS GLOBAL PROPERTY _yeph_NO_DEPENDS)
    get_property(_yeph_INDEPENDENT GLOBAL PROPERTY _yeph_INDEPENDENT)

    ExternalProject_Add_Step(${_name} open
                             COMMAND ${CMAKE_COMMAND} -E echo \"\"
                             COMMAND ${_cmd}
                             WORKING_DIRECTORY "${_binary_dir}"
                             DEPENDEES configure
                             EXCLUDE_FROM_MAIN 1
                             COMMENT "Opening ${_name}..."
                             ${_yeph_INDEPENDENT}
                             ALWAYS 1)
    ExternalProject_Add_StepTargets(${_name} ${_yeph_NO_DEPENDS} open)
  endif()
endfunction()

########################################################################
# _YCM_EP_ADD_INSTALLATION
#
# Add the project to the "install" target in the main build.
# This by default works only for CMake projects, but project using other
# build systems can be enabled by just by creating a
# `cmake_install.cmake` file in the build directory.

function(_YCM_EP_ADD_INSTALLATION _name)
  get_property(_binary_dir TARGET ${_name} PROPERTY _EP_BINARY_DIR)

  install(CODE "if(NOT CMAKE_INSTALL_LOCAL_ONLY AND EXISTS \"${_binary_dir}/cmake_install.cmake\")
    include(\"${_binary_dir}/cmake_install.cmake\")
  endif()"
          COMPONENT ${_name})
endfunction()



########################################################################
# _YCM_EP_WRITE_GITCLONE_SCRIPT
#
# Helper function to generate a gitclone script for download repos without deleting it
# inspired from https://gitlab.kitware.com/cmake/cmake/-/blob/v3.30.2/Modules/ExternalProject/shared_internal_commands.cmake#L381

function(_ycm_ep_write_gitclone_script
  script_filename
  source_dir
  git_EXECUTABLE
  git_repository
  git_tag
  git_remote_name
  init_submodules
  git_submodules_recurse
  git_submodules
  git_shallow
  git_progress
  git_config
  src_name
  work_dir
  gitclone_infofile
  gitclone_stampfile
  tls_version
  tls_verify
)

  if(NOT GIT_VERSION_STRING VERSION_LESS 1.8.5)
    # Use `git checkout <tree-ish> --` to avoid ambiguity with a local path.
    set(git_checkout_explicit-- "--")
  else()
    # Use `git checkout <branch>` even though this risks ambiguity with a
    # local path.  Unfortunately we cannot use `git checkout <tree-ish> --`
    # because that will not search for remote branch names, a common use case.
    set(git_checkout_explicit-- "")
  endif()
  if("${git_tag}" STREQUAL "")
    message(FATAL_ERROR "Tag for git checkout should not be empty.")
  endif()

  if(GIT_VERSION_STRING VERSION_LESS 2.20 OR
    2.21 VERSION_LESS_EQUAL GIT_VERSION_STRING)
    set(git_clone_options "--no-checkout")
  else()
    set(git_clone_options)
  endif()
  if(git_shallow)
    if(NOT GIT_VERSION_STRING VERSION_LESS 1.7.10)
      list(APPEND git_clone_options "--depth 1 --no-single-branch")
    else()
      list(APPEND git_clone_options "--depth 1")
    endif()
  endif()
  if(git_progress)
    list(APPEND git_clone_options --progress)
  endif()
  foreach(config IN LISTS git_config)
    list(APPEND git_clone_options --config \"${config}\")
  endforeach()
  if(NOT ${git_remote_name} STREQUAL "origin")
    list(APPEND git_clone_options --origin \"${git_remote_name}\")
  endif()

  # The clone config option is sticky, it will apply to all subsequent git
  # update operations. The submodules config option is not sticky, because
  # git doesn't provide any way to do that. Thus, we will have to pass the
  # same config option in the update step too for submodules, but not for
  # the main git repo.
  set(git_submodules_config_options "")
  if(NOT "x${tls_version}" STREQUAL "x")
    list(APPEND git_clone_options -c http.sslVersion=tlsv${tls_version})
    list(APPEND git_submodules_config_options -c http.sslVersion=tlsv${tls_version})
  endif()
  if(NOT "x${tls_verify}" STREQUAL "x")
    if(tls_verify)
      # Default git behavior is "true", but the user might have changed the
      # global default to "false". Since TLS_VERIFY was given, ensure we honor
      # the specified setting regardless of what the global default might be.
      list(APPEND git_clone_options -c http.sslVerify=true)
      list(APPEND git_submodules_config_options -c http.sslVerify=true)
    else()
      list(APPEND git_clone_options -c http.sslVerify=false)
      list(APPEND git_submodules_config_options -c http.sslVerify=false)
    endif()
  endif()

  string (REPLACE ";" " " git_clone_options "${git_clone_options}")

  # Once we can require CMake >= 3.17 this can be substituted with ${CMAKE_CURRENT_FUNCTION_LIST_DIR}
  configure_file(
    ${YCM_MODULE_DIR}/modules/YCMEPHelper/gitsafeclone.txt.in
    ${script_filename}
    @ONLY
  )
endfunction()


########################################################################
# YCM_EP_HELPER
#
# Helper function to add a repository using ExternalProject

function(YCM_EP_HELPER _name)
  # Adding target twice is not allowed
  if(TARGET ${_name})
    message(WARNING "Failed to add target ${_name}. A target with the same name already exists.!!!")
    return()
  endif()
  # Check arguments
  set(_options )
  set(_oneValueArgs TYPE
                    STYLE
                    COMPONENT
                    FOLDER
                    PROJECT_FOLDER_NAME
                    EXCLUDE_FROM_ALL
                    SHALLOW     # GIT only
                    REPOSITORY  # GIT, SVN and HG
                    TAG         # GIT and HG only
                    REVISION    # SVN only
                    USERNAME    # SVN only
                    PASSWORD    # SVN only
                    TRUST_CERT  # SVN only
                    TEST_BEFORE_INSTALL
                    TEST_AFTER_INSTALL
                    TEST_EXCLUDE_FROM_MAIN
                    CONFIGURE_SOURCE_DIR # DEPRECATED Since YCM 0.10
                    SOURCE_SUBDIR
                    CMAKE_GENERATOR
                    CMAKE_GENERATOR_PLATFORM
                    CMAKE_GENERATOR_TOOLSET
                    CMAKE_GENERATOR_INSTANCE
                    BUILD_ALWAYS)
  set(_multiValueArgs CMAKE_ARGS
                      CMAKE_CACHE_ARGS
                      CMAKE_CACHE_DEFAULT_ARGS
                      DEPENDS
                      DOWNLOAD_COMMAND
                      UPDATE_COMMAND
                      PATCH_COMMAND
                      CONFIGURE_COMMAND
                      BUILD_COMMAND
                      INSTALL_COMMAND
                      TEST_COMMAND
                      CLEAN_COMMAND)

  cmake_parse_arguments(_YH_${_name} "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" "${ARGN}")
  # HACK: set(var "" PARENT_SCOPE) before CMake 3.0.0 did not set an empty
  #       string, but instead unset the variable.
  #       For compatibility with older versions, cmake_parse_arguments, keeps
  #       the same behaviour, therefore they are not set.
  foreach(_step DOWNLOAD
                UPDATE
                PATCH
                CONFIGURE
                BUILD
                INSTALL
                TEST
                CLEAN)
    if("${ARGN}" MATCHES ";?${_step}_COMMAND;" AND NOT DEFINED _YH_${_name}_${_step}_COMMAND)
      set(_YH_${_name}_${_step}_COMMAND "")
    endif()
  endforeach()

  # Allow to override parameters by setting variables
  foreach(_arg ${_oneValueArgs} ${_multiValueArgs})
    if(DEFINED ${_name}_${_arg})
      set(_YH_${_name}_${_arg} ${${_name}_${_arg}})
    endif()
  endforeach()


  # Check that all required arguments are set
  if(NOT DEFINED _YH_${_name}_TYPE)
    message(FATAL_ERROR "Missing TYPE argument")
  endif()
  if(NOT "x${_YH_${_name}_TYPE}" MATCHES "^x(GIT|SVN|HG)$")
    message(FATAL_ERROR "Unsupported VCS TYPE:\n  ${_YH_${_name}_TYPE}\n")
  endif()
  if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
    # TODO Check GIT arguments
  elseif("${_YH_${_name}_TYPE}" STREQUAL "SVN")
    # TODO Check SVN arguments
  elseif("${_YH_${_name}_TYPE}" STREQUAL "HG")
    # TODO Check HG arguments
  endif()

  if(NOT DEFINED _YH_${_name}_STYLE)
    message(FATAL_ERROR "Missing STYLE argument")
  endif()
  include(Style${_YH_${_name}_STYLE} OPTIONAL)

  if(NOT DEFINED _YH_${_name}_REPOSITORY)
    message(FATAL_ERROR "Missing REPOSITORY argument")
  endif()

  if(NOT DEFINED _YH_${_name}_COMPONENT)
    set(_YH_${_name}_COMPONENT external)
  elseif(_YH_${_name}_COMPONENT STREQUAL "build")
    message(AUTHOR_WARNING "Using \"build\" is dangerous, you should choose another name for the component.")
  endif()

  if(NOT DEFINED _YH_${_name}_FOLDER)
    set(_YH_${_name}_FOLDER "${_YH_${_name}_COMPONENT}")
  elseif(_YH_${_name}_FOLDER STREQUAL "build")
    message(AUTHOR_WARNING "Using \"build\" is dangerous, you should choose another name for the folder.")
  endif()

  if(NOT DEFINED _YH_${_name}_PROJECT_FOLDER_NAME)
    set(_YH_${_name}_PROJECT_FOLDER_NAME "${_name}")
  endif()

  # Generic variables
  set(${_name}_PREFIX ${CMAKE_BINARY_DIR}/${_YH_${_name}_FOLDER})
  set(${_name}_SOURCE_DIR ${CMAKE_SOURCE_DIR}/${_YH_${_name}_FOLDER}/${_YH_${_name}_PROJECT_FOLDER_NAME})
  set(${_name}_DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/${_YH_${_name}_FOLDER})
  set(${_name}_BINARY_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_FOLDER}/${_YH_${_name}_PROJECT_FOLDER_NAME})
  set(${_name}_INSTALL_DIR ${YCM_EP_INSTALL_DIR})
  set(${_name}_TMP_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_FOLDER}/${_YH_${_name}_PROJECT_FOLDER_NAME}${CMAKE_FILES_DIRECTORY}/YCMTmp)
  set(${_name}_STAMP_DIR ${CMAKE_BINARY_DIR}/${_YH_${_name}_FOLDER}/${_YH_${_name}_PROJECT_FOLDER_NAME}${CMAKE_FILES_DIRECTORY}/YCMStamp)

  set(${_name}_DIR_ARGS PREFIX ${${_name}_PREFIX}
                        SOURCE_DIR ${${_name}_SOURCE_DIR}
                        DOWNLOAD_DIR ${${_name}_DOWNLOAD_DIR}
                        BINARY_DIR ${${_name}_BINARY_DIR}
                        INSTALL_DIR ${${_name}_INSTALL_DIR}
                        TMP_DIR ${${_name}_TMP_DIR}
                        STAMP_DIR ${${_name}_STAMP_DIR})

  # CMAKE_ARGS (Passed to the command line)
  set(${_name}_CMAKE_ARGS CMAKE_ARGS ${_YCM_EP_CMAKE_ARGS})
  if(_YH_${_name}_CMAKE_ARGS)
    list(APPEND ${_name}_CMAKE_ARGS ${_YH_${_name}_CMAKE_ARGS})
  endif()

  # CMAKE_CACHE_ARGS (Initial cache, forced)
  set(${_name}_CMAKE_CACHE_ARGS CMAKE_CACHE_ARGS ${_YCM_EP_CMAKE_CACHE_ARGS})
  if(_YH_${_name}_CMAKE_CACHE_ARGS)
    list(APPEND ${_name}_CMAKE_CACHE_ARGS ${_YH_${_name}_CMAKE_CACHE_ARGS})
  endif()

  # CMAKE_CACHE_DEFAULT_ARGS (Initial cache, default)
  set(${_name}_CMAKE_CACHE_DEFAULT_ARGS CMAKE_CACHE_DEFAULT_ARGS ${_YCM_EP_CMAKE_CACHE_DEFAULT_ARGS})
  if(_YH_${_name}_CMAKE_CACHE_DEFAULT_ARGS)
    list(APPEND ${_name}_CMAKE_CACHE_DEFAULT_ARGS ${_YH_${_name}_CMAKE_CACHE_DEFAULT_ARGS})
  endif()

  # ALL_CMAKE_ARGS
  set(${_name}_ALL_CMAKE_ARGS ${_YCM_EP_ALL_CMAKE_ARGS})
  if(_YH_${_name}_ALL_CMAKE_ARGS)
    list(APPEND ${_name}_ALL_CMAKE_ARGS ${_YH_${_name}_ALL_CMAKE_ARGS})
  endif()

  list(APPEND ${_name}_ALL_CMAKE_ARGS ${${_name}_CMAKE_ARGS}
                                      ${${_name}_CMAKE_CACHE_ARGS}
                                      ${${_name}_CMAKE_CACHE_DEFAULT_ARGS})
  set(${_name}_CMAKE_ARGS ${${_name_ALL_CMAKE_ARGS}})
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
  if("${_YH_${_name}_COMPONENT}" STREQUAL "documentation")
    # Documentation component does not have a build step, unless
    # specified by the user.
    # The string "_" can be used to specify that the default command
    # should be left.
    foreach(_step CONFIGURE
                  BUILD
                  INSTALL)
      if(NOT DEFINED _YH_${_name}_${_step}_COMMAND)
        set(_YH_${_name}_${_step}_COMMAND "")
      elseif(_YH_${_name}_${_step}_COMMAND STREQUAL "_")
        unset(_YH_${_name}_${_step}_COMMAND)
      endif()
    endforeach()
  endif()

  # For non-cmake project, pass PKG_CONFIG_PATH to the
  # CONFIGURE_COMMAND in order to allow pkg-config to locate the
  # packages built and installed by YCM.
  if(DEFINED _YH_${_name}_CONFIGURE_COMMAND AND
     NOT ("${_YH_${_name}_CONFIGURE_COMMAND}" MATCHES "^[^;]*/cmake" AND
          NOT "${_YH_${_name}_CONFIGURE_COMMAND}" MATCHES ";-[PE];"))

    set(_pkg_config_path "${YCM_EP_INSTALL_DIR}/lib/pkgconfig")
    if(WIN32)
      set(_regex "(^|;)${_pkg_config_path}(;|^)")
    else()
      set(_regex "(^|:)${_pkg_config_path}(:|^)")
    endif()

    if(DEFINED ENV{PKG_CONFIG_PATH} AND NOT "$ENV{PKG_CONFIG_PATH}" MATCHES "${_regex}")
      if(WIN32)
        set(_pkg_config_path ${_pkg_config_path};$ENV{PKG_CONFIG_PATH})
      else()
        set(_pkg_config_path ${_pkg_config_path}:$ENV{PKG_CONFIG_PATH})
      endif()
      set(_YH_${_name}_CONFIGURE_COMMAND "${CMAKE_COMMAND}" -E env "PKG_CONFIG_PATH=${_pkg_config_path}" ${_YH_${_name}_CONFIGURE_COMMAND})
    endif()
    unset(_pkg_config_path)
    unset(_regex)
  endif()

  foreach(_step DOWNLOAD
                UPDATE
                PATCH
                CONFIGURE
                BUILD
                INSTALL
                TEST)
    if(DEFINED _YH_${_name}_${_step}_COMMAND)
      list(APPEND ${_name}_COMMAND_ARGS ${_step}_COMMAND "${_YH_${_name}_${_step}_COMMAND}")
    endif()
  endforeach()

  if("${_YH_${_name}_COMPONENT}" STREQUAL "documentation")
    set(${_name}_STEP_ARGS SCM_DISCONNECTED 0)
  endif()


  unset(${_name}_EXTRA_ARGS)
  if(DEFINED _YH_${_name}_EXCLUDE_FROM_ALL)
    list(APPEND ${_name}_EXTRA_ARGS EXCLUDE_FROM_ALL ${_YH_${_name}_EXCLUDE_FROM_ALL})
  endif()
  # BEGIN DEPRECATED Since YCM 0.10
  if(DEFINED _YH_${_name}_CONFIGURE_SOURCE_DIR)
    message(DEPRECATION "CONFIGURE_SOURCE_DIR is deprecated. Use SOURCE_SUBDIR instead")
    if(DEFINED _YH_${_name}_SOURCE_SUBDIR)
      message(FATAL_ERROR "CONFIGURE_SOURCE_DIR and SOURCE_SUBDIR cannot be used together")
    endif()
    set(_YH_${_name}_SOURCE_SUBDIR "${_YH_${_name}_CONFIGURE_SOURCE_DIR}")
  endif()
  # END DEPRECATED Since YCM 0.10
  if(DEFINED _YH_${_name}_SOURCE_SUBDIR)
    list(APPEND ${_name}_EXTRA_ARGS SOURCE_SUBDIR "${_YH_${_name}_SOURCE_SUBDIR}")
  endif()
  if(DEFINED _YH_${_name}_BUILD_ALWAYS)
    list(APPEND ${_name}_EXTRA_ARGS BUILD_ALWAYS ${_YH_${_name}_BUILD_ALWAYS})
  else()
    # By default we set BUILD_ALWAYS to ON as this is how the YCM-superbuild always behaved using the
    # vendored ExternalProject used in YCM until 0.16.* releases, see:
    #  * https://github.com/robotology/ycm-cmake-modules/issues/50
    #  * https://github.com/robotology/robotology-superbuild/issues/1700
    list(APPEND ${_name}_EXTRA_ARGS BUILD_ALWAYS ON)
  endif()

  # Repository dependent variables
  unset(${_name}_REPOSITORY_ARGS)
  unset(_setup_repo_cmd)

  if("${_YH_${_name}_TYPE}" STREQUAL "GIT")
    # Specific setup for GIT
    _ycm_setup_git()

    set(git_repository ${YCM_GIT_${_YH_${_name}_STYLE}_BASE_ADDRESS}${_YH_${_name}_REPOSITORY})
    list(APPEND ${_name}_REPOSITORY_ARGS GIT_REPOSITORY ${git_repository})

    if(DEFINED _YH_${_name}_TAG)
      list(APPEND ${_name}_REPOSITORY_ARGS GIT_TAG ${_YH_${_name}_TAG})
    endif()

    if(DEFINED _YH_${_name}_SHALLOW)
      list(APPEND ${_name}_REPOSITORY_ARGS GIT_SHALLOW ${_YH_${_name}_SHALLOW})
    endif()

    if(YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_NAME)
      unset(${_name}_COMMIT_NAME)
      set(_setup_repo_cmd ${_setup_repo_cmd}
                          COMMAND ${GIT_EXECUTABLE} config --local user.name ${YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_NAME})
    endif()

    if(YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_EMAIL)
      set(_setup_repo_cmd ${_setup_repo_cmd}
                          COMMAND ${GIT_EXECUTABLE} config --local user.email ${YCM_GIT_${_YH_${_name}_STYLE}_COMMIT_EMAIL})
    endif()

    # If GIT is used, we do not want to use the default GIT DOWNLOAD command provided by ExternalProject, as it deletes
    # existing folders (see https://cmake.org/cmake/help/latest/module/ExternalProject.html#directory-options)
    # and this is not convenient if you create multiple build of the superbuild, as each one would
    # delete the source directory cloned by the other. Instead, we define our own DOWNLOAD command that do not delete
    # a git repo folder if it already exists

    # We do not define the custom GIT DOWNLOAD command if the outside call of YCMEPHelper already redefined it
    # or if we are using the vendored ExternalProject of YCM, that already redefines DOWNLOAD internally
    get_property(_yeph_YCM_USE_CMAKE_NEXT GLOBAL PROPERTY YCM_USE_CMAKE_NEXT)

    if(NOT DEFINED _YH_${_name}_DOWNLOAD_COMMAND AND NOT _yeph_YCM_USE_CMAKE_NEXT)
      # Coherently with how the gitclone command is created inside ExternalProject, we also define a CMake
      # script that defines the clone commands, and then we call it
      # This part is inspired by https://gitlab.kitware.com/cmake/cmake/-/blob/v3.30.2/Modules/ExternalProject/shared_internal_commands.cmake#L945-1034
      set(method git)
      # FetchContent gives us these directly, so don't try to recompute them
      if(NOT GIT_EXECUTABLE OR NOT GIT_VERSION_STRING)
        unset(CMAKE_MODULE_PATH) # Use CMake builtin find module
        find_package(Git QUIET)
        if(NOT GIT_EXECUTABLE)
          message(FATAL_ERROR "error: could not find git for clone of ${name}")
        endif()
      endif()

      set(git_tag "${_YH_${_name}_TAG}")
      if(NOT git_tag)
        set(git_tag "master")
      endif()

      set(git_init_submodules TRUE)

      set(git_remote_name "")
      if(NOT git_remote_name)
        set(git_remote_name "origin")
      endif()

      set(tls_version "")
      set(tls_verify "")
      set(git_shallow  "${_YH_${_name}_SHALLOW}")
      set(git_progress "")
      set(git_config   "")

      # If git supports it, make checkouts quiet when checking out a git hash.
      # This avoids the very noisy detached head message.
      if(GIT_VERSION_STRING VERSION_GREATER_EQUAL 1.7.7)
        list(PREPEND git_config advice.detachedHead=false)
      endif()

      # The command doesn't expose any details, so we need to record additional
      # information in the RepositoryInfo.txt file. For the download step, only
      # the things specifically affecting the clone operation should be recorded.
      # If the repo changes, the clone script should be run again.
      # But if only the tag changes, avoid running the clone script again.
      # Let the 'always' running update step checkout the new tag.
      #
      set(extra_repo_info
        "repository=${git_repository}
remote=${git_remote_name}
init_submodules=${git_init_submodules}
recurse_submodules=${git_submodules_recurse}
submodules=${git_submodules}
      ")
      get_filename_component(src_name "${${_name}_SOURCE_DIR}" NAME)
      get_filename_component(work_dir "${${_name}_SOURCE_DIR}" PATH)

      set(clone_script ${${_name}_TMP_DIR}/${_name}-gitsafeclone.cmake)
      set(stamp_dir ${${_name}_STAMP_DIR})
      _ycm_ep_write_gitclone_script(
        ${clone_script}
        ${${_name}_SOURCE_DIR}
        ${GIT_EXECUTABLE}
        ${git_repository}
        ${git_tag}
        ${git_remote_name}
        "${git_init_submodules}"
        "${git_submodules_recurse}"
        "${git_submodules}"
        "${git_shallow}"
        "${git_progress}"
        "${git_config}"
        ${src_name}
        ${work_dir}
        ${stamp_dir}/${_name}-gitinfo.txt
        ${stamp_dir}/${_name}-gitsafeclone-lastrun.txt
        "${tls_version}"
        "${tls_verify}"
      )
      set(comment "Performing download step (YCM's safe git clone) for '${name}'")
      set(cmd ${CMAKE_COMMAND}
        -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE
        -P ${clone_script}
      )

      # We use configure_file() to write the repo_info_file for compatibility
      # with upstreams CMake's gitclone

      set(repo_info_file ${stamp_dir}/${_name}-gitinfo.txt)
      configure_file(
        "${YCM_MODULE_DIR}/modules/YCMEPHelper/RepositoryInfo.txt.in"
        "${repo_info_file}"
        @ONLY
      )

      list(APPEND ${_name}_COMMAND_ARGS DOWNLOAD_COMMAND "${cmd}")
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
  elseif("${_YH_${_name}_TYPE}" STREQUAL "HG")
    # Specific setup for Mercurial
    _ycm_setup_hg()

    list(APPEND ${_name}_REPOSITORY_ARGS HG_REPOSITORY ${YCM_HG_${_YH_${_name}_STYLE}_BASE_ADDRESS}${_YH_${_name}_REPOSITORY})

    if(DEFINED _YH_${_name}_TAG)
      list(APPEND ${_name}_REPOSITORY_ARGS HG_TAG ${_YH_${_name}_TAG})
    endif()
  endif()

  # CMake generator parameters
  unset(${_name}_CMAKE_GENERATOR_ARGS)
  if(_YH_${_name}_CMAKE_GENERATOR)
    list(APPEND ${_name}_CMAKE_GENERATOR_ARGS CMAKE_GENERATOR ${_YH_${_name}_CMAKE_GENERATOR})
  endif()
  if(_YH_${_name}_CMAKE_GENERATOR_PLATFORM)
    list(APPEND ${_name}_CMAKE_GENERATOR_ARGS CMAKE_GENERATOR_PLATFORM ${_YH_${_name}_CMAKE_GENERATOR_PLATFORM})
  endif()
  if(_YH_${_name}_CMAKE_GENERATOR_TOOLSET)
    list(APPEND ${_name}_CMAKE_GENERATOR_ARGS CMAKE_GENERATOR_TOOLSET ${_YH_${_name}_CMAKE_GENERATOR_TOOLSET})
  endif()
  if(_YH_${_name}_CMAKE_GENERATOR_INSTANCE)
    list(APPEND ${_name}_CMAKE_GENERATOR_ARGS CMAKE_GENERATOR_INSTANCE ${_YH_${_name}_CMAKE_GENERATOR_INSTANCE})
  endif()

  # Test parameters
  unset(${_name}_TEST_ARGS)
  if(_YH_${_name}_TEST_BEFORE_INSTALL)
    list(APPEND ${_name}_TEST_ARGS TEST_BEFORE_INSTALL 1)
  elseif(_YH_${_name}_TEST_AFTER_INSTALL)
    list(APPEND ${_name}_TEST_ARGS TEST_AFTER_INSTALL 1)
  endif()
  if(_YH_${_name}_TEST_EXCLUDE_FROM_MAIN)
    list(APPEND ${_name}_TEST_ARGS TEST_EXCLUDE_FROM_MAIN 1)
  endif()

  option(YCM_EP_DEVEL_MODE_${_name} "Enable development targets for the \"${_name}\" project" OFF)
  if("${_YH_${_name}_COMPONENT}" STREQUAL "external")
    mark_as_advanced(YCM_EP_DEVEL_MODE_${_name})
  endif()
  if(NON_INTERACTIVE_BUILD AND YCM_EP_DEVEL_MODE_${_name})
    message(SEND_ERROR "NON_INTERACTIVE_BUILD AND YCM_EP_DEVEL_MODE_${_name} cannot be used at the same time")
  endif()

  unset(${_name}_ARGS)
  foreach(_arg IN LISTS ${_name}_REPOSITORY_ARGS
                        ${_name}_DIR_ARGS
                        ${_name}_CMAKE_GENERATOR_ARGS
                        ${_name}_ALL_CMAKE_ARGS
                        ${_name}_DEPENDS_ARGS
                        ${_name}_COMMAND_ARGS
                        ${_name}_TEST_ARGS
                        ${_name}_STEP_ARGS
                        ${_name}_EXTRA_ARGS)
    list(APPEND ${_name}_ARGS "${_arg}")
  endforeach()
  ExternalProject_Add(${_name} "${${_name}_ARGS}")

  if(_setup_repo_cmd)
    ExternalProject_Add_Step(${_name} setup-repository
                             ${_setup_repo_cmd}
                             WORKING_DIRECTORY ${${_name}_SOURCE_DIR}
                             COMMENT "Performing setup-repository step for '${_name}'"
                             DEPENDEES download
                             DEPENDERS update)
  endif()


  # Extra steps
  _ycm_ep_add_test_step(${_name})
  if(YCM_EP_DEVEL_MODE_${_name} OR YCM_EP_MAINTAINER_MODE)
    _ycm_ep_add_configure_step(${_name})
    _ycm_ep_add_fetch_step(${_name})
    _ycm_ep_add_status_step(${_name})
    _ycm_ep_add_clean_step(${_name})
    _ycm_ep_add_edit_cache_step(${_name})
    _ycm_ep_add_print_directories_step(${_name})
    _ycm_ep_add_open_step(${_name})
    _ycm_ep_add_dependees_steps(${_name})
    if(YCM_EP_EXPERT_MODE OR YCM_EP_MAINTAINER_MODE)
      _ycm_ep_add_update_step(${_name})
    endif()
  else()
    _ycm_ep_add_update_step(${_name})
  endif()
  _ycm_ep_add_dependers_steps(${_name})


  # Install project
  _ycm_ep_add_installation(${_name})


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

  # Set some useful global properties
  if(NOT "${_YH_${_name}_COMPONENT}" MATCHES "^(documentation|templates|examples)$")

    get_property(_projects GLOBAL PROPERTY YCM_PROJECTS)
    list(APPEND _projects ${_name})
    list(REMOVE_DUPLICATES _projects)
    set_property(GLOBAL PROPERTY YCM_PROJECTS ${_projects})

    get_property(_components GLOBAL PROPERTY YCM_COMPONENTS)
    list(APPEND _components ${_YH_${_name}_COMPONENT})
    list(REMOVE_DUPLICATES _components)
    set_property(GLOBAL PROPERTY YCM_COMPONENTS ${_components})

  elseif("${_YH_${_name}_COMPONENT}" STREQUAL "documentation")
    set_property(GLOBAL APPEND PROPERTY YCM_DOCUMENTATION ${_name})
  elseif("${_YH_${_name}_COMPONENT}" STREQUAL "templates")
    set_property(GLOBAL APPEND PROPERTY YCM_TEMPLATES ${_name})
  elseif("${_YH_${_name}_COMPONENT}" STREQUAL "examples")
    set_property(GLOBAL APPEND PROPERTY YCM_EXAMPLES ${_name})
  endif()

  # TODO foreach on all the variables?
  set_property(GLOBAL PROPERTY _YCM_${_name}_COMPONENT ${_YH_${_name}_COMPONENT})
  set_property(GLOBAL PROPERTY _YCM_${_name}_FOLDER ${_YH_${_name}_FOLDER})
  set_property(GLOBAL PROPERTY _YCM_${_name}_DEPENDS ${_YH_${_name}_DEPENDS})
endfunction()


########################################################################
# YCM_WRITE_CDASH_PROJECT_FILE
#
# Write cdash Project.xml file::
#
#  ycm_write_cdash_project_file(<filename>)
#
# This function writes a Project.xml file that can be read and
# interpreted by CDash.

function(YCM_WRITE_CDASH_PROJECT_FILE _filename)
  get_property(_projects GLOBAL PROPERTY YCM_PROJECTS)

  # For CTEST_PROJECT_NAME
  include(${CMAKE_SOURCE_DIR}/CTestConfig.cmake OPTIONAL)

  if(NOT DEFINED CTEST_PROJECT_NAME OR CTEST_PROJECT_NAME STREQUAL "")
    message(SEND_ERROR "Cannot generate Project.xml. Please set CTEST_PROJECT_NAME variable or add a ${CMAKE_SOURCE_DIR}/CTestConfig.cmake file")
  endif()

  file(WRITE ${_filename} "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Project name=\"${CTEST_PROJECT_NAME}\">\n")

  foreach(_proj ${_projects})
    file(APPEND "${_filename}" "\n  <SubProject name=\"${_proj}\">")
    get_property(_dependencies GLOBAL PROPERTY _YCM_${_proj}_DEPENDS)
    foreach(_dep ${_dependencies})
      list(FIND _projects ${_dep} _is_ycm)
      if(NOT _is_ycm EQUAL -1)
        file(APPEND "${_filename}" "\n    <Dependency name=\"${_dep}\" />")
      else()
        file(APPEND "${_filename}" "\n    <!-- <Dependency name=\"${_dep}\" /> -->")
      endif()
    endforeach()
    file(APPEND "${_filename}" "\n  </SubProject>\n")
  endforeach()
  file(APPEND "${_filename}" "</Project>\n")
endfunction()


########################################################################
# YCM_WRITE_CTEST_SUBPROJECT_CONFIG_FILE
#
# Write ctest subprojects file::
#
#  ycm_write_ctest_subproject_config_file(<filename>)
#
# This function writes a cmake file that can be used in ctest scripts.

function(YCM_WRITE_CTEST_SUBPROJECT_CONFIG_FILE _filename)
  get_property(_projects GLOBAL PROPERTY YCM_PROJECTS)
  file(WRITE ${_filename} "set(CTEST_PROJECT_SUBPROJECTS")
  foreach(_proj ${_projects})
    file(APPEND "${_filename}" "\n      ${_proj}")
  endforeach()
  file(APPEND "${_filename}" ")\n")
  foreach(_proj ${_projects})
    get_property(_folder GLOBAL PROPERTY _YCM_${_proj}_FOLDER)
    file(APPEND "${_filename}" "
set(${_proj}_SOURCE_DIR \${CTEST_SOURCE_DIRECTORY}/${_folder}/${_proj})
set(${_proj}_BINARY_DIR \${CTEST_BINARY_DIRECTORY}/${_folder}/${_proj})
")
  endforeach()
endfunction()


########################################################################
# YCM_WRITE_DOT_FILE
#
# Write dot file::
#
#  ycm_write_dot_file(<filename>)
#
# This function writes a dot file that produces a graph showing all the
# subprojects, dependencies and components.

function(YCM_WRITE_DOT_FILE _filename)
  get_property(_projects GLOBAL PROPERTY YCM_PROJECTS)
  get_property(_components GLOBAL PROPERTY YCM_COMPONENTS)

  unset(_arrows)
  unset(_system_subgraph)
  unset(_found_on_system_subgraph)
  foreach(_component _components)
    unset(_${_component}_subgraph)
  endforeach()

  foreach(_proj_label ${_projects})
    string(REGEX REPLACE "-" "__" _proj ${_proj_label})
    get_property(_component GLOBAL PROPERTY _YCM_${_proj_label}_COMPONENT)
    get_property(_dependencies GLOBAL PROPERTY _YCM_${_proj_label}_DEPENDS)

    set(_${_component}_subgraph  "${_${_component}_subgraph}\n    ${_proj} [label=\"${_proj_label}\"]")
    foreach(_dep_label ${_dependencies})
      string(REGEX REPLACE "-" "__" _dep ${_dep_label})
      list(FIND _projects ${_dep_label} _is_ycm)
      if(_is_ycm EQUAL -1)
        list(APPEND _found_on_system ${_dep_label})
        list(REMOVE_DUPLICATES _found_on_system)
        set(_arrows "${_arrows}\n  ${_proj} -> ${_dep} [color=\"gray\" style=\"dashed\"];")
      else()
        get_property(_dep_component_set GLOBAL PROPERTY _YCM_${_dep_label}_COMPONENT SET)
        get_property(_dep_component GLOBAL PROPERTY _YCM_${_dep_label}_COMPONENT)
        if(NOT _dep_component_set)
          set(_arrows "${_arrows}\n  ${_proj} -> ${_dep} [color=\"dimgray\"];")
        elseif(_dep_component STREQUAL "external")
          set(_arrows "${_arrows}\n  ${_proj} -> ${_dep} [color=\"gray\", style=\"dashed\"];")
        else()
          set(_arrows "${_arrows}\n  ${_proj} -> ${_dep};")
        endif()
      endif()
    endforeach()
  endforeach()
  get_property(_packages_found GLOBAL PROPERTY PACKAGES_FOUND)
  list(APPEND _found_on_system ${_packages_found})
  list(REMOVE_DUPLICATES _found_on_system)
  foreach(_dep_label ${_found_on_system})
    string(REGEX REPLACE "-" "__" _dep ${_dep_label})
    list(FIND _projects ${_dep_label} _is_ycm)
    if(_is_ycm EQUAL -1)
      set(_system_subgraph "${_system_subgraph}\n    ${_dep}")
    else()
      set(_found_on_system_subgraph "${_found_on_system_subgraph}\n    ${_dep} [shape=\"note\"]")
    endif()
  endforeach()

  string(REPLACE "-" "__" _project_name ${PROJECT_NAME})
  file(WRITE ${_filename}
"digraph ${_project_name} {
  graph [ranksep=\"1.5\", nodesep=\"0.1\" rankdir=\"BT\"];
")

  if(_system_subgraph)
    file(APPEND ${_filename} "
  subgraph cluster_system {
    label=\"system\";
    labelloc=\"b\";
    fontname=\"monospace:bold\";
    style=\"dashed\";
    color=\"dimgray\";
    bgcolor=\"gray94\";
    node [shape=\"pentagon\", color=\"dimgray\", fontsize=\"10\"];
${_system_subgraph}
  }
")
  endif()

  if(_found_on_system_subgraph)
    file(APPEND ${_filename} "
  subgraph cluster_found_on_system {
    label=\"found\";
    labelloc=\"b\";
    fontname=\"monospace:bold\";
    style=\"dashed\";
    color=\"orangered1\";
    bgcolor=\"oldlace\";
    node [shape=\"note\", color=\"orangered3\"];
${_found_on_system_subgraph}
  }
")
  endif()

  if(_external_subgraph)
    file(APPEND "${_filename}" "
  subgraph cluster_external {
    label=\"external\";
    labelloc=\"b\";
    fontname=\"monospace:bold\";
    style=\"dashed\";
    color=\"green\";
    bgcolor=\"mintcream\";
    node [shape=\"note\", color=\"darkgreen\", fontsize=\"10\"];
${_external_subgraph}
  }
")
  endif()

  list(REMOVE_ITEM _components "external" "documentation" "templates" "examples")

  foreach(_component ${_components})
    if(NOT DEFINED YCM_${_component}_COLOR)
      set(YCM_${_component}_COLOR dodgerblue1)
    endif()
    if(NOT DEFINED YCM_${_component}_BGCOLOR)
      set(YCM_${_component}_BGCOLOR aliceblue)
    endif()
    if(NOT DEFINED YCM_${_component}_NODECOLOR)
      set(YCM_${_component}_NODECOLOR dodgerblue3)
    endif()
    if(_${_component}_subgraph)
      file(APPEND "${_filename}" "
  subgraph cluster_${_component} {
    label=\"${_component}\";
    labelloc=\"b\";
    fontname=\"monospace:bold\";
    color=\"${YCM_${_component}_COLOR}\";
    bgcolor = \"${YCM_${_component}_BGCOLOR}\";
    node [style=\"bold\", shape=\"note\", color=\"${YCM_${_component}_NODECOLOR}\"];
${_${_component}_subgraph}
  }
")
    endif()
  endforeach()

  file(APPEND "${_filename}" "\n${_arrows}\n}\n")
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
  if(YCM_FOUND OR DEFINED __YCM_BOOTSTRAPPED_CALLED OR DEFINED __USEYCMFROMSOURCE_INCLUDED)
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

  include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/style-modules/StyleGITHUB.cmake)

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
  # The -DCMAKE_PREFIX_PATH in YCM-cfgcmd.txt uses | as list separator, so it is not
  # usable as it is when invoking CMake from the config line. As YCM during bootstrap
  # does not need to find any package via CMAKE_PREFIX_PATH, we just remove it
  string(REGEX REPLACE "-DCMAKE_PREFIX_PATH:PATH=.+;-C" "-C" _cmd "${_cmd}")
  # The cache file is generated with 'file(GENERATE)', therefore it is not yet
  # available. Since we cannot use CMAKE_CACHE_ARGS or CMAKE_CACHE_DEFAULT_ARGS,
  # We just remove it from the command line, and append the arguments instead.
  string(REGEX REPLACE "-C.+\\.cmake;" "${_YCM_EP_CMAKE_CACHE_ARGS};${_YCM_EP_CMAKE_CACHE_DEFAULT_ARGS};" _cmd "${_cmd}")
  # The command line contains location tags, therefore we need to expand it.
  _ep_replace_location_tags(YCM _cmd)
  execute_process(COMMAND ${_cmd}
                  WORKING_DIRECTORY ${YCM_BINARY_DIR}
                  ${_quiet_args}
                  RESULT_VARIABLE _result)
  if(_result)
    message(FATAL_ERROR "Cannot configure YCM repository")
  endif()

  # On multi-config generators (MSVC and Xcode) always build in
  # "Release" configuration
  if(CMAKE_CONFIGURATION_TYPES)
    set(_configuration --config Release)
  endif()

  message(STATUS "Performing uninstall step for 'YCM'")
  execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} ${_configuration} --target uninstall
                  WORKING_DIRECTORY ${YCM_BINARY_DIR}
                  ${_quiet_args}
                  RESULT_VARIABLE _result)
  # If uninstall fails, YCM was not previously installed,
  # therefore do not fail with error

  message(STATUS "Performing build step for 'YCM'")
  execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} ${_configuration}
                  WORKING_DIRECTORY ${YCM_BINARY_DIR}
                  ${_quiet_args}
                  RESULT_VARIABLE _result)
  if(_result)
    message(FATAL_ERROR "Cannot build YCM")
  endif()

  message(STATUS "Performing install step for 'YCM'")
  execute_process(COMMAND ${CMAKE_COMMAND} --build ${YCM_BINARY_DIR} ${_configuration} --target install
                  WORKING_DIRECTORY ${YCM_BINARY_DIR}
                  ${_quiet_args}
                  RESULT_VARIABLE _result)
  if(_result)
    message(FATAL_ERROR "Cannot install YCM")
  endif()

  # Find the package, so that can be used now.
  if(CMAKE_DISABLE_FIND_PACKAGE_YCM)
    # We need to disable this flag, in case the the user explicitly enabled
    # it in order to use the bootstrapped version, otherwise the next
    # find_package will fail.
    set(CMAKE_DISABLE_FIND_PACKAGE_YCM FALSE)
  endif()
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
