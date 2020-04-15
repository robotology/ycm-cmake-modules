.. cmake-manual-description: YCM Superbuild User Manual

ycm-superbuild(7)
*****************

.. only:: html or latex

   .. contents::


.. _`YCM Superbuild Manual`:

YCM Superbuild
==============


A YCM Superbuild is a CMake project whose only goal is to download and
build several other projects.

The superbuild will check if a package is available on the system, and,
if it is not, it will download its source code build and install it.

A YCM superbuild supports out of the box:

* User mode
* Developer mode
* Demos
* Automatic integration with CDash.
* Automatic documentation generation using doxygen.
* Generation of dependency graphs using dot.

Depending on your reason for using a YCM superbuild, you should skip to
the appropriate section:


* If you just want to build the YCM superbuild project with all the
  sub-projects and start using it, read the
  :ref:`YCM Superbuild Manual for Basic Users`.

* If you want to download, build and modify the source code of one or
  some of the YCM superbuild sub-projects, read
  :ref:`YCM Superbuild Manual for Developers`.

* If you want to create a new superbuild or to modify an existing one,
  or you are interested in the internals of a YCM superbuild read
  :ref:`YCM Superbuild Manual for Maintainers`.



.. _`YCM Superbuild Manual for Basic Users`:

YCM Superbuild Manual for Basic Users
=====================================

.. toctree::
   :maxdepth: 1


A YCM superbuild can be built like any other CMake project.


Linux
-----

Suppose ``<YOUR_PROJECT>`` is the directory in which you downloaded the superbuild project 
you want to build:

.. code-block:: sh

   cd <YOUR_PROJECT>

   mkdir build
   cd build
   cmake ..

Now, if you run

.. code-block:: sh

   make

the superbuild will download and install all the required projects that
cannot be found on the system.

After the build, all the subprojects will be installed inside the
``${YCM_EP_INSTALL_DIR}`` folder (by default ``${CMAKE_BINARY_DIR}/install``,
i.e. ``build/install``), therefore in order to use it you will have to adjust
some environment variables

.. code-block:: sh

    export PATH=$PATH:${PROJECT_SOURCE_DIR}/build/install/bin/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${PROJECT_SOURCE_DIR}/build/install/lib/
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${PROJECT_SOURCE_DIR}/build/install/

You can add these lines (replacing ``${PROJECT_SOURCE_DIR}`` with the
folder where you downloaded your project) to your ``~/.bashrc`` file if you
don't want to have to execute them manually every time.


In order to compile just one project (and all the projects on which this
project depends) you can just run instead

.. code-block:: sh

   make <project>


In order to update the external projects, you will have to run

.. code-block:: sh

   make update-all

or if you want to update just one project, you can run

.. code-block:: sh

   make <project>-update

After updating some project, you should then rebuild.

.. code-block:: sh

   make


OS X
----

On OS X you have the option to generate a GNU Makefile or an Xcode project.
If you choose to use the Makefile then you can follow the same steps of the
Linux installation guide. Only the environmental variables change, as explained
later.

If you choose to generate the Xcode project you have to follow the following
steps:

.. code-block:: sh

   mkdir build
   cd build
   cmake .. -G Xcode

Now, if you run

.. code-block:: sh

   xcodebuild

the superbuild will download and install all the required projects that
cannot be found on the system.
The above command builds the project with the default configuration of Xcode.
You can also open the project into the Xcode IDE and build it from there, or
explicitly specify the configuration at command line:

.. code-block:: sh

   #Debug
   xcodebuild -configuration Debug
   #Release
   xcodebuild -configuration Release

After the build, all the subprojects will be installed inside the
``${YCM_EP_INSTALL_DIR}`` folder (by default ``${CMAKE_BINARY_DIR}/install``,
i.e. ``build/install``), therefore in order to use it you will have to adjust
some environment variables

.. code-block:: sh

    export PATH=$PATH:${PROJECT_SOURCE_DIR}/build/install/bin/
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:${PROJECT_SOURCE_DIR}/build/install/lib/
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${PROJECT_SOURCE_DIR}/build/install/

You can add these lines (replacing ``${PROJECT_SOURCE_DIR}`` with the
folder where you downloaded your project) to your ``~/.bashrc`` file (or the
correct file for your shell) if you don't want to have to execute them manually
every time.

