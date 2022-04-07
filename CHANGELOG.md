# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased Minor]

### Added
* Added new find module `FindSOXR.cmake` for libsoxr (https://github.com/robotology/ycm/pull/385)

### Changed
* CMake 3.16 or later is now required (https://github.com/robotology/ycm/pull/386).
* The `CMakeRC` module is imported again from the official repository, and it no longer prints the debug message (https://github.com/robotology/ycm/pull/384).
* Avoid to download files from online repositories as part of the build process (https://github.com/robotology/ycm/pull/402).

### Removed
* Removed `FindEigen3.cmake` module (https://github.com/robotology/ycm/pull/399).

## [Unreleased Patch]

### Changed
* Releases after 0.13.2 document their changes in a `CHANGELOG.md` file in the root of the repo (https://github.com/robotology/ycm/pull/397).
