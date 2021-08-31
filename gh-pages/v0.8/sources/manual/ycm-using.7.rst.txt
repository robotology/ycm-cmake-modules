.. cmake-manual-description: Using YCM in your project

ycm-using(7)
************

.. only:: html or latex

   .. contents::

How to Use YCM in Your Project
==============================

In order to use YCM in your project, your software will have to depend
on CMake 3.0 or later. Therefore your ``CMakeLists.txt`` file should
include a :cmake:command:`cmake_minimum_required` call to set the
:cmake:variable:`CMAKE_MINIMUM_REQUIRED_VERSION` and the relative
CMake policies.


.. code-block:: cmake

    cmake_minimum_required(VERSION 3.5)

Now you have to set variables that control which components are enabled:

.. code-block:: cmake

    set(YCM_USE_CMAKE_3_1 TRUE) # Enables modules from CMake 3.1
    set(YCM_USE_CMAKE_3_2 TRUE) # Enables modules from CMake 3.2
    set(YCM_USE_CMAKE_NEXT TRUE) # Enables modules from CMake git repository
    set(YCM_USE_CMAKE_PROPOSED TRUE) # Enables unmerged patches to CMake modules

These options, with the exception of :variable:`YCM_USE_CMAKE_PROPOSED`
are turned on by default, but they can be turned off if they are not
needed.

.. seealso::
    :variable:`YCM_USE_CMAKE_<VERSION>`,
    :variable:`YCM_USE_CMAKE_NEXT`, and
    :variable:`YCM_USE_CMAKE_PROPOSED`.

If you want to use 3rd party modules you have to enable the
:variable:`YCM_USE_3RDPARTY` variable.

.. code-block:: cmake

    set(YCM_USE_3RDPARTY TRUE) # Enables 3rd party modules

Also this option is turned on by default, but it can be turned off if it
is not needed.

.. seealso::
    :variable:`YCM_USE_3RDPARTY`

If you want to enable the deprecated modules, you have to enable the
:variable:`YCM_USE_DEPRECATED` variable. Please note that these modules are
deprecated for a reason, are not supported, might contain bugs, and could be
removed in future releases, therefore they should not be used in new code.

.. code-block:: cmake

    set(YCM_USE_DEPRECATED TRUE) # Enables 3rd party modules


YCM can be both a hard dependency or a soft dependency in your project.
In the first case, your package will not build if the YCM package is not
installed, in the second case, if it is not installed, it will be downloaded and
built during the configure phase of your project.

Using YCM as a Hard Dependency
------------------------------

In order to make it a hard dependency, you can just use it like any other
package:

.. code-block:: cmake

   # Find YCM
   find_package(YCM [version] REQUIRED)

This is the recommended mode to use it when you just want to use YCM modules,
because in this way you will not need a network connection when building the
package.

Using YCM as Soft Dependency
----------------------------

In order to make it a soft dependency, you will need to get the files
``tools/YCMBootstrap.cmake`` and ``modules/IncludeUrl.cmake`` from the YCM
sources (see :manual:`ycm-installing(7)` for instructions on how to download
YCM) and copy them inside your project tree:

.. code-block:: sh

   cd <YOUR_PROJECT_DIR>
   mkdir cmake
   cp <PATH_TO_YCM_SOURCES>/tools/YCMBootstrap.cmake cmake
   cp modules/IncludeUrl.cmake cmake

These files must be in a folder included in :cmake:variable:`CMAKE_MODULE_PATH`
for your project:

.. code-block:: cmake

   list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

Now you can include ``YCMBootstrap.cmake``:

.. code-block:: cmake

   # Uncomment the next line to specify a tag or a version.
   # set(YCM_TAG [tag, branch, or commit hash])

   # Bootstrap YCM
   include(YCMBootstrap)

This is the suggested method when you build a superbuild. Downloading all your
project would require a network connection anyway, therefore you will need to
install.

In both cases, you can use YCM modules right after this declaration.
