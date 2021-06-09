# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindGtkDatabox
--------------

Try to find the GtkDatabox library.
Once done this will define the following variables::

 GtkDatabox_FOUND         - System has GtkDatabox
 GtkDatabox_INCLUDE_DIRS  - GtkDatabox include directory
 GtkDatabox_LIBRARIES     - GtkDatabox libraries
 GtkDatabox_DEFINITIONS   - Additional compiler flags for GtkDatabox
 GtkDatabox_VERSION       - GtkDatabox version
 GtkDatabox_MAJOR_VERSION - GtkDatabox major version
 GtkDatabox_MINOR_VERSION - GtkDatabox minor version
 GtkDatabox_PATCH_VERSION - GtkDatabox patch version
 GtkDatabox_TWEAK_VERSION - GtkDatabox tweak version

If the library is found, the imported target ``GtkDatabox::gtkdatabox`` is
created.
#]=======================================================================]

include(StandardFindModule)
include(ReplaceImportedTargets)
include(CMakeFindDependencyMacro)

find_dependency(GTK2)

standard_find_module(GtkDatabox gtkdatabox
                     TARGET GtkDatabox::gtkdatabox
                     REPLACE_TARGETS ${GTK2_LIBRARIES})

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(GtkDatabox PROPERTIES DESCRIPTION "A GTK+ widget for live display of large amounts of fluctuating numerical data"
                                                 URL "http://sourceforge.net/projects/gtkdatabox/")
endif()
