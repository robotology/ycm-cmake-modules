:orphan:

.. title:: YCM Highlights

YCM Highlights
**************

.. only:: html or latex

   .. contents::


The problem
===========


* Research environment:

  * Publish or perish.
  * Quick development.
  * Write software that just "works".
  * No time to spend on the build system.
  * No time to work directly upstream.
  * No software review process.


* Users:

  * A very different set of skills:

    * Different field: software, firmware, electronics, hardware.
    * Different role: students, researchers, developers, release managers, team leaders.
    * Different goals.
    * Different operating system.
    * Different habits.

  * Will modify only a limited subset of packages.
  * Will not be properly trained before committing to the repositories.
  * Everyone has commit access to all the repositories, and will commit directly
    without requesting a review.


* Research groups:

  * Group identity.
  * Different hosts where the code is stored.
  * Sometimes the code is not public.
  * Different SCM.
  * Different build system.


* Funded Projects:

  * Re-use parts from other projects.
  * Will have parts that are supposed to be reused by other projects, and
    parts specific to that project and not supposed to be reused.
  * Can produce different demos at specific stages of the project.
  * Produce "stacks" (list of software used to accomplish something).


* Demos:

  * "Snapshot" of a project at a certain stage.
  * Shows a certain feature, not necessarily properly integrated with the
    others.
  * Software is not always stable, but a user must be able to checkout the whole
    stack at a specific version.
  * Must use software at a specific revision, to minimize Murphy's Law
    effects applied to demos (nonetheless your code will not work).


* Software Projects:

  * Must be reusable by other projects. In order to be found it should provide
    at least a ``ProjectConfig.cmake`` file.
  * Need to find other package. Not all the dependencies use cmake or provide a
    ``ProjectConfig.cmake``. If they don't:

    * You can provide a ``ProjectConfig.cmake`` upstream, but sometimes you have
      to support older version of the library that still don't have the file.
    * You can provide a ``FindProject.cmake`` to CMake, but sometimes it is not
      enough because you need to support an older version of cmake.
    * You can to include a ``FindPackage.cmake`` in your project, but if you
      have several projects that use the same library, you have to keep multiple
      copies of this file and keep them in sync when you update one.

  * Can be developed by third party.
  * Can offer another way to be found (e.g. ``pkg-config``)
  * Different build system (CMake, autotools, etc).



* Operating system:

  * Linux, Windows, OS X.
  * Different IDEs.
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
  * Handles "external projects".
  * Easy to check if a pacakage is installed.
  * No new tools to learn.
  * Cross platform.
  * Support for different compilers, build system, and IDE.
  * Can be used as a cross platform scripting language.


* Contribute upstream

  * Contribute patches upstream to make the world a better place.
  * Write patches in a way that will allow them to be accepted upstream.
  * Minimize duplication of efforts.
  * Reduce the effort to maintain code.
  * Visibility in other communities.
  * Solve the issues "in the proper way" reducing the number of hacks
    and workarounds.


* YCM

  * A very tiny layer of CMake modules, easy to maintain.
  * Incubator and testing ground for CMake modules and patches that can be later
    ported upstream.
  * No extra dependencies.
  * No magic (except maybe some for the bootstrap phase).
  * Try to respect standards and conventions.
  * Easy for basic users, but powerful for advanced users.
  * Use the same documentation and testing tools used upstream to simplify the
    contribution of patches and modules.
  * Not as much stable as CMake, but try to maintain compatibility.
