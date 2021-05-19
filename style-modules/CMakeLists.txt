# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

set(YCM_STYLE_MODULES StyleBITBUCKET.cmake
                      StyleGITHUB.cmake
                      StyleGITLAB_ROBOTOLOGY.cmake
                      StyleGNOME.cmake
                      StyleKDE.cmake
                      StyleLOCAL.cmake
                      StyleNONE.cmake
                      StyleSOURCEFORGE.cmake)

_ycm_install(style-modules FILES ${YCM_STYLE_MODULES}
                           DESTINATION "${YCM_INSTALL_MODULE_DIR}/style-modules")

# Print a warning if we are overriding some module from CMake
foreach(_module IN LISTS YCM_STYLE_MODULES)
  if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
    message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
  endif()
endforeach()
