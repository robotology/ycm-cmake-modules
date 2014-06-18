.. cmake-manual-description: YCM Superbuild User Manual

ycm-superbuild(7)
*****************

.. only:: html or latex

   .. contents::


YCM Superbuild
==============


A YCM Superbuild is a CMake project whose only goal is to download and
build several other projects.

The superbuild will check if a package is available on the system, and,
if it is not, it will download its source code build and install it.


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

A YCM superbuild can be built like any other CMake project.


Linux
-----

.. code-block:: sh

   mkdir build
   cd build
   cmake ..

Now, if you run

.. code-block:: sh

   make

the superbuild will download and install all the required projects that
cannot be found on the system.

After the build, all the subprojects will be installed inside the
``build/install`` folder, therefore in order to use use it you will
have to adjust some environment variables

.. code-block:: sh

    export PATH=$PATH:${PROJECT_SOURCE_DIR}/build/install/bin/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${PROJECT_SOURCE_DIR}/build/install/lib/
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${PROJECT_SOURCE_DIR}/build/install/

You can add these lines (replacing ``${PROJECT_SOURCE_DIR}`` with the
folder where you downloaded your project) to your .bashrc file if you
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


Windows
-------

TODO

OS X
----

TODO





.. _`YCM Superbuild Manual for Developers`:

YCM Superbuild Manual for Developers
====================================


A developer is someone that does not want just to build the superbuild
but also wants to modify some of the subprojects.

An important note is that if you want to build a package with a YCM
Superbuild, this should not be available on the system. If it is, then
the source code will not even be downloaded.
If you want to keep 2 different versions, you have to tell the
superbuild to ignore the system version, and to download and build it
instead, by setting the ``USE_SYSTEM_<PACKAGE>`` varibale to ``FALSE``.

You can do this by running :cmake:manual:`ccmake <ccmake(1)>` or
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
Each project will be installed in ``


.. _`Developer Mode`:

Developer Mode
--------------

For each the superproject built by the superbuild, it is possible to




Note that the superbuild will disable the
:ref:`update target <target:project-update>` for the projects in
<PROJECT>_DEVEL_MODE, you will have to update them manually


.. _`Expert Mode`:

Expert Mode
-----------

The :variable:`YCM_EXPERT_MODE`` variable will set the YCM Superbuild
in "expert mode". This is disabled by default.
This means that all the projects that are in "developer mode" will have
all the targets enabled (including the update step)


.. _`Targets`:

Targets
-------




.. _`Global Targets`:

Global Targets
~~~~~~~~~~~~~~

These targets influence all the whole YCM superbuild. In brackets is the
name of the target on IDEs like Visual Studio and XCode.


.. _`target:all`:

all (ALL)
^^^^^^^^^

Build all sub-projects.


.. _`target:update-all`:

update-all (ALL_UPDATE)
^^^^^^^^^^^^^^^^^^^^^^^

Update all sub-projects, except for those in <PROJECT>_DEVEL_MODE.


.. _`target:fetch-all`:

fetch-all (ALL_FETCH)
^^^^^^^^^^^^^^^^^^^^^

Runs git fetch for all the sub-projects in <PROJECT>_DEVEL_MODE (git
sub-projects only).


.. _`target:status-all`:

status-all (ALL_STATUS)
^^^^^^^^^^^^^^^^^^^^^^^

Prints the status (using the appropriate SCM command) for all the
sub-projects in <PROJECT>_DEVEL_MODE.


.. _`target:clean-all`:

clean-all (ALL_CLEAN)
^^^^^^^^^^^^^^^^^^^^^

... TODO


.. _`target:print-directories-all`:

print-directories-all (ALL_PRINT_DIRECTORIES)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

... TODO



FIXME install
^^^^^^^^^^^^^
... TODO


Component Targets
~~~~~~~~~~~~~~~~~

These targets influence a specific ``COMPONENT``, for example
``external``



.. _`target:component`:

<COMPONENT>
^^^^^^^^^^^



Project Targets (Common)
~~~~~~~~~~~~~~~~~~~~~~~~

.. _`target:project`:

<PROJECT>
^^^^^^^^^

Builds a sub-project and all its dependees.




Project Targets (Basic Mode)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _`target:project-update`:

<PROJECT>-update
^^^^^^^^^^^^^^^^

Update a sub-project.




Project Targets (Development Mode)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






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
the :variable:`YCM_USE_CMAKE_PROPOSED` variable to ``TRUE`` before
searching for YCM using :cmake:command:`find_package(YCM)` or
bootstrapping it.

.. code-block:: cmake

    # Enable cmake-proposed modules
    set(YCM_USE_CMAKE_PROPOSED TRUE)

    # Now bootstrap YCM
    include(YCMBootstrap)

Since the superbuild will download all the external project from the
net, using the bootstrap will consider YCM like any other external
project, but with the difference that it is downloaded and built at
configure time, instead of at compile time. This allows you to use
all YCM modules right after the bootstrap.


The other important modules for making a superbuild (see
:ref:`Superbuild Helper Modules`) are:

 * :module:`YCMEPHelper`, a helper for :module:`ExternalProject` that
   does some extra setup, and add some extra targets
 * :module:`FindOrBuildPackage`,  that ensures that a package is available
   and eventually downloads and builds it.


A superbuild is not supposed to contain source code, but just the CMake
files to build all the subprojects.



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
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

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


Components
----------


:module:`YCMEPHelper` assigns to each sub-project a ``COMPONENT`` (the
default component is ``external``.
This is useful to separate your project in conceptual units.

FIXME: These components are handled in a slightly different way

 * ``external`` component is for packages that the users of the superbuild
   will not modify.
 * ``documentation`` component contains only documentation and is not
   necessary for building the superbuild.
 * ``example`` and ``template`` components are not necessary for building
   the superbuild.

You can add any other component for your superbuild.


TODO: The superbuild will create targets for each component.


The source code will be downloaded in your
``${CMAKE_SOURCE_DIR}/${COMPONENT}/${NAME}``

The binary directory, where your code will be compiled, will be
``${CMAKE_BINARY_DIR}/${COMPONENT}/${NAME}``





.. _`Changing TAG`:

Changing TAG (git repository only)
----------------------------------

TODO Perhaps this should be in the :module:`YCMEPHelper` module documentation?

:command:`ycm_ep_helper` allows you to set a ``TAG`` for git repositories.
This ``TAG`` can be any ref known by the git repository, i.e. a commit
hash, a tag or a branch.

ExternalProject handles this tag in different ways depending if this is
a head or a fixed commit.

In the first case, git will perform a checkout of the tag the first
time, and then it will perform a rebase when the
:ref:`update target <target:project-update>` is executed.

This is the recommended mode to use when you need to work on one project
inside your superbuild.


FIXME changing branch issues


In the latter case, git always performs a checkout of the specific
commit, leaving the user in '*detached HEAD*' state.

This is the recommended mode to use for projects that are just
dependencies for projects inside your superbuild, and that developers
will not modify.


FIXME changing tag issues



.. _`Styles`:

Styles
------

TODO Perhaps this should be in the :module:`YCMEPHelper` module documentation?

TODO



.. _`CDash Integration`:

CDash Integration
-----------------

Unit tests are not well integrated yet, see :ycm-issue:`17`



.. _`Not Interactive Builds`:

Not Interactive Builds
----------------------

For build machines the :variable:`NOT_INTERACTIVE_BUILD` variable
should be set to true.

.. _`Maintainer Mode`:

Maintainer Mode
---------------

:variable:`YCM_MAINTAINER_MODE`


