#.rst:
# FindYamlCpp
# -----------
#
# Try to find the YamlCpp library.
# Once done this will define the following variables:
#
# YamlCpp_FOUND         - System has YamlCpp
# YamlCpp_INCLUDE_DIRS  - YamlCpp include directory
# YamlCpp_LIBRARIES     - YamlCpp libraries
# YamlCpp_DEFINITIONS   - Additional compiler flags for YamlCpp
# YamlCpp_VERSION       - YamlCpp version
# YamlCpp_MAJOR_VERSION - YamlCpp major version
# YamlCpp_MINOR_VERSION - YamlCpp minor version
# YamlCpp_PATCH_VERSION - YamlCpp patch version
# YamlCpp_TWEAK_VERSION - YamlCpp tweak version

# Copyright (C) 2014  iCub Facility, Istituto Italiano di Tecnologia
# Author: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

include(StandardFindModule)
standard_find_module(YamlCpp yaml-cpp)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(YamlCpp PROPERTIES DESCRIPTION "yaml-cpp is a YAML parser and emitter in C++"
                                              URL "https://code.google.com/p/yaml-cpp/")
endif()
