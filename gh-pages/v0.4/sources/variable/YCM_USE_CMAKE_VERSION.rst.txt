YCM_USE_CMAKE_<VERSION>
-----------------------
Use CMake modules imported from a specific CMake version.

Some modules you would like to use might not available on previous
CMake releases, or might have received some bugfix or new feature in
a specific CMake version.
If this variable is enabled, YCM will allow you to use the new version
of these modules with older versions.

For example by enabling ``YCM_USE_CMAKE_3_7``, some modules from
CMake 3.7 will be available for older CMake releases.

This option is available only if :cmake:variable:`CMAKE_VERSION` is
less than ``<VERSION>``.
