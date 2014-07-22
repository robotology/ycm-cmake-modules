.. cmake-manual-description: YCM Superbuild Example

ycm-superbuild-example(7)
*************************

.. only:: html or latex

   .. contents::

.. _`YCM Superbuild Example`:

This page shows an example of superbuild. The first section shows how you can
compile and work with it (i.e. the point of view of a user), the second section
shows how the superbuild is implemented (i.e. point of view of a developer).



Superbuild Example: User Point of View
======================================

We show how you can download an example project called ``example`` which
contains two subprojects:

* `TemplatePkg`_: a package containing the ``TemplateLib`` library
* `TemplateExe`_: an executable that uses the ``TemplateLib`` library from the
  ``TemplatePkg`` package

Notice that we will *not* download these subprojects individually. The
superbuild will do that for us, all we need to do is to get the superbuild
sources, for example cloning the git repository:

.. todo:: Add the correct example url

.. code-block:: sh

   git clone <example url>

We will set the ``SUPERBUILD_ROOT`` environment variable to the folder that was
just created by git. This is not necessary, but if you don't do it you will have
to replace the ``$SUPERBUILD_ROOT`` with the actual paths when you run the
following commands.

.. code-block:: sh

   export SUPERBUILD_ROOT=/path/to/the/superbuild/folder

After the build, all the subprojects will be installed inside the
``build/install`` folder, therefore in order to use use it you will have to
adjust some environment variables:

.. code-block:: sh

    export PATH=$PATH:$SUPERBUILD_ROOT/build/install/bin/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SUPERBUILD_ROOT/build/install/lib/
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$SUPERBUILD_ROOT/build/install/

You can add these exports (and the ``export SUPERBUILD_ROOT``) to your
``~/.bashrc`` file if you don't want to have to execute them manually every
time.

Now go to the directory where you have downloaded the project ``example``,
create a build directory

.. code-block:: sh

   mkdir $SUPERBUILD_ROOT/build
   cd $SUPERBUILD_ROOT/build
   cmake ..

This will download all the repositories of the individual packages and setup the
build sytem.

Now you can compile the whole project, type:

.. code-block:: sh

   make



Superbuild Example: Developer Point of View
===========================================

Suppose you want to make a superbuild that contains the following packages:

* `TemplatePkg`_: a package containing the ``TemplateLib`` library
* `TemplateExe`_: an executable that uses the ``TemplateLib`` library from the
  ``TemplatePkg`` package

Create a folder that will contain your superbuild.

.. code-block:: sh

   mkdir example-superbuild
   cd example-superbuild

Create a ``CMakeLists.txt`` with this content:

.. code-block:: cmake

   cmake_minimum_required(VERSION 2.8.7)

   project(example)

   set(YCM_USE_CMAKE_PROPOSED TRUE) # Enables unmerged patches to CMake modules, this is required for the superbuild to work

   # makes available local cmake modules
   list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

   # Choose whether you want YCM to be a soft or a hard dependency and uncomment
   # the appropriate line:
   include(YCMBootstrap) # This will make it a soft dependency
   # find_package(YCM 0.1 REQUIRED) # This will make it a soft dependency

   include(FindOrBuildPackage)
   include(YCMEPHelper)

   find_or_build_package(TemplatePkg)
   find_or_build_package(TemplateExe)

   feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

Create a ``cmake`` folder that will contain all required CMake modules

.. code-block:: sh

   mkdir cmake

If you want YCM as a soft dependency you will need to get the files
``tools/YCMBootstrap.cmake`` and ``modules/IncludeUrl.cmake`` from the YCM
sources. If you want to make it a hard dependency you don't have to add these
files, but the user will have to install YCM before he can build the superbuild.

.. note:
   If the user has YCM installed, ``YCMBootstrap`` will find it and will
   not download it again, but it will use the user's installation.

Create the files  ``cmake/BuildTemplatePkg.cmake`` and
``cmake/BuildTemplateExe.cmake`` with the following content:

.. code-block:: cmake

   # TemplatePkg
   include(YCMEPHelper)

   ycm_ep_helper(TemplatePkg TYPE GIT
                             STYLE GITLAB_ROBOTOLOGY
                             REPOSITORY walkman/template-pkg.git
                             TAG master
                             COMPONENT superbuild)

.. code-block:: cmake

   # TemplateExe
   include(YCMEPHelper)
   include(FindOrBuildPackage)

   find_or_build_package(TemplatePkg QUIET)

   ycm_ep_helper(TemplateExe TYPE GIT
                             STYLE GITLAB_ROBOTOLOGY
                             REPOSITORY walkman/template-exe.git
                             TAG master
                             COMPONENT superbuild
                             DEPENDS TemplatePkg)

Now you can try your superbuild.

.. code-block:: sh

   mkdir build
   cd build
   cmake ..

