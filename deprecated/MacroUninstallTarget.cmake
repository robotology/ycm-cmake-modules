#.rst:
# MacroUninstallTarget (Replaced by :module:`AddUninstallTarget`)
# ---------------------------------------------------------------
#
# .. warning:: This module is deprecated. You should use :module:`AddUninstallTarget` instead.

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


include(${CMAKE_CURRENT_LIST_DIR}/YCMDeprecatedWarning.cmake)
ycm_deprecated_warning("MacroUninstallTarget.cmake is deprecated. Use AddUninstallTarget instead.")

if(NOT YCM_NO_DEPRECATED)

    include(AddUninstallTarget)
    macro(MACRO_UNINSTALL_TARGET)
        ycm_deprecated_warning("MACRO_UNINSTALL_TARGET is deprecated. Use UNINSTALL_TARGET instead")
        uninstall_target(${ARGN})
    endmacro()

endif(NOT YCM_NO_DEPRECATED)
