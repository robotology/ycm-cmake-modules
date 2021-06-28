import os
from pathlib import Path

import cmake_build_extension
from setuptools import setup

if (Path(".") / "CMakeLists.txt").exists():
    # Install from sdist
    source_dir = str(Path(".").absolute())
else:
    # Install from sources or build wheel
    source_dir = str(Path(".").absolute().parent.parent)

if "CIBUILDWHEEL" in os.environ and os.environ["CIBUILDWHEEL"] == "1":
    CIBW_CMAKE_OPTIONS = ["-DCMAKE_INSTALL_LIBDIR=lib"]
else:
    CIBW_CMAKE_OPTIONS = []


setup(
    cmdclass=dict(
        build_ext=cmake_build_extension.BuildExtension,
        sdist=cmake_build_extension.GitSdistFolder,
    ),
    ext_modules=[
        cmake_build_extension.CMakeExtension(
            name="CMakeProject",
            install_prefix="ycm_cmake_modules",
            disable_editable=True,
            write_top_level_init="",
            source_dir=source_dir,
            cmake_configure_options=[
                "-DBUILD_TESTING:BOOL=OFF",
                "-DYCM_NO_DEPRECATED:BOOL=ON",
            ]
            + CIBW_CMAKE_OPTIONS,
        ),
    ],
)
