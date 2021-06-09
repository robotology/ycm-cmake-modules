# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindGooCanvasMM
---------------

Try to find the GooCanvasMM library.
Once done this will define the following variables::

 GooCanvasMM_FOUND         - System has GooCanvasMM
 GooCanvasMM_INCLUDE_DIRS  - GooCanvasMM include directory
 GooCanvasMM_LIBRARIES     - GooCanvasMM libraries
 GooCanvasMM_DEFINITIONS   - Additional compiler flags for GooCanvasMM
 GooCanvasMM_VERSION       - GooCanvasMM version
 GooCanvasMM_MAJOR_VERSION - GooCanvasMM major version
 GooCanvasMM_MINOR_VERSION - GooCanvasMM minor version
 GooCanvasMM_PATCH_VERSION - GooCanvasMM patch version
 GooCanvasMM_TWEAK_VERSION - GooCanvasMM tweak version

If the library is found, the imported target ``GooCanvasMM::goocanvasmm`` is
created.
#]=======================================================================]


include(StandardFindModule)
include(ReplaceImportedTargets)
include(CMakeFindDependencyMacro)

find_dependency(GTK2)
find_dependency(GooCanvas)

standard_find_module(GooCanvasMM goocanvasmm-1.0
                     TARGET GooCanvasMM::goocanvasmm
                     REPLACE_TARGETS ${GTK2_LIBRARIES}
                                     ${GooCanvas_LIBRARIES})

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(GooCanvasMM PROPERTIES DESCRIPTION "A GtkMM wrapper for GooCanvas"
                                                  URL "http://live.gnome.org/GooCanvas")
endif()
