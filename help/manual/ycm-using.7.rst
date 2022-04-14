.. cmake-manual-description: Using YCM in your project

ycm-using(7)
************

.. only:: html or latex

   .. contents::

How to Use YCM in Your Project
==============================

In order to use YCM in your project, your software will have to depend
on CMake 3.16 or later. Therefore your ``CMakeLists.txt`` file should
include a :cmake:command:`cmake_minimum_required` call to set the
:cmake:variable:`CMAKE_MINIMUM_REQUIRED_VERSION` and the relative
CMake policies.


.. code-block:: cmake

    cmake_minimum_required(VERSION 3.16)

Now you have to set variables that control which components are enabled (all
the following variables should be set before calling ``find_package(YCM)``, it
is not possible to change their value later):

By default, YCM makes available some modules from CMake, that received bugfix,
enhancement, or simply are not available in all the supported versions.
If you want you can disable this behaviour by setting the
:variable`YCM_USE_CMAKE_<VERSION>` and :variable:`YCM_USE_CMAKE_NEXT`
variables to ``OFF``.

.. code-block:: cmake

    # set(YCM_USE_CMAKE_3_13 OFF) # Disable modules from CMake 3.13
    # set(YCM_USE_CMAKE_3_14 OFF) # Disable modules from CMake 3.14
    # set(YCM_USE_CMAKE_3_15 OFF) # Disable modules from CMake 3.15
    # set(YCM_USE_CMAKE_NEXT OFF) # Disable modules from CMake git repository

These options, are turned on by default, but they can be turned off if they are
not needed.

.. seealso::
    :variable:`YCM_USE_CMAKE_<VERSION>`,
    :variable:`YCM_USE_CMAKE_NEXT`.

YCM contains also some CMake modules with unmerged patches. These are turned off
by default, but can be enabled using the
:variable:`YCM_USE_CMAKE_PROPOSED` variable.

.. code-block:: cmake

    set(YCM_USE_CMAKE_PROPOSED ON) # Enables unmerged patches to CMake modules

These options, is turned on by default, but it can be turned off if needed.
At the moment, it is recommended to turn it on for YCM superbuilds.

.. seealso::
    :variable:`YCM_USE_CMAKE_PROPOSED`.

All the ``YCM_USE_CMAKE_`` options can be disabled simultaneously by setting the
:variable:`YCM_USE_CMAKE` variable to ``OFF``.

.. seealso::
    :variable:`YCM_USE_CMAKE`.


YCM makes available a few 3rd party modules. These modules can have licenses
that are not the same as YCM license. If you are using these module, you should
check each license to ensure that it is compatible with your code.
If you want to disable all 3rd party modules you can set the
:variable:`YCM_USE_3RDPARTY` variable to ``OFF``.

.. code-block:: cmake

    # set(YCM_USE_3RDPARTY OFF) # Disable 3rd party modules

Also this option is turned on by default, but it can be turned off if it
is not needed.

.. seealso::
    :variable:`YCM_USE_3RDPARTY`

Finally, YCM makes available a few modules that are considered deprecated.
:variable:`YCM_USE_DEPRECATED` variable. Please note that these modules are
deprecated for a reason, therefore they are not supported, might contain bugs,
and could be removed in future releases.
They are still available to support old code, but it is strongly recommended
to avoid them in new code.
If you want to disable the deprecated modules, you can set the
:variable:`YCM_USE_DEPRECATED` to ``OFF``

.. code-block:: cmake

    # set(YCM_USE_DEPRECATED OFF) # Disable deprecated modules

.. seealso::
    :variable:`YCM_USE_DEPRECATED`


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
``tools/YCMBootstrapFetch.cmake`` from the YCM
sources (see :manual:`ycm-installing(7)` for instructions on how to download
YCM) and copy them inside your project tree:

.. code-block:: sh

   cd <YOUR_PROJECT_DIR>
   mkdir cmake
   cp <PATH_TO_YCM_SOURCES>/tools/YCMBootstrapFetch.cmake cmake

These files must be in a folder included in :cmake:variable:`CMAKE_MODULE_PATH`
for your project:

.. code-block:: cmake

   list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

Now you can include ``YCMBootstrapFetch.cmake``:

.. code-block:: cmake

   # Uncomment the next line to specify a tag or a version.
   # set(YCM_TAG [tag, branch, or commit hash])

   # Bootstrap YCM
   include(YCMBootstrapFetch)

This is the suggested method when you build a superbuild. Downloading all your
project would require a network connection anyway, therefore you will need to
install.

In both cases, you can use YCM modules right after this declaration.
