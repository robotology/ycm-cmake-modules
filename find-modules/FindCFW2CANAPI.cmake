# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2010 RobotCub Consortium
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindCFW2CANAPI
--------------

Created::

 CFW2CANAPI_INC_DIRS   - Directories to include to use esdcan api
 CFW2CANAPI_LIB        - Default library to link against to use the esdcan API
 CFF2CANAPI_FOUND      - If false, don't try to use esdcan API
#]=======================================================================]


if(NOT CFW2CANAPI_FOUND)
    set(CFW2CANAPI_DIR $ENV{CFW2CANAPI_DIR} CACHE PATH "Path to CFW2CANAPI")
    set(CFW2CANAPI_INC_DIRS ${CFW2CANAPI_DIR}/LinuxDriver/API)

    if(WIN32)
       #sorry not available in windows
    else()
        find_library(CFW2CANAPI_LIB cfw002 ${CFW2CANAPI_DIR}/LinuxDriver/API)
    endif()

    if(CFW2CANAPI_LIB)
       set(CFW2CANAPI_FOUND TRUE)
    else()
       set(CFW2CANAPI_FOUND FALSE)
       set(CFW2CANAPI_INC_DIRS)
       set(CFW2CANAPI_LIB )
    endif(CFW2CANAPI_LIB)

endif(NOT CFW2CANAPI_FOUND)
