# ycm-cmake-modules

Extra CMake Modules for YARP and friends.

## Installation

### From PyPI

Run the following command to install YCM from PyPI:

```bash
pip install ycm_cmake_modules
```

### From sources

Run the following command to install YCM from the master branch:

```bash
pip install "git+https://github.com/robotology/ycm@master#egg=ycm_cmake_modules&subdirectory=tools/pip"
```

### From cloned repository

Run the following command to install YCM from the root of a cloned repository:

```bash
pip install tools/pip
```

Note: if you use `pip < 21.3` you also need to pass `--use-feature=in-tree-build`.

### Create source and wheel distributions

Run the following to create the source distribution (sdist) and the binary distribution (wheel):

```bash
pip install build
python -m build -o dist/ tools/pip
```
