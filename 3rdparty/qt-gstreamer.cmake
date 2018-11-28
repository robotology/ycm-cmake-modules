#=============================================================================
# Copyright 2013-2018 Istituto Italiano di Tecnologia (IIT)
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


##############################################################################
# FindGStreamer.cmake, FindGStreamerPluginsBase.cmake, FindGObject and their
# dependencies are taken from the qt-gstreamer repository

set(_files cmake/modules/COPYING-CMAKE-SCRIPTS            ff3ed70db4739b3c6747c7f624fe2bad70802987
           cmake/modules/FindGLIB2.cmake                  df497ba5188a8a98cb60d35a096680fd2e3140ce
           cmake/modules/FindGObject.cmake                fc749adf95db8b0f8de9a75a13abe637c44823f1
           cmake/modules/FindGStreamerPluginsBase.cmake   75d8fbd4e20afdd624e538d935f3ebabb10c2778
           cmake/modules/MacroFindGStreamerLibrary.cmake  0b9cca5a62c8d4ccec99e875a36d1531e5a899a1)
set(_ref a0e95b202a72b6d9e48bd1949ab6811c0f3c91c3)
set(_dir "${CMAKE_CURRENT_BINARY_DIR}/qt-gstreamer")
_ycm_download(3rdparty-qt-gstreamer
             "qt-gstreamer git repository"
             "https://raw.githubusercontent.com/GStreamer/qt-gstreamer/<REF>/<FILE>"
             ${_ref} "${_dir}" "${_files}")

# FindGStreamer.cmake requires some unmerged patches, therefore is downloaded
# from robotology-dependencies fork
set(_files cmake/modules/FindGStreamer.cmake              457b77fa471d29d79b11c02c88954fff6ec62456)
set(_ref e0a9f16815d7ce23e3d9cdece5dd06dc2b588116)
_ycm_download(3rdparty-qt-gstreamer
             "qt-gstreamer git repository"
             "https://raw.githubusercontent.com/robotology-dependencies/qt-gstreamer/<REF>/<FILE>"
             ${_ref} "${_dir}" "${_files}")

file(WRITE "${_dir}/README.qt-gstreamer"
"Some of the files in this folder and its subfolder come from the qt-gstreamer
git repository (ref ${_ref}):

  https://github.com/GStreamer/qt-gstreamer

Redistribution and use is allowed according to the terms of the 3-clause
BSD license. See accompanying file COPYING.qt-gstreamer for details.
")

_ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/cmake/modules/FindGLIB2.cmake"
                                         "${_dir}/cmake/modules/FindGObject.cmake"
                                         "${_dir}/cmake/modules/FindGStreamer.cmake"
                                         "${_dir}/cmake/modules/FindGStreamerPluginsBase.cmake"
                                         "${_dir}/cmake/modules/MacroFindGStreamerLibrary.cmake"
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")

_ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/cmake/modules/COPYING-CMAKE-SCRIPTS"
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty"
                                   RENAME COPYING.qt-gstreamer)

_ycm_install(3rdparty-qt-gstreamer FILES "${_dir}/README.qt-gstreamer"
                                   DESTINATION "${YCM_INSTALL_MODULE_DIR}/3rdparty")
