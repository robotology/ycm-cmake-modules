.. cmake-manual-description: YCM Superbuild Example

ycm-superbuild-example(7)
*************************

.. only:: html or latex

   .. contents::

.. _`YCM Superbuild Example`:

This page shows the example of a superbuild. The first section shows how you can 
compile and work with it (i.e. the point of view of a user), the second section shows how the superbuild
is implemented (i.e. point of view of a developer).

Superbuild example: user point of view
======================================

We show how you can download an example project called ``example`` which contains two 
subprojects: 

* TemplagePkg: a library, code at: git@gitlab.robotology.eu:walkman/template-pkg.git
* TemplateExe: an executable, available at: git@gitlab.robotology.eu:walkman/template-exe.git

Notice that we will NOT download these subprojects individuall. The superbild will do that 
for us, all we need to knwo is to get and 
Get the sources, for example using git:

* git clone <url>

Go to the directory where you have downloaded the project ``example``:

.. code-block:: bash

   cd <YOUR_PROJECT_DIR>
   mkdir build
   cd build
   cmake ../

This will download all the repositories of the individual packages and setup the build sytem.

Now you can compile the whole project, type:

.. code-block:: bash

   make

After the build, all the subprojects will be installed inside the
``build/install`` folder, therefore in order to use use it you will
have to adjust some environment variables

.. code-block:: sh

    export PATH=$PATH:<YOUR_PROJECT_DIR>/build/install/bin/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:<YOUR_PROJECT_DIR>/build/install/lib/
    export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:<YOUR_PROJECT_DIR>/build/install/

You can add these lines (replacing ``<YOUR_PROJECT_DIR>`` with the
folder where you downloaded your project) to your .bashrc file if you
don't want to have to execute them manually every time.


Superbuild example: developer point of view
===========================================

Suppose you want to make a superbuild that contains the following packages:

* TemplagePkg: a library, code at: git@gitlab.robotology.eu:walkman/template-pkg.git
* TemplateExe: an executable, available at: git@gitlab.robotology.eu:walkman/template-exe.git

Add CMakeLists.txt, open and edit it. Add the following lines:

.. code-block:: make

   cmake_minimum_required(VERSION 2.8.7)

   project(example)

   set(YCM_USE_CMAKE_PROPOSED TRUE) # Enables unmerged patches to CMake modules, this is required for the superbuild to work

   # makes available local cmake modules
   list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

   find_package(YCM 0.1 REQUIRED)

   ...

   ...
