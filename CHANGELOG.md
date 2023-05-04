# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased Minor]

## [Unreleased Patch]

## [0.15.2] - 2023-05-04

### Fixed

* Make sure that FindGLM defines both `glm` and `glm::glm` imported targets (https://github.com/ami-iit/yarp-device-openxrheadset/issues/35, https://github.com/robotology/ycm/pull/430).

## [0.15.1] - 2023-01-10

### Added

* Added packaging for .tar.gz archives (https://github.com/robotology/ycm/pull/425).


## [0.15.0] - 2023-01-10

### Added

* Added `FinduSockets` and `FinduWebSockets` find modules  (https://github.com/robotology/ycm/pull/421). 

### Changed

* Update Catch vendored files from v2.13.4 to v3.2.1 (https://github.com/robotology/ycm/pull/422).
* Since release 0.15, all releases and development are happening on the `master` branch, while no ycm-0.15 or similar branches are created (https://github.com/robotology/ycm/issues/150). 

## [0.14.2] - 2022-06-10

### Added

* FindGraphviz: Add Graphviz_DEFINITIONS to define GVDLL to permit compilation against graphviz 3 (https://github.com/robotology/ycm/pull/414).

## [0.14.1] - 2022-05-24

### Added
* For each new release now `.deb` packages are automatically uploaded in the GitHub release page (https://github.com/robotology/ycm/pull/410).

## [0.14.0] - 2022-04-20

### Added
* Added new find module `FindSOXR.cmake` for libsoxr (https://github.com/robotology/ycm/pull/385).
* Add new `YCMBootstrapFetch.cmake` module that substitutes the `YCMBootstrap.cmake` module (https://github.com/robotology/ycm/pull/403). The new `YCMBootstrapFetch.cmake` script to permit projects to bootstrap YCM by just using `FetchContent` module. A different file is created as the semantics of this new bootstrap script is a bit different, as it just make YCM available in the project, but it does not also adds it as a subproject in the superbuild sense. Superbuilds that want to switch from `YCMBootstrap.cmake` to `YCMBootstrapFetch.cmake` need to create `BuildYCM.cmake` script, and appropriately call `find_or_build_package(YCM)`, as done for example in the robotology-superbuild in https://github.com/robotology/robotology-superbuild/pull/1078 .

### Changed
* CMake 3.16 or later is now required (https://github.com/robotology/ycm/pull/386).
* The `CMakeRC` module is imported again from the official repository, and it no longer prints the debug message (https://github.com/robotology/ycm/pull/384).
* Avoid to download files from online repositories as part of the build process (https://github.com/robotology/ycm/pull/402).
* FindOrBuildPackage: Do not call find_package if YCM_DISABLE_SYSTEM_PACKAGES is ON (https://github.com/robotology/ycm/pull/404). This change speeds up the CMake configuration time for superbuild that have many packages and `YCM_DISABLE_SYSTEM_PACKAGES` set to `ON`.

### Deprecated
* The `YCMBootstrap.cmake` module is now deprecated (https://github.com/robotology/ycm/pull/403).

### Removed
* Removed `FindEigen3.cmake` module (https://github.com/robotology/ycm/pull/399).
* Removed `FindGSL.cmake`, `FindGLUT.cmake`, `FindOpenGL.cmake` and `YCMDefaultDirs.cmake`. The first three are available in CMake, while the last one has been deprecated for a long time (https://github.com/robotology/ycm/pull/401).

## [0.13.2] - 2022-04-06

### Changed
* Releases after 0.13.2 document their changes in a `CHANGELOG.md` file in the root of the repo (https://github.com/robotology/ycm/pull/397).

### Fixed
* Fix error that occured if find_package(GLFW3) was called two times (https://github.com/robotology/ycm/pull/398)
