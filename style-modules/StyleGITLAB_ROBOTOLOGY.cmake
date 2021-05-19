# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
StyleGITLAB_ROBOTOLOGY
----------------------
#]=======================================================================]

# TYPE GIT STYLE GITLAB_ROBOTOLOGY
set(YCM_GIT_GITLAB_ROBOTOLOGY_USERNAME "" CACHE STRING "Username to use for IIT Robotology Gitlab git repositories")
set(YCM_GIT_GITLAB_ROBOTOLOGY_COMMIT_NAME "" CACHE STRING "Name to use for git commits for IIT Robotology Gitlab git repositories (if empty will use YCM_GIT_COMMIT_NAME)")
set(YCM_GIT_GITLAB_ROBOTOLOGY_COMMIT_EMAIL "" CACHE STRING "Email address to use for git commits for IIT Robotology Gitlab git repositories (if empty will use YCM_GIT_COMMIT_EMAIL)")
set(YCM_GIT_GITLAB_ROBOTOLOGY_BASE_ADDRESS "https://git.robotology.eu/" CACHE STRING "Address to use for IIT Robotology Gitlab git repositories")
set_property(CACHE YCM_GIT_GITLAB_ROBOTOLOGY_BASE_ADDRESS PROPERTY STRINGS "https://git.robotology.eu/"
                                                                           "ssh://git@git.robotology.eu/"
                                                                           "git@git.robotology.eu:"
                                                                           "robotology:")
mark_as_advanced(YCM_GIT_GITLAB_ROBOTOLOGY_USERNAME
                 YCM_GIT_GITLAB_ROBOTOLOGY_COMMIT_NAME
                 YCM_GIT_GITLAB_ROBOTOLOGY_COMMIT_EMAIL
                 YCM_GIT_GITLAB_ROBOTOLOGY_BASE_ADDRESS)
