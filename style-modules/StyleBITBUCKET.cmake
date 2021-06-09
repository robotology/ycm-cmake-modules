# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
StyleBITBUCKET
--------------
#]=======================================================================]


# TYPE HG STYLE BITBUCKET
set(YCM_HG_BITBUCKET_USERNAME "" CACHE STRING "Name and email to use for Bitbucket hg repositories")
set(YCM_HG_BITBUCKET_COMMIT_USERNAME "" CACHE STRING "Name to use for git commits for Butbucket hg repositories (if empty will use YCM_GIT_COMMIT_NAME <YCM_GIT_COMMIT_EMAIL>)")
set(YCM_HG_BITBUCKET_BASE_ADDRESS "https://bitbucket.org/" CACHE STRING "Address to use for Bitbucket mercurial repositories")
set_property(CACHE YCM_HG_BITBUCKET_BASE_ADDRESS PROPERTY STRINGS "https://bitbucket.org/"
                                                                  "ssh://hg@bitbucket.org/")
mark_as_advanced(YCM_HG_BITBUCKET_USERNAME
                 YCM_HG_BITBUCKET_COMMIT_USERNAME
                 YCM_HG_BITBUCKET_BASE_ADDRESS)
