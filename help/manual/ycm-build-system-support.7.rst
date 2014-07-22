.. cmake-manual-description: YCM Build System Support

ycm-build-system-support(7)
***************************

.. only:: html or latex

   .. contents::

YCM Build System Support
========================

YCM offers a few macros and Find scripts that can be used in your build system. See instructions in :manual:`ycm-using(7)`.


  * :ref:`Generic Modules` that add functionalities to CMake that might
    be useful in your project.

  * :ref:`Find Package Modules`, that help in finding software on the
    system.

  * :ref:`Packaging Helper Modules`, that are useful to simplify the
    generation of a package that can be used by other packages.

  * Support for new CMake features in older CMake versions.

  * Support for new features in CMake before these are actually
    released.

  * Support for 3rd party CMake modules.

YCM also offers functionalities to make a superbuild. Documentation for this can be found elsewhere (see: :ref:`YCM Superbuild Manual`).

A practical example
===================

Suppose you have created a package that contains a library, called ``TemplatePkg``. You want to package this library, providing versioning, 
installation rules for header as well as binary files and cmake files for finding and using the library within other projects.

This is the code you need to add to your CMakeLists.txt:

.. code-block:: cmake

    cmake_minimum_required(VERSION 2.8.11)
    project(TemplatePkg CXX)

    # declare a variable with the name of the project
    set(VARS_PREFIX "TEMPLATE_PKG")

    # ser variables that store version number
    set(${VARS_PREFIX}_MAJOR_VERSION 0)
    set(${VARS_PREFIX}_MINOR_VERSION 0)
    set(${VARS_PREFIX}_PATCH_VERSION 1)
    set(${VARS_PREFIX}_VERSION ${${VARS_PREFIX}_MAJOR_VERSION}.${${VARS_PREFIX}_MINOR_VERSION}.${${VARS_PREFIX}_PATCH_VERSION})

    # find and use YCM
    find_package(YCM REQUIRED)

    include(YCMDefaultDirs)
    ycm_default_dirs(${VARS_PREFIX})

    # add sources
    add_subdirectory(src)

So far nothing special. We have declared our library, added source codes and included YCM.

We now need to instruct CMake to install the library and generate ``CMake`` (FindTemplatePkg.cmake) 
have also been generated so that ``TemplatePkg`` can be found using ``CMake``.

.. code-block:: cmake

    # include macro for installing packaging files and invoke it
    include(InstallBasicPackageFiles)
    install_basic_package_files(TemplatePkg VARS_PREFIX ${VARS_PREFIX}
                                        VERSION ${${VARS_PREFIX}_VERSION}
                                        COMPATIBILITY SameMajorVersion
                                        TARGETS_PROPERTY ${VARS_PREFIX}_TARGETS
                                        NO_CHECK_REQUIRED_COMPONENTS_MACRO)

This function generates all the configuration files required for other packages to locate and use the library compiled by ``TemplatePkg`` and adds
the required installation rules for these files.

Finally we add uninstall rules:

.. code-block:: cmake

    include(AddUninstallTarget)

Now you can compile the package by simply doing:

.. code-block:: guess

   mkdir build
   cd build
   cmake ../
   make
   make install

If you check inside the build directory or ``/usr/local/lib`` you should see that ``make install`` has built the project and installed header files and the 
library correctly. The file ``TemplatePkgConfig.cmake`` should be in ``/usr/local/lib/cmake/TemplatePkg/``. 
This file will be found by other packages when they call:

.. code-block:: cmake
   
   find_package(TemplatePkg)

Example code can be downloaded from: git@gitlab.robotology.eu:walkman/template-pkg.git
