YCM_USE_CMAKE_3_0
-----------------

Use CMake modules imported from CMake 3.0.

Some modules you would like to use might not available on CMake 2.8.12,
or might have received some bugfix or new feature in CMake 3.0.
If this variable is enabled, YCM will allow you to use the new version
of these modules with CMake 3.0 or older versions.

This option is available only if :cmake:variable:`CMAKE_VERSION` is
3.0 or older.
