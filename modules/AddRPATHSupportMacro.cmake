#.rst:
# AddRPATHSupportMacro
# ------------------
#
# Add support to RPATH to your project.
# Normally (depending on the platform) when you install a shared library you can either specify its 
# absolute path as the install name, or leave just the library name itself. In the former case the 
# library will be correctly linked during run time by all executables and other shared libraries, but 
# it must not change location. This is often the case for libraries installed in the system default library directory (e.g. /usr/lib).
# In the latter case, instead, the library can be moved anywhere in the file system but at run time the 
# dynamic linker must be able to find it. This is often accomplished by setting environmental variables 
# (i.e. LD_LIBRARY_PATH on Linux). This procedure is usually not desirable for two main reasons:
# - by setting the variable you are changing the default behaviour of the dynamic linker thus potentially breaking executables (not as destructive as LD_PRELOAD)
# - the variable will be used only by applications spawned by the shell and not by other processes. 
#
# RPATH is aimed to solve the issues introduced by the second installation method.
# Using run-path dependent libraries you can create a directory structure
# containing executables and dependent libraries that users can relocate without breaking it.
# A run-path dependent library is a dependent library whose complete install name is not known when the library is created.
# Instead, the library specifies that the dynamic loader must resolve the library’s install name when it loads the executable that depends on the library.
# The executable or the other shared library will hardcode in the binary itself the additional search directories 
# to be passed to the dynamic linker. This works great in conjunction with relative paths.

# This macro will enable support to RPATH to your project.
# It will enable the following things:
# - If the project builds shared libraries it will generate a run-path enabled shared library, i.e. its install name will be resolved only at run time.
# - In all cases (building executables and/or shared libraries) dependent shared libraries with RPATH support will be properly 
     
# You have to pass at least 3 variables to the macro:
# - Project_name: a name which identifies the project. This will create a variable to allow the user to disable the support for RPATH
# - BIN_DIR: directory where you will install the bins
# - LIB:DIR: directory where you will install the libs
#
# You can also pass additional arguments. This will be interpreted as additional libraries folders, e.g.
# if you are compiling matlab code, the mex folder.
# ::
#
# include(AddRPATHSupportMacro)
#
#
#=============================================================================
# Copyright 2014 RBCS, Istituto Italiano di Tecnologia
# @author Francesco Romano <francesco.romano@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
# License text for the above reference.)
macro(ADD_RPATH_SUPPORT_MACRO _project_name _bin_dir _lib_dir)
    
#### Settings for rpath
# if(${CMAKE_MINIMUM_REQUIRED_VERSION} VERSION_GREATER "2.8.12")
#     message(AUTHOR_WARNING "CMAKE_MINIMUM_REQUIRED_VERSION is now ${CMAKE_MINIMUM_REQUIRED_VERSION}. This check can be removed.")
# endif()
if(NOT (CMAKE_VERSION VERSION_LESS 2.8.12))
    if(NOT MSVC)
        #add the option to disable RPATH
        option(${_project_name}_DISABLE_RPATH "Disable RPATH installation for ${_project_name}" FALSE)
        mark_as_advanced(${_project_name}_DISABLE_RPATH)
    endif(NOT MSVC)

    #Configure RPATH
    set(CMAKE_MACOSX_RPATH 1) #enable RPATH on OSX. This also suppress warnings on CMake >= 3.0
    # when building, don't use the install RPATH already
    # (but later on when installing)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 
    #build directory by default is built with RPATH
    set(CMAKE_SKIP_BUILD_RPATH  FALSE)

    #This is relative RPATH for libraries built in the same project
    #I assume that the directory is
    # - install_dir/something for binaries
    # - install_dir/lib for libraries
    list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${_lib_dir}" isSystemDir)
    if("${isSystemDir}" STREQUAL "-1")
        #Not a default dir. Add it to rpath in a relative way
        file(RELATIVE_PATH _rel_path ${_bin_dir} ${_lib_dir})
        if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
            set(CMAKE_INSTALL_RPATH "@loader_path/${_rel_path}")
        else()
            set(CMAKE_INSTALL_RPATH "\$ORIGIN/${_rel_path}")
        endif()
    endif("${isSystemDir}" STREQUAL "-1")
    
    set(list_var "${ARGN}")
    foreach(loop_var IN LISTS list_var)
        file(RELATIVE_PATH _rel_path ${_bin_dir} ${loop_var})
        if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
            set(CMAKE_INSTALL_RPATH "@loader_path/${_rel_path}")
        else()
            set(CMAKE_INSTALL_RPATH "\$ORIGIN/${_rel_path}")
        endif()
    endforeach()

    unset(_rel_path)


    # add the automatically determined parts of the RPATH
    # which point to directories outside the build tree to the install RPATH
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE) #very important!

    if(${_project_name}_DISABLE_RPATH)
        #what to do? disable RPATH altogether or just revert to the default CMake configuration?
        #I revert to default
        unset(CMAKE_INSTALL_RPATH) #remove install rpath
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
    endif()
endif()
#####end RPATH

endmacro(ADD_RPATH_SUPPORT_MACRO)