In order to compile just one project (and all the projects on which this
project depends) you can just run instead

.. code-block:: sh

   xcodebuild -target <project>


In order to update the external projects, you will have to run

.. code-block:: sh

   xcodebuild -target ALL_UPDATE

or if you want to update just one project, you can run

.. code-block:: sh

   xcodebuild -target <project>-update

After updating some project, you should then rebuild.

.. code-block:: sh

   xcodebuild

If you don't remember the name of the targets you can type

.. code-block:: sh

   xcodebuild -list

for a list of the targets in the project.


.. todo:: Add Xcode screenshot and instructions for using the GUI


Windows
-------

.. todo:: Add Windows documentation


.. _`YCM Superbuild Manual for Developers`:

YCM Superbuild Manual for Developers
====================================

.. toctree::
   :maxdepth: 1


A developer is someone that does not want just to build the superbuild
but also wants to modify some of the subprojects.

.. note::
  If a package should be built with a YCM Superbuild, this should not be
  available on the system. If it is, then the source code will not even
  be downloaded.
  In order to keep 2 different versions, the superbuild should ignore
  the system version, and download and build it instead.
  This can be done by setting the ``USE_SYSTEM_<PACKAGE>`` variable to
  ``FALSE`` or by setting the ``YCM_DISABLE_SYSTEM_PACKAGES`` variable to
  ``TRUE`` to do it for all the packages of the superbuild.

This can be done by running :cmake:manual:`ccmake <ccmake(1)>` or
:cmake:manual:`cmake-gui <cmake-gui(1)>` and changing the value, or by
running adding ``-DUSE_SYSTEM_<PACKAGE>:BOOL=FALSE`` to the
:cmake:manual:`cmake <cmake(1)>` command line.


.. _`Directories`:

Directories
-----------

The superbuild will download each subproject inside the build tree of
the project in the folder::

  ${PROJECT_SOURCE_DIR}/<component>/<project name>

The ``<component>`` is assigned by the maintainer, and has the main
purpose to split the source code into conceptual units

The ``<project name>`` should be the name that is used in
:cmake:command:`find_package()` calls to find that package.


Each project will be configured and built in the folder::

  ${PROJECT_BINARY_DIR}/<component>/<project name>

``${PROJECT_BINARY_DIR}`` is the folder where you are building the
YCM superbuild project, usually ``${PROJECT_SOURCE_DIR}/build/``


The superbuild will run the ``configure``, ``build`` and ``install``
step for each project.

Each project will be installed in ``${YCM_EP_INSTALL_DIR}`` (by default
``${PROJECT_BINARY_DIR}/install``).
You should not change the ``YCM_EP_INSTALL_DIR`` variable, unless you wish to
build the superbuild only once, and discard the build directory. In this case
you should change this variable to the final destination of the build since, for
many projects, the build is not relocatable.
Please also note that, if you change it to a folder that is not writable by
current user, you will have to run the whole build as superuser.



.. _`Developer Mode`:

Developer Mode
--------------

A developer usually works on a limited set of projects.

For each the superproject that the developer will modify, he should
enable the :variable:`YCM_EP_DEVEL_MODE_<PROJECT>` CMake cached variable.

This can be done by running :cmake:manual:`ccmake <ccmake(1)>` or
:cmake:manual:`cmake-gui <cmake-gui(1)>` and changing the value, or by
running adding ``-DYCM_EP_DEVEL_MODE_<PACKAGE>:BOOL=FALSE`` to the
:cmake:manual:`cmake <cmake(1)>` command line.



Note that the :ref:`update target <target:project-update>` will be disabled for
projects in :variable:`YCM_EP_DEVEL_MODE_<PROJECT>`, and they will not be
updated unless the user updates them manually.
An automatic update in a modified project, would require a manual intervention
anyway.
Also when working with branches the update performed by
:cmake:module:`ExternalProject` could switch branch or checkout a specific tag
or commit, and, even though no work should be lost, the user might not know how
to recover it.
For this reason the update target is disabled for the projects that the user
will modify, and it is enabled only if the :variable:`YCM_EP_EXPERT_MODE`
variable is enabled.


.. _`Expert Mode`:

