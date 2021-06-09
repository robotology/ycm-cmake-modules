# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildECM
--------

ECM - extra-cmake-modules (from KDE project)
#]=======================================================================]

include(YCMEPHelper)

ycm_ep_helper(ECM TYPE GIT
                  STYLE KDE
                  REPOSITORY extra-cmake-modules.git
                  TAG master)
