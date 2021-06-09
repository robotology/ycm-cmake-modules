# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
StyleKDE
--------
#]=======================================================================]


# TYPE GIT STYLE KDE
set(YCM_GIT_KDE_USERNAME "" CACHE STRING "Username to use for kde git repositories")
set(YCM_GIT_KDE_COMMIT_NAME "" CACHE STRING "Name to use for git commits for kde git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
set(YCM_GIT_KDE_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for kde git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
set(YCM_GIT_KDE_BASE_ADDRESS "https://invent.kde.org/" CACHE STRING "Address to use for kde git repositories")
set_property(CACHE YCM_GIT_KDE_BASE_ADDRESS PROPERTY STRINGS "https://invent.kde.org/"
                                                             "ssh://git@invent.kde.org/"
                                                             "git@invent.kde.org:"
                                                             "kde:")
mark_as_advanced(YCM_GIT_KDE_USERNAME
                 YCM_GIT_KDE_COMMIT_NAME
                 YCM_GIT_KDE_COMMIT_EMAIL
                 YCM_GIT_KDE_BASE_ADDRESS)