Expert Mode
-----------

The :variable:`YCM_EP_EXPERT_MODE` variable will set the YCM superbuild in
"expert mode". This is disabled by default.
This means that all the projects that are in "developer mode" will have
all the targets enabled (including the update step) and that the
:ref:`update <target:project-update>` and similar targets will keep
these targets as well.


.. _`Targets`:

Targets
-------




.. _`Global Targets`:

Global Targets
~~~~~~~~~~~~~~

These targets influence all the whole YCM superbuild. In brackets is the
name of the target on IDEs like Visual Studio and Xcode.


.. _`target:all`:

``all`` (``ALL``)
^^^^^^^^^^^^^^^^^

Build all sub-projects.


.. _`target:test`:

``test`` (``TEST``)
^^^^^^^^^^^^^^^^^^^

Run tests for all sub-projects (only if tests are enabled, see
:cmake:command:`enable_testing()`.


.. _`target:update-all`:

``update-all`` (``ALL_UPDATE``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Update all sub-projects, except for those in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>`.


.. _`target:fetch-all`:

``fetch-all`` (``ALL_FETCH``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Runs git fetch for all the sub-projects in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>` (git sub-projects only).


.. _`target:status-all`:

``status-all`` (``ALL_STATUS``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prints the status (using the appropriate SCM command) for all the sub-projects
in :variable:`YCM_EP_DEVEL_MODE_<PROJECT>`.


.. _`target:clean-all`:

``clean-all`` (``ALL_CLEAN``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. todo:: Missing docs


.. _`target:print-directories-all`:

``print-directories-all`` (``ALL_PRINT_DIRECTORIES``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prints the source and binary directories for all the sub-projects in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>`.


.. _`target:install`:

``install``
^^^^^^^^^^^

.. todo:: Add a proper installation.

.. warning::

 YCM does not create an ``install`` target (yet). In some cases, i.e. if you
 include some CMake module that installs some file, you might find an
 ``install`` target, but it will not install the whole superbuild, but just
 these files.

 One known module that adds the ``install`` target is
 ``catkinConfig.cmake`` distributed with `ROS Hydro`_, and usually included
 by running :cmake:command:`find_package(catkin)`.

.. _`Component Targets`:


Component Targets
~~~~~~~~~~~~~~~~~

These targets influence a specific ``COMPONENT``, for example
``external``

.. todo:: Component targets.

.. _`target:component`:

``<COMPONENT>``
^^^^^^^^^^^^^^^

.. todo:: Missing docs


.. _`target:component-update`:

``<COMPONENT>-update``
^^^^^^^^^^^^^^^^^^^^^^

.. todo:: Missing docs


.. _`Project Targets - Common`:

Project Targets - Common
~~~~~~~~~~~~~~~~~~~~~~~~

These targets are always available for all the sub-projects:


.. _`target:project`:

``<PROJECT>``
^^^^^^^^^^^^^

Builds a sub-project and all its dependees.


.. _`target:project-test`:

``<PROJECT>-test``
^^^^^^^^^^^^^^^^^^

Builds a sub-project and all its dependees and executes its tests (only
if tests are enabled, see :cmake:command:`enable_testing()`.


.. _`Project Targets - Basic Mode`:

Project Targets - Basic Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These targets are available only for the sub-projects that are **not** in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>`.


.. _`target:project-update`:

``<PROJECT>-update``
^^^^^^^^^^^^^^^^^^^^

Update a sub-project.


.. _`Project Targets - Development Mode`:

Project Targets - Development Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These targets are available only for the sub-projects that are in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>`.


.. _`target:project-configure`:

``<PROJECT>-configure``
^^^^^^^^^^^^^^^^^^^^^^^

Configure a sub-project.


.. _`target:project-fetch`:

``<PROJECT>-fetch``
^^^^^^^^^^^^^^^^^^^

Runs git fetch a sub-project (git sub-projects only).


.. _`target:project-status`:

``<PROJECT>-status``
^^^^^^^^^^^^^^^^^^^^

Prints the status (using the appropriate SCM command) for a sub-project.



.. _`target:project-clean`:

``<PROJECT>-clean``
^^^^^^^^^^^^^^^^^^^

.. todo:: Missing docs


.. _`target:project-edit-cache`:

``<PROJECT>-edit-cache``
^^^^^^^^^^^^^^^^^^^^^^^^

Edit CMake cache for a sub-project (CMake sub-projects only).


.. _`target:project-open`:

``<PROJECT>-open``
^^^^^^^^^^^^^^^^^^

Open the project for editing.

.. note:: MSVC and Xcode only


.. _`target:project-print-directories`:

``<PROJECT>-print-directories``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prints the source and binary directories for a sub-project


.. _`target:project-dependees`:

``<PROJECT>-dependees``
^^^^^^^^^^^^^^^^^^^^^^^

Builds all the sub-projects required by this sub-project.


.. _`target:project-dependees-update`:

``<PROJECT>-dependees-update``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Update all the sub-projects that are not in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>` and that are required by this
sub-project.


.. _`target:project-dependers`:

``<PROJECT>-dependers``
^^^^^^^^^^^^^^^^^^^^^^^

Builds all the sub-projects that require this sub-project.


.. _`target:project-dependers-update`:

``<PROJECT>-dependers-update``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Update all the sub-projects that are not in
:variable:`YCM_EP_DEVEL_MODE_<PROJECT>` and that require this sub-project.



.. _`Project Targets - Special Components`:

Project Targets - Special Components
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Projects in some special components behave in a different way


``documentation`` Projects
^^^^^^^^^^^^^^^^^^^^^^^^^^

These projects usually don't have ``build``, ``configure``, or
``install`` step.
The only target enabled is the :ref:`target:project` target.

The ``update`` step for these projects is always performed with the
:ref:`target:project` target.

If one of the steps is added manually, this step is performed with the
:ref:`target:project` target.

These projects are not added to the
:ref:`global targets <Global Targets>`.


``examples`` Projects
^^^^^^^^^^^^^^^^^^^^^

These projects are not added to the
:ref:`global targets <Global Targets>`.

``templates`` Projects
^^^^^^^^^^^^^^^^^^^^^^

These projects are not added to the
:ref:`global targets <Global Targets>`.




IDEs
----

.. todo::
   Add documentation about how to use the most common IDEs with YCM.
    * Xcode
    * QtCreator
    * MSVC
    * Maybe more.


.. _`YCM Superbuild Manual for Maintainers`:

YCM Superbuild Manual for Maintainers
=====================================


A YCM superbuild is based on the :module:`ExternalProject` CMake module.
The :module:`ExternalProject` module included in YCM is basically the
same, but includes a few extra patches to improve its functionalities,
and to fix a few issues in order to be able to work with the code
downloaded by :module:`ExternalProject`, without risking to lose work.
The reason why these patches are applied here, is because they can be
tested and used, before submitting them upstream. In the future, the
goal is to merge all the required features in the module upstream.

The CMake modified modules are not included automatically when you
include YCM. In order use the version supplied with YCM, you have to set
the :variable:`YCM_USE_CMAKE_PROPOSED` variable to ``ON`` before
searching for YCM using :cmake:command:`find_package(YCM)` or
bootstrapping it.

.. code-block:: cmake

    # Enable cmake-proposed modules
    set(YCM_USE_CMAKE_PROPOSED ON)

    # Now bootstrap YCM
    include(YCMBootstrap)

Since the superbuild will download all the external project from the
net, using the bootstrap will consider YCM like any other external
project, but with the difference that it is downloaded and built at
configure time, instead of at compile time. This allows you to use
all YCM modules right after the bootstrap.


The other important modules for making a superbuild

 * :module:`YCMEPHelper`, a helper for :module:`ExternalProject` that
   does some extra setup, and add some extra targets
 * :module:`FindOrBuildPackage`,  that ensures that a package is
   available and eventually downloads and builds it.

.. seealso:: :ref:`Superbuild Helper Modules`


.. note::
  A superbuild usually does not contain source code, but just the
  CMake files to build all the subprojects. It can build code, but
  the target dependencies should be handled properly.

.. warning::
  CMake modules installed by packages built by the superbuild will
  **not** be available during the configure phase of the superbuild,
  therefore you cannot include them in the ``CMakeLists.txt`` file, and
  you cannot use the :cmake:command:`functions <function>` and
  :cmake:command:`macros <macro>` that these files declare. This is
  often a good reason for not including source code in the superbuild.



.. _`Build Modules`:

Build Modules
-------------


Each subproject "Project" to be built, should have a
``BuildProject.cmake`` file in one of the folders in
:cmake:variable:`CMAKE_MODULE_PATH`.
YCM has a few of them, see :ref:`Build Package Modules`, that are found
automatically after YCM was found by :cmake:command:`find_package(YCM)`
or bootstrapped.
You can add more Build modules in your superbuild, by putting them in
some folder and adding that folder to the
:cmake:variable:`CMAKE_MODULE_PATH` variable. You can also use this
variable to replace one of the Build files included in YCM, but in this
case your folder must be in :cmake:variable:`CMAKE_MODULE_PATH`
*before* you search for YCM:

.. code-block:: cmake

    # Build modules are in cmake folder
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

    # Now search (or bootstrap) YCM
    find_package(YCM REQUIRED)
    # or
    # include(YCMBootstrap)


Each build file should handle properly the dependencies required by the
project that will be built. By managing the dependencies for each
project, the superbuild can ensure that the dependencies are available
when the build starts. This is especially important when you run
parallel builds (i.e. ``make -j8``) because builds

This is a basic example for a project "Bar" that depends on project
"Foo" that uses :module:`YCMEPHelper` and :module:`FindOrBuildPackage`
to build the code.


.. code-block:: cmake

    include(YCMEPHelper)
    include(FindOrBuildPackage)

    # Ensures that the superbuild knows about the Foo package
    find_or_build_package(Foo QUIET)

    ycm_ep_helper(Bar TYPE GIT
                      SYLE FOO_STYLE
                      REPOSITORY foo/bar.git
                      TAG master
                      DEPENDS Foo) # Explicitly declare that Bar depends on Foo

The main ``CMakeLists.txt`` will then include

.. code-block:: cmake

    include(FindOrBuildPackage)

    # Build the Bar package. Foo will be handled automatically
    # You don't need a "find_or_build_package(Foo)" call here if the Foo
    # package is not conceptually part of your superbuild
    find_or_build_package(Bar)


.. _`Non CMake Projects`:

Non CMake Projects
~~~~~~~~~~~~~~~~~~

Projects written with CMake can be included in a superbuild in a few
minutes. Other projects using for example autotools or other build
systems, can still be included, but they require some more effort to
add them to the build system.

In practice, the ``configure`` step is the one that usually requires to
be modified. You can do it by passing the ``CONFIGURE_COMMAND`` argument
to the :command:`ycm_ep_helper()` command.
An important thing that should be configured is the ``prefix`` where
the package will be installed, otherwise it will be installed on the
system default (usually in ``/usr/local/``) and that folder might not be
writable by the user.

The following strings (including the ``<`` and ``>`` characters) can be
used to configure the steps::

    <SOURCE_DIR>   # Source directory
    <BINARY_DIR>   # Binary directory
    <INSTALL_DIR>  # Install directory
    <TMP_DIR>      # Directory for temporary files.

For example, for an automake project, the :command:`ycm_ep_helper()`
call could be something similar:

.. code-block:: cmake

  ycm_ep_helper(Foo TYPE GIT
                    STYLE FOO_STYLE
                    REPOSITORY foo/foo.git
                    TAG v1.0
                    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>)


.. _`Overriding Parameters`:

Overriding Parameters
---------------------

Each parameter of the :command:`ycm_ep_helper` function can be
overridden using cmake variables, for example to overwrite the ``TAG``
tag for project ``FOO``, and the ``COMPONENT`` for project ``BAR`` you
can just add somewhere, before the relative :command:`ycm_ep_helper()`
call:

.. code-block:: cmake

    set(FOO_TAG v1.0)
    set(BAR_COMPONENT important)

See :module:`YCMEPHelper` module documentation for other details about
the parameters that can be modified with a variable.

.. _`Specifying additional CMake arguments for all CMake subprojects`:

Specifying additional CMake arguments for all subprojects
---------------------------------------------------------

In some situations, it may be convenient to be able to specify some
additional command line arguments that are passed during the cmake
invocation of all CMake-based subprojects. This is possible thanks
to the ``YCM_EP_ADDITIONAL_CMAKE_ARGS`` CMake cache variable, that
can be set as command line argument passed to the superbuild cmake
invocation:

.. code-block:: console
    cmake -DYCM_EP_ADDITIONAL_CMAKE_ARGS:STRING="-DBOOL_OPTION:BOOL=ON -DLIST_VARIABLE:STRING=foo;bar" .

or as a CMake variable set in the CMake code:

.. code-block:: cmake

    set(YCM_EP_ADDITIONAL_CMAKE_ARGS "-DBOOL_OPTION:BOOL=ON -DLIST_VARIABLE:STRING=foo;bar")

Note that in the latter case, you need to make sure to set the
``YCM_EP_ADDITIONAL_CMAKE_ARGS`` before the first inclusion
of the ``YCMEPHelper`` module in your project.


Components
----------


:module:`YCMEPHelper` assigns to each sub-project a ``COMPONENT`` (the
default component is ``external``.
This is useful to separate your project in conceptual units.


You can add any other component for your superbuild.

This will influence the superbuild in some ways:

1. The superbuild will create targets for each component.

   .. seealso:: :ref:`Component Targets` for details.

2. The component will influence the folders where the project is
   downloaded and built.

   .. seealso:: :ref:`Directories` for details.

3. Some special components are handled in a slightly different way:

    * ``external`` component is for packages that the users of the
      superbuild will not modify.
    * ``documentation`` component contains only documentation and is not
      necessary for building the superbuild.
    * ``example`` and ``template`` components are not necessary for
      building the superbuild.

   .. seealso:: :ref:`Project Targets - Special Components` for details.



.. _`Changing TAG`:

Changing TAG (git repository only)
----------------------------------

.. todo:: Perhaps this should be in the :module:`YCMEPHelper` module documentation?

:command:`ycm_ep_helper` allows you to set a ``TAG`` for git
repositories.
This ``TAG`` can be any ref known by the git repository, i.e. a commit
hash, a tag or a branch.

ExternalProject handles this tag in different ways depending if this is
a head or a fixed commit.

In the first case, git will perform a checkout of the tag the first
time, and then it will perform a rebase when the
:ref:`update target <target:project-update>` is executed.

This is the recommended mode to use when you need to work on one project
inside your superbuild.


.. todo:: Changing branch issues


In the latter case, git always performs a checkout of the specific
commit, leaving the user in '*detached HEAD*' state.

This is the recommended mode to use for projects that are just
dependencies for projects inside your superbuild, and that developers
will not modify.


.. todo:: Changing tag issues



.. _`Styles`:

Styles
------

.. todo:: Perhaps this should be in the :module:`YCMEPHelper` module documentation?

.. todo:: Missing docs



.. _`CDash Integration`:

CDash Integration
-----------------

.. todo:: Unit tests are not well integrated yet, see :ycm-issue:`17`



.. _`Not Interactive Builds`:

Non Interactive Builds
----------------------

For build machines the :variable:`NON_INTERACTIVE_BUILD` variable
should be set to true.

.. note::
  This should either be set by running
  ``cmake -DNON_INTERACTIVE_BUILD:BOOL=TRUE``, or using an initial cache
  file and running ``cmake -C <file>``


.. _`Install Step`:

Install Step
------------

An important thing to notice is that, if the subprojects are written
in a proper way, the user will have all the files that he needs to
use the projects in ``${PROJECT_BINARY_DIR}/install``

This means that it is quite important for your subproject to install
the files in the ``install`` step, and that all the files are installed
*inside* the ``install prefix``. For CMake projects this usually means
that the ``DESTINATION`` argument for the :cmake:command:`install()`
command should be a *relative* path instead of *absoulute*



.. _`Maintainer Mode`:

Maintainer Mode
---------------

If the :variable:`YCM_EP_MAINTAINER_MODE` CMake variable is
enabled, all the targets for all the projects will be enabled, including
the ``update`` step.

This is an useful variable for maintainers, but is not recommended
for developers.


.. _`Examples`:

Examples
--------

This is a list of known projects using YCM.

* `WALK-MAN`_ FP7 EU project
  (|lock| `WALK-MAN Superbuild Repository`_)
* `CoDyCo`_ FP7 EU project
  (`CoDyCo Superbuild Repository`_)
