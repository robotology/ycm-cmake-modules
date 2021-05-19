# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2009 RobotCub Consortium
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindESDCANAPI
-------------

Created::

 ESDCANAPI_INC_DIRS   - Directories to include to use esdcan api
 ESDCANAPI_LIB        - Default library to link against to use the esdcan API
 ESDCANAPI_FOUND      - If false, don't try to use esdcan API
#]=======================================================================]

if(NOT ESDCANAPI_FOUND)
  #we look for the lib, give priority to ESDCANAPI_DIR which should point to
  #the correct place, but also look in other locations. CAnSdkDir should be set
  #by the installer.
  set(ESDCANAPI_DIR $ENV{ESDCANAPI_DIR} CACHE PATH "Path to ESDCANAPI")

  if(WIN32)

    # Add possible search paths
    list(APPEND ESDCAN_LIB_DIRS ${ESDCANAPI_DIR}/develop/vc)
    list(APPEND ESDCAN_LIB_DIRS ${CanSdkDir}/develop/vc)
    list(APPEND ESDCAN_LIB_DIRS ${ESDCANAPI_DIR}/winnt)

    list(APPEND ESDCAN_INC_DIRS ${ESDCANAPI_DIR})
    list(APPEND ESDCAN_INC_DIRS ${CanSdkDir})
    
   if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      # 64-bit    
      set(ESDCANAPI_ARCH "amd64")
    else()
      # 32-bit 
      set(ESDCANAPI_ARCH "i368")
    endif()

    # Build directory names depending on system architecture
    if(DEFINED ENV{PROGRAMFILES})
      list(APPEND ESDCAN_LIB_DIRS "$ENV{PROGRAMFILES}/CAN/develop/vc")
      list(APPEND ESDCAN_LIB_DIRS "$ENV{PROGRAMFILES}/ESD/CAN/SDK/lib/VC/${ESDCANAPI_ARCH}")

      list(APPEND ESDCAN_INC_DIRS "$ENV{PROGRAMFILES}/CAN")
      list(APPEND ESDCAN_INC_DIRS "$ENV{PROGRAMFILES}/ESD/CAN/SDK")
    endif()
    if(DEFINED ENV{ProgramW6432})
      list(APPEND ESDCAN_LIB_DIRS "$ENV{ProgramW6432}/CAN/develop/vc")
      list(APPEND ESDCAN_LIB_DIRS "$ENV{ProgramW6432}/ESD/CAN/SDK/lib/VC/${ESDCANAPI_ARCH}")

      list(APPEND ESDCAN_INC_DIRS "$ENV{ProgramW6432}/CAN")
      list(APPEND ESDCAN_INC_DIRS "$ENV{ProgramW6432}/ESD/CAN/SDK")
    endif()

    # Find library
    find_library(ESDCANAPI_LIB
                 NAMES "ntcan"
                 PATHS ${ESDCAN_LIB_DIRS})

    # Find include file
    find_path(ESDCANAPI_INC_DIRS
              NAMES "ntcan.h "
              PATHS ${ESDCAN_INC_DIRS}
              PATH_SUFFIXES "include")

  else()

    find_library(ESDCANAPI_LIB ntcan
                 ${ESDCANAPI_DIR}/lib32
                 ${ESDCANAPI_DIR}/lib64)
    set(ESDCANAPI_INC_DIRS ${ESDCANAPI_DIR}/lib32)

  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(ESDCANAPI
                                    DEFAULT_MSG
                                    ESDCANAPI_LIB
                                    ESDCANAPI_INC_DIRS)


  mark_as_advanced(ESDCANAPI_LIB ESDCANAPI_INC_DIRS)

endif()
