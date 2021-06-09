# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindTinyXML
-----------

Try to find the TinyXML library.
Once done this will define the following variables::

 TinyXML_FOUND         - System has TinyXML
 TinyXML_INCLUDE_DIRS  - TinyXML include directory
 TinyXML_LIBRARIES     - TinyXML libraries
 TinyXML_DEFINITIONS   - Additional compiler flags for TinyXML
 TinyXML_VERSION       - TinyXML version
 TinyXML_MAJOR_VERSION - TinyXML major version
 TinyXML_MINOR_VERSION - TinyXML minor version
 TinyXML_PATCH_VERSION - TinyXML patch version
#]=======================================================================]

include(StandardFindModule)
standard_find_module(TinyXML tinyxml
                     SKIP_CMAKE_CONFIG)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(TinyXML PROPERTIES DESCRIPTION "A small, simple XML parser for the C++ language"
                                              URL "http://www.grinninglizard.com/tinyxml/index.html")
endif()
