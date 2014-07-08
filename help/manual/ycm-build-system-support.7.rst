.. cmake-manual-description: YCM Build System Support

ycm-build-system-support(7)
***************************

.. only:: html or latex

   .. contents::

YCM Build System Support
========================

This is the manual for people who wants to use YCM in their project.

YCM can be used in different ways:

 * Extra module mode:

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

 * Superbuild mode:

   * :ref:`Superbuild Helper Modules`, that are useful to create a
     superbuild that downloads and build several packages.

   A YCM superbuild supports out of the box:

   * User mode
   * Developer mode
   * Demos
   * Automatic integration with CDash.
   * Automatic documentation generation using doxygen.
   * Generation of dependency graphs using dot.





How to Use YCM in Your Project
------------------------------

.. toctree::
   :maxdepth: 1

In order to use YCM in your project, your software will have to depend
on CMake 2.8.7 or later. Therefore your ``CMakeLists.txt`` file should
include a :cmake:command:`cmake_minimum_required` call to set the
:cmake:variable:`CMAKE_MINIMUM_REQUIRED_VERSION` and the relative
CMake policies.


.. code-block:: cmake

    cmake_minimum_required(VERSION 2.8.7)


If you want to use some module not available in CMake 2.8.7, you have to
enable the relative variables, see :variable:`YCM_USE_CMAKE_2_8_8`,
:variable:`YCM_USE_CMAKE_2_8_12`, :variable:`YCM_USE_CMAKE_3_0`,
:variable:`YCM_USE_CMAKE_NEXT`, and :variable:`YCM_USE_CMAKE_PROPOSED`.

.. code-block:: cmake

    set(YCM_USE_CMAKE_2_8_8 TRUE) # Enables modules from CMake 2.8.8
    set(YCM_USE_CMAKE_2_8_12 TRUE) # Enables modules from CMake 2.8.12
    set(YCM_USE_CMAKE_3_0 TRUE) # Enables modules from CMake 2.8.12
    set(YCM_USE_CMAKE_NEXT TRUE) # Enables modules from CMake git repository
    set(YCM_USE_CMAKE_PROPOSED TRUE) # Enables unmerged patches to CMake modules


If you want to use 3rd party modules you have to enable the
:variable:`YCM_USE_3RDPARTY` variable.

.. code-block:: cmake

    set(YCM_USE_3RDPARTY TRUE) # Enables 3rd party modules


If you want to enable the deprecated modules, you have to enable the
:variable:`YCM_USE_DEPRECATED` variable. Please note that these modules
are deprecated for a reason, are not supported, might contain bugs, and
could be removed in future releases, therefore they should not be used
in new code.

.. code-block:: cmake

    set(YCM_USE_DEPRECATED TRUE) # Enables 3rd party modules


YCM can be both a hard dependency or a soft dependency in your project.
In the first case, your package will not build if the YCM package is not
installed, in the second case, if it is not installed, it will be
downloaded and built during the configure phase of your project.


In order to make it a hard dependency, you can just use it like any
other package:

.. code-block:: cmake

   # Find YCM
   find_package(YCM [version] REQUIRED)

This is the recommended mode to use it when you just want to use YCM
modules, because in this way you will not need a network connection
when building it the package.


In order to make it a soft dependency, you will need to include
``tools/YCMBootstrap.cmake`` and ``modules/IncludeUrl.cmake`` in
your project (It must be in some folder included in
:variable:`CMAKE_MODULE_PATH` for your project) and then

.. code-block:: cmake

   # Uncomment the next line to specify a tag or a version.
   # set(YCM_TAG [tag, branch, or commit hash])

   # Bootstrap YCM
   include(YCMBootstrap)

This is the suggested method when you build a superbuild. Downloading
all your project would require a network connection anyway, therefore
you will need to install


In both cases, you can use YCM modules right after this declaration.


