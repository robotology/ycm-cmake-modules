.. title:: YCM Reference Documentation


YCM
***

.. only:: html or latex

   .. contents::


Introduction
############

The package YCM contains a set of CMake files that support creation and maintenance of repositories and software packages. 
YCM has been written with the aim of solving some of the problems encountered while manaing large research projects but it 
can be used outside it initial context.


YCM is not a replacement to CMake or yet another build system. YCM is just a
thin layer over CMake.
It does not add extra dependencies like other build systems, it does not use
Python, Ruby, or other scripting languages, it is written just using
:cmake:manual:`CMake language <cmake-language(7)>`.
It is just a collection of CMake modules, most of them candidate for being
contributed upstream.


The problem
===========

In the research environment the software development cycle is quite hectic and often heavily driven by project or paper deadlines. Developers 
have only little time available for packaging the code they write. However proper packaging in fundamental for code reuse and integration. 
Similar considerations apply to development and maintenance of the build system of large projects and the setup of tools for continuous integration and testing.

Research projects are joint efforts of different groups working remotely and asynchronously. To foster integration it is a good idea to have a common, 
shared repository that contains a single build system that compiles all the required software (including external dependencies and software developed within the project).
Because only a limited amount of resources are devoted to checking and accepting patches, developers cannot wait for patches to be integrated. Changes are committed 
directly to the repositories and tested in the field. The advantage of this approach is that all developers have access to the source code, can compile and commit changes.
The disadvantage it that this leads to large, monolithc repositories that are difficult to manage and reuse beyond the need of the project.

To address these needs we developed YCM, i.e. a set of CMake helper that provide:

* packaging support: to develop and package software libraries and components
* superbuild: prepare and distribute set of packages in source form as a single meta build

Packaging support
-----------------

For a package to be reused it should provide either a valid ``ProjectConfig.cmake'' or a ``FindPackage.cmake'' script.

The former solution is the one enforced by CMake and it must be followed in new projects. Writing and installing a correct ``ProjectConfig.cmake'' is time consuming and requries
advanced CMake competences. YCM provides helpers to automate this process.

The latter solution is commonly adopted to find and link projects that are not built using CMake. YCM makes available some 
of these ``find'' files for packages are not already distributed in CMake or that we patched (and that have not been incorporated yet in CMake).

Superbuild
----------

A superbuild is in practice a collection of packages (sub-projects) that reside in remote repositories and are managed ad and built independently. The superbuild downloads and 
compile all individual sub-projects, since this is done using the appropriate SCM tool (GIT, SVN etc) the user gets working repositories in which it can 
develop (getting updates, making and committing changes). The superbuild automatically provide support for integration with CDash and Doxygen to perform automatic compilation, 
regression tests and generation of the documentation for each sub-project.

.. figure:: /images/superbuild-concept.png
		:width: 800px
		:align: center
	
The figure above shows how a superbuild works. Here *foo-project* owns a repository which contains a set of packages (e.g. *ml-libraries*, *gasping-lib* and *slam*). With YCM you can create a 
build which download all the components required by *foo-project*, including packages from external repositories (e.g. github) or system libraries (not shown). Developers in 
*bar-project* develop their own packages (e.g. *fancy-vision*, *fancy-speech*) and creates a build which uses these packages and others from external repositories. Packages from 
*foo-project* can be reused. Because the superbuild downalods and compiles the source code and keeps it under revision control developers of *foo-project* and *bar-project* can 
easily contribute code to all packages they use irrespectively of the repositories in which they are maintained.


Reference Manuals
#################

Detailed documentation is organized in the following documents:

.. toctree::
   :maxdepth: 1

   How you can use YCM support for packaging </manual/ycm-packaging.7>
   How you can use YCM to make a superbuild </manual/ycm-superbuild.7>
   Documentation for developers </manual/ycm-devel.7>
   /manual/ycm-modules.7
   /manual/ycm-variables.7

   /manual/ycm-faq.7



Aknowledgements
###############

YCM is being developed by the iCub Facility, Istituto Italiano di Tecnologia.

Additional support to YCM was received from the FP7 EU project `WALK-MAN`: http://walk-man.eu/.

.. figure:: /images/logos.png
		:height: 100px

.. only:: html or text

 Release Notes
 #############

 .. toctree::
    :maxdepth: 1

    /release/index

.. only:: html

 Index and Search
 ################

 * :ref:`genindex`
 * :ref:`search`




