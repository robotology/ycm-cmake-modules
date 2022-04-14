# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased Minor]

### Added
* Added new find module `FindSOXR.cmake` for libsoxr (https://github.com/robotology/ycm/pull/385).
* Add new `YCMBootstrapFetch.cmake` module that substitutes the `YCMBootstrap.cmake` module (https://github.com/robotology/ycm/pull/403). The new `YCMBootstrapFetch.cmake` script to permit projects to bootstrap YCM by just using `FetchContent` module. A different file is created as the semantics of this new bootstrap script is a bit different, as it just make YCM available in the project, but it does not also adds it as a subproject in the superbuild sense. Superbuilds that want to switch from `YCMBootstrap.cmake` to `YCMBootstrapFetch.cmake` need to create `BuildYCM.cmake` script, and appropriately call `find_or_build_package(YCM)`, as done for example in the robotology-superbuild in https://github.com/robotology/robotology-superbuild/pull/1078 .

### Changed
* CMake 3.16 or later is now required (https://github.com/robotology/ycm/pull/386).
* The `CMakeRC` module is imported again from the official repository, and it no longer prints the debug message (https://github.com/robotology/ycm/pull/384).

### Deprecated
* The `YCMBootstrap.cmake` module is now deprecated (https://github.com/robotology/ycm/pull/403).

### Removed
* Removed `FindEigen3.cmake` module (https://github.com/robotology/ycm/pull/399).

## [Unreleased Patch]

### Changed
* Releases after 0.13.2 document their changes in a `CHANGELOG.md` file in the root of the repo (https://github.com/robotology/ycm/pull/397).
