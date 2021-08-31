.. cmake-manual-description: YCM FAQ

ycm-faq(7)
**********

.. only:: html or latex

   .. contents::

YCM FAQ
=======


.. _`FAQ:meaning`:

* :**Q**: What does YCM means?

  :**A**: Originally it was "`YARP`_ CMake
          Modules", but the name this makes no longer sense, therefore
          it is now just YCM. See also :ycm-issue:`40`


.. _`FAQ:issue-tracker`:

* :**Q**: How do I report a bug or request a feature?

  :**A**: Open a new bug on our `issue tracker <YCM Issue Tracker_>`_


.. _`FAQ:cmake-import`:

* :**Q**: CMake module XXX has a bug/missing feature in CMake version
          *N* and has been fixed/updated in CMake version *N+1*. Can you
          import the updated module in YCM and make it available for
          CMake *N* and older?

  :**A**: Yes, just open an issue or a merge request, but see the next
          question.


.. _`FAQ:what`:

* :**Q**: Can you actually use any module from a newer version of CMake?

  :**A**: No, modules using features that have been added in CMake
          source code cannot be imported directly.
          Nonetheless it is possible to supply a patched version of the
          module that does not use these features.


.. _`FAQ:cmake-version`:

* :**Q**: Why support CMake 3.16?
  :**A**: YCM was historically written to support `YARP`_, therefore the
          supported CMake versions are the same supported by `YARP`_.
          See `YARP Supported Distributions`_ for details.


.. _`FAQ:can-it-build`:

* :**Q**: Can a YCM superbuild build the ``PackageName`` package?

  :**A**: Probably it can, you will have to supply a
          ``BuildPackageName.cmake`` file with the instructions about how
          it should be built. You can use :module:`YCMEPHelper` or
          :cmake:module:`ExternalProject` to simplify the process. If
          ``PackageName`` is not written using CMake, writing such file
          might be a bit more difficult, but it can be done.


.. _`FAQ:ExternalProject`:

* :**Q**: Why using :cmake:module:`ExternalProject` instead of using
          git submodules, git externals, svn externals, or similar?

  :**A**: :cmake:module:`ExternalProject` supports Git, Subversion, CVS,
          Mercurial, and zipped files, not just git. Also integrating
          these tools in a CMake build would require some work anyway,
          and would make is slower to create a new superbuild project,
          just writing a ``CMakeLists.txt`` file is a lot easier.
          Also git submodules and git externals in an environment where users
          do not receive a proper training, introduce more issues than the
          ones they solve.


.. _`FAQ:IncludeUrl`:

* :**Q**: The :module:`IncludeUrl` module is just **evil**. It could be
          used to inject any code on your system.

  :**A**: That's why you can check the hash of the file included and why
          you don't usually build it as root. If you don't trust the
          source you shouldn't even build the software without checking
          the source code, but that rarely happens. Also the
          :module:`IncludeUrl` module is used only for the bootstrap
          phase, if YCM is installed on your system, the bootstrap phase
          will just be skipped. In your code you can just use
          ``find_package(YCM REQUIRED)`` and avoid using it.


.. _`FAQ:Bootstrap`:

* :**Q**: Why is the bootstrap phases checking the hashes of the files
          included in my project?

* :**A**: The bootstrap phase also checks that the files used for the
          bootstrap phase itself are updated, and warns the developer
          in order to make it easier to keep all the projects
          synchronized.


.. _`FAQ:ECM`:

* :**Q**: How is YCM different from `ECM`_ (KDE extra cmake modules)?

  :**A**: Conceptually it's not much different except for support for
          older CMake releases and bootstrap phase. For some time YCM
          was also able to bootstrap ECM as well, in order to be able to
          use ECM modules without installing them. This functionality
          has been removed for now, but might come back some time in the
          future.


.. _`FAQ:catkin`:

* :**Q**: How is YCM different from `catkin`_?

  :**A**: `catkin`_ and  are very specific for working with `ROS`_ and
          add extra dependencies to your project (i.e. python).
          Also `catkin`_ does a lot of magic, and we didn't like it when
          we tried it.


.. _`FAQ:rosbuild`:

* :**Q**: How is YCM different from `rosbuild`_ ?

  :**A**: `rosbuild`_ is deprecated, you should eventually consider
          using `catkin`_ instead.


.. _`FAQ:qibuild`:

* :**Q**: How is YCM different from `qibuild`_?

  :**A**: `qibuild`_ requires python. Also TODO


.. _`FAQ:Buildyard`:

* :**Q**: How is YCM different from `Buildyard`_

  :**A**: We were not aware of `Buildyard`_ when we started writing YCM.
          Some of the goals of the projects are very similar, but TODO


.. _`FAQ:biicode`:

* :**Q**: How is YCM different from `biicode`_

  :**A**: TODO.


.. _`FAQ:hunter`:

* :**Q**: How is YCM different from `hunter`_

  :**A**: TODO.


.. _`FAQ:Other`:

* :**Q**: How is YCM different from XXX

* :**A**: Probably we don't know about it.


.. _`FAQ:Hate`:

* :**Q**: I don't get it, I don't like YCM, I hate you.

* :**A**: Sorry.
