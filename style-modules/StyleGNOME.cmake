# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
StyleGNOME
----------
#]=======================================================================]


# TYPE GIT STYLE GNOME
set(YCM_GIT_GNOME_USERNAME "" CACHE STRING "Username to use for gnome git repositories")
set(YCM_GIT_GNOME_COMMIT_NAME "" CACHE STRING "Name to use for git commits for gnome git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
set(YCM_GIT_GNOME_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for gnome git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
set(YCM_GIT_GNOME_BASE_ADDRESS "git://git.gnome.org/" CACHE STRING "Address to use for gnome git repositories")
set_property(CACHE YCM_GIT_GNOME_BASE_ADDRESS PROPERTY STRINGS "git://git.gnome.org/"
                                                               "ssh://git@git.gnome.org/"
                                                               "git@git.gnome.org:"
                                                               "gnome:")
mark_as_advanced(YCM_GIT_GNOME_USERNAME
                 YCM_GIT_GNOME_COMMIT_NAME
                 YCM_GIT_GNOME_COMMIT_EMAIL
                 YCM_GIT_GNOME_BASE_ADDRESS)
