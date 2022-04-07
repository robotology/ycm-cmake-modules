# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

option(YCM_NO_DEPRECATED "Disable deprecated modules." FALSE)
mark_as_advanced(YARP_NO_DEPRECATED)

# Deprecated modules installed for compatibility
if(NOT YCM_NO_DEPRECATED)
  set(YCM_DEPRECATED_FILES
  )
  if(YCM_DEPRECATED_FILES)
    _ycm_install(deprecated FILES ${YCM_DEPRECATED_FILES}
                            DESTINATION "${YCM_INSTALL_MODULE_DIR}/deprecated")
  endif()

  # Print a warning if we are overriding some module from CMake
  foreach(_module IN LISTS YCM_DEPRECATED_FILES)
    if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
      message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
    endif()
  endforeach()

endif()
