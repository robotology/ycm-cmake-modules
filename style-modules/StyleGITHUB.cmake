# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
StyleGITHUB
-----------
#]=======================================================================]


# TYPE GIT STYLE GITHUB
set(YCM_GIT_GITHUB_USERNAME "" CACHE STRING "Username to use for github git repositories")
set(YCM_GIT_GITHUB_COMMIT_NAME "" CACHE STRING "Name to use for git commits for github git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
set(YCM_GIT_GITHUB_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for github git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
set(YCM_GIT_GITHUB_BASE_ADDRESS "https://github.com/" CACHE STRING "Address to use for github git repositories")
set_property(CACHE YCM_GIT_GITHUB_BASE_ADDRESS PROPERTY STRINGS "https://github.com/"
                                                                "git://github.com/"
                                                                "ssh://git@github.com/"
                                                                "git@github.com:"
                                                                "github:")
mark_as_advanced(YCM_GIT_GITHUB_USERNAME
                 YCM_GIT_GITHUB_COMMIT_NAME
                 YCM_GIT_GITHUB_COMMIT_EMAIL
                 YCM_GIT_GITHUB_BASE_ADDRESS)
