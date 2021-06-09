# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindqpOASES
-----------

Try to find the qpOASES library.
Once done this will define the following variables::

 qpOASES_FOUND         - System has qpOASES
 qpOASES_INCLUDE_DIRS  - qpOASES include directory
 qpOASES_LIBRARIES     - qpOASES libraries

qpOASES does not have an "install" step, and the includes are in the source
tree, while the libraries are in the build tree.
Therefore the environment and cmake variables `qpOASES_SOURCE_DIR` and
`qpOASES_BINARY_DIR` will be used to locate the includes and libraries.
#]=======================================================================]


include(FindPackageHandleStandardArgs)

find_path(qpOASES_INCLUDEDIR
          NAMES qpOASES.hpp
          HINTS "${qpOASES_SOURCE_DIR}"
                ENV qpOASES_SOURCE_DIR
          PATH_SUFFIXES include)
find_library(qpOASES_LIB
             NAMES qpOASES
             HINTS "${qpOASES_BINARY_DIR}"
                   ENV qpOASES_BINARY_DIR
             PATH_SUFFIXES lib
                           libs)

set(qpOASES_INCLUDE_DIRS ${qpOASES_INCLUDEDIR})
set(qpOASES_LIBRARIES ${qpOASES_LIB})

find_package_handle_standard_args(qpOASES DEFAULT_MSG qpOASES_LIBRARIES
                                                      qpOASES_INCLUDE_DIRS)
set(qpOASES_FOUND ${QPOASES_FOUND})
