#=============================================================================
# Copyright 2013-2014 iCub Facility, Istituto Italiano di Tecnologia
#   Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of YCM, substitute the full
#  License text for the above reference.)


set(YCM_MODULES AddRPATHSupport.cmake
                AddUninstallTarget.cmake
                ExtractVersion.cmake
                FindOrBuildPackage.cmake
                GitInfo.cmake
                IncludeUrl.cmake
                InstallBasicPackageFiles.cmake
                StandardFindModule.cmake
                YCMDefaultDirs.cmake
                YCMEPHelper.cmake)

_ycm_install(modules FILES ${YCM_MODULES}
                     DESTINATION "${YCM_INSTALL_MODULE_DIR}/modules")
