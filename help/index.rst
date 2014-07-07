.. title:: YCM Reference Documentation


YCM
***

.. only:: html or latex

   .. contents::

YCM is not a replacement to CMake or yet another build system. YCM is
just a thin layer over CMake. It does not add extra dependencies like
other build system, it does not use python


Introduction
############

The problem
===========


* Research environment:

  * Publish or perish.
  * Quick development.
  * Write software that just "works".
  * No time to spend on the build system.


* Users:

  * Researchers, developers, release managers, team leaders.
  * Different goals.
  * Different skill level.
  * Different operating system.
  * Different habits.
  * Will modify only a limited subset of packages.


* Research groups:

  * Group identity.
  * Different hosts where the code is stored.
  * Sometimes the code is not public.
  * Different SCM.
  * Different build system.


* Software Projects:

  * Must be reusable by other projects.
  * Need to find other package:
    Projects need to find other packages.
    Not all the dependencies use cmake or provide a CMakeConfig.cmake
    You can provide one upstream or a FindXXX to CMake, but sometimes it is not enough because you need to support an older version of the library or of cmake
    Therefore you need to include a FindPackage in your project
    If you need that in several project you have to include it in every package
    when you realize that there is a bug in it, you have to update it everywhere, or you
  * Keep modules updated.
  * Can be developed by third party.
  * Different build system (cmake, autotools, etc).


* Funded Projects:

  * Re-use parts from other projects.
  * Modules not supposed to be reused.
  * Can produce different demos at specific stages of the project.


* Demos:

  * Must use software at a specific revision, to minimize Murphy's Law
    effects applied to demos (nonetheless your code will not work).


* Operating system:

  * Linux, Windows, OS X
  * Different IDE.
  * Packages can be supplied by the operating system.
  * Packages can be installed manually by the system administrator or
    by the user.
  * Support CMake version released with the system.
  * Reduce the number of tools that needs to be installed on the system.
  * Stable distribution, therefore it takes a lot of time before the new
    software is available.


* Hardware:

  * PC
  * Servers and clusters
  * Robots



* Superbuild

  * Download all missing repositories
  * Handle dependencies



The solution
============

* CMake

  * Minimum amount of dependencies (no Ruby, Python, etc).
  * Handles "external projects"
  * Easy to check if a pacakage is installed
  * No new tools to learn
  * Cross platform
  * Support for different compilers, build system, and IDE
  * Can be used as a cross platform scripting language


* Contribute upstream

  * Contribute patches upstream to make the world a better place.
  * Write patches in a way that will allow them to be accepted upstream.
  * Minimize duplication of efforts.
  * Reduce the effort to maintain code
  * Visibility in other communities.
  * Solve the issues "in the proper way" reducing the number of hacks
    and workarounds.

* YCM

  * A very tiny layer of CMake modules, easy to maintain
  * Working upstream
  * No extra dependencies
  * No magic (except maybe some for the bootstrap phase)
  * Try to respect standards and conventions
  * Incubator for CMake modules.
  * Easy for basic users, but powerful for advanced users.




Reference Manuals
#################

.. toctree::
   :maxdepth: 1

   /manual/ycm-user.7
   /manual/ycm-superbuild.7
   /manual/ycm-devel.7

   /manual/ycm-modules.7
   /manual/ycm-variables.7

   /manual/ycm-faq.7



Aknowledgements
###############

YCM was initially developed by iCub Facility, Istituto Italiano di Tecnologia
supported by the European Projects:

 * `WALK-MAN`_: Whole-body Adaptive Locomotion and Manipulation

.. _WALK-MAN: http://walk-man.eu/



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
