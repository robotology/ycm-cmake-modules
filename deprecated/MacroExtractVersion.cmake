#.rst:
# MacroExtractVersion (Replaced by :module:`ExtractVersion`)
# ----------------------------------------------------------
#
# .. warning:: This module is deprecated. You should use :module:`ExtractVersion` instead.

#=============================================================================
# Copyright 2013-2014 Istituto Italiano di Tecnologia (IIT)
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
ycm_deprecated_warning("MacroExtractVersion.cmake is deprecated. Use ExtractVersion instead.")

if(NOT YCM_NO_DEPRECATED)

    include(ExtractVersion)
    macro(MACRO_EXTRACT_VERSION)
        ycm_deprecated_warning("MACRO_EXTRACT_VERSION is deprecated. Use EXTRACT_VERSION instead")
        extract_version(${ARGN})
    endmacro()

endif(NOT YCM_NO_DEPRECATED)
