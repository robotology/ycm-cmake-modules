# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

set(YCM_MODULES AddInstallRPATHSupport.cmake
                AddUninstallTarget.cmake
                ExtractVersion.cmake
                FindOrBuildPackage.cmake
                GetAllCMakeProperties.cmake
                GitInfo.cmake
                IncludeUrl.cmake
                InstallBasicPackageFiles.cmake
                ReplaceImportedTargets.cmake
                StandardFindModule.cmake
                YCMEPHelper.cmake)

_ycm_install(modules FILES ${YCM_MODULES}
                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/modules")

# Print a warning if we are overriding some module from CMake
foreach(_module IN LISTS YCM_MODULES)
  if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
    message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
  endif()
endforeach()
