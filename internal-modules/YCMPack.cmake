# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

# This module should not be used outside YCM.

set(CPACK_PACKAGE_NAME "YCM")
set(CPACK_PACKAGE_VENDOR "Istituto Italiano di Tecnologia (IIT)")

set(CPACK_PACKAGE_VERSION_MAJOR "${YCM_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${YCM_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${YCM_VERSION_PATCH}")
set(CPACK_PACKAGE_VERSION "${YCM_VERSION_SHORT}")

set(CPACK_PACKAGE_DESCRIPTION_FILE "${YCM_SOURCE_DIR}/README.md")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Extra CMake Modules for YARP and friends")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "robotology/ycm-${YCM_VERSION_API}")
set(CPACK_RESOURCE_FILE_LICENSE "${YCM_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_WELCOME "${YCM_SOURCE_DIR}/tools/installer/welcome.txt")
set(CPACK_PACKAGE_ICON "${YCM_SOURCE_DIR}/tools/installer/ycm.ico")

if(NOT WIN32)
  set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${YCM_VERSION}-all")
else()
  # Produce an installer for 64bit windows
  enable_language(C)

  set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME} ${YCM_VERSION_API}")

  # WIX settings
  set(CPACK_WIX_UPGRADE_GUID 9130C806-91AD-4CE4-8C3A-2476F71FEF77)
  set(CPACK_WIX_CULTURES en-US it-IT)
  set(CPACK_WIX_CMAKE_PACKAGE_REGISTRY YCM)
  set(CPACK_WIX_PRODUCT_ICON "${CPACK_PACKAGE_ICON}")
  set(CPACK_WIX_UI_BANNER "${YCM_SOURCE_DIR}/tools/installer/ycm_banner.bmp")
  set(CPACK_WIX_UI_DIALOG "${YCM_SOURCE_DIR}/tools/installer/ycm_dialog.bmp")
  set(CPACK_WIX_PROPERTY_ARPCOMMENTS "${CPACK_PACKAGE_DESCRIPTION_SUMMARY}")
  set(CPACK_WIX_PROPERTY_ARPHELPLINK "http://robotology.github.io/ycm/")
  set(CPACK_WIX_PROPERTY_ARPURLINFOABOUT "http://github.com/robotology/ycm/")
  set(CPACK_WIX_PROPERTY_URLUPDATEINFO "http://github.com/robotology/ycm/releases/")

  # NSIS settings
  set(CPACK_NSIS_PACKAGE_NAME YCM)
  set(CPACK_NSIS_DISPLAY_NAME YCM)
  set(CPACK_NSIS_MUI_ICON "${CPACK_PACKAGE_ICON}")
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
  set(CPACK_NSIS_MODIFY_PATH OFF)
  set(CPACK_NSIS_HELP_LINK "http://robotology.github.io/ycm/")
  set(CPACK_NSIS_URL_INFO_ABOUT "http://github.com/robotology/ycm/")
  set(CPACK_NSIS_CONTACT "daniele.domenichelli@iit.it")

  # On Windows replace slashes in file name with escaped backslashes,
  # as NSIS is picky about Unix paths and using file(TO_NATIVE_PATH)
  # is not enough, as \s are not escaped
  foreach(_var CPACK_PACKAGE_DESCRIPTION_FILE
               CPACK_PACKAGE_INSTALL_DIRECTORY
               CPACK_RESOURCE_FILE_LICENSE
               CPACK_RESOURCE_FILE_WELCOME
               CPACK_PACKAGE_ICON
               CPACK_WIX_UI_BANNER
               CPACK_WIX_UI_DIALOG
               CPACK_NSIS_MUI_ICON)
    string(REPLACE "/" "\\\\" ${_var} "${${_var}}")
  endforeach()
endif()

set(CPACK_PACKAGE_CHECKSUM SHA1)

# Source package settings
if(EXISTS "${YCM_SOURCE_DIR}/.gitignore")
  file(STRINGS "${YCM_SOURCE_DIR}/.gitignore" CPACK_SOURCE_IGNORE_FILES)
  list(REMOVE_ITEM CPACK_SOURCE_IGNORE_FILES "/downloads/")
  string(REPLACE "*" ".*" CPACK_SOURCE_IGNORE_FILES "${CPACK_SOURCE_IGNORE_FILES}")
endif()
list(APPEND CPACK_SOURCE_IGNORE_FILES .git
                                      .gitattributes
                                      .gitignore
                                      .mailmap
                                      .travis.yml
                                      .appveyor.yml
                                      .github/)

set(CPACK_SOURCE_PACKAGE_FILE_NAME "ycm-${YCM_VERSION}-offline")

include(CPack)
