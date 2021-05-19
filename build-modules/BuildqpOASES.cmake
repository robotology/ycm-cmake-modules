# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildqpOASES
------------

qpOASES
#]=======================================================================]

# TYPE SVN STYLE COIN_OR
set(YCM_SVN_COIN_OR_USERNAME "" CACHE STRING "Username to use for coin-or svn repositories")
set(YCM_SVN_COIN_OR_PASSWORD "" CACHE STRING "Password to use for coin-or svn repositories")
set(YCM_SVN_COIN_OR_BASE_ADDRESS "https://projects.coin-or.org/svn/" CACHE INTERNAL "Address to use for coin-or svn repositories")
mark_as_advanced(YCM_SVN_COIN_OR_USERNAME YCM_SVN_COIN_OR_PASSWORD)

# qpOASES
include(YCMEPHelper)

ycm_ep_helper(qpOASES TYPE SVN
                      STYLE COIN_OR
                      REPOSITORY qpOASES/stable/3.0
                      TRUST_CERT 1
                      COMPONENT external
                      INSTALL_COMMAND "")
