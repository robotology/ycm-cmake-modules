# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# FindEigen3.cmake is taken from the Eigen3 repository.
# It is no longer necessary since Eigen 3.3.1

set(_files COPYING.BSD             8fa159b3e41e0a44e10ea224cbb83e66ae02885e
           cmake/FindEigen3.cmake  5ad2b8e1ddbd9f0468b21e9d5343d05eda6b9dd1)
set(_ref a12b8a8c75ebef312509da643424951725519348)
set(_dir "${CMAKE_CURRENT_BINARY_DIR}/eigen3")

_ycm_download(3rdparty-eigen
              "Eigen GitLab repository"
              "https://gitlab.com/libeigen/eigen/raw/<REF>/<FILE>"
              ${_ref} "${_dir}" "${_files}")
file(WRITE "${_dir}/README.Eigen"
"Some of the files in this folder and its subfolder come from the Eigen git
repository (ref ${_ref}):

  https://gitlab.com/libeigen/eigen

Redistribution and use is allowed according to the terms of the 2-clause
BSD license. See accompanying file COPYING.Eigen for details.
")

_ycm_install(3rdparty-eigen FILES "${_dir}/cmake/FindEigen3.cmake"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-eigen FILES "${_dir}/COPYING.BSD"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                            RENAME COPYING.Eigen)

_ycm_install(3rdparty-eigen FILES "${_dir}/README.Eigen"
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
