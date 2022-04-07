# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

##############################################################################
# FindGStreamer.cmake, FindGStreamerPluginsBase.cmake, FindGObject and their
# dependencies are taken from the qt-gstreamer repository

set(_dir "${CMAKE_CURRENT_SOURCE_DIR}/qt-gstreamer")

if(YCM_DOWNLOAD_3RDPARTY)
  set(_files cmake/modules/COPYING-CMAKE-SCRIPTS            ff3ed70db4739b3c6747c7f624fe2bad70802987
             cmake/modules/FindGLIB2.cmake                  df497ba5188a8a98cb60d35a096680fd2e3140ce
             cmake/modules/FindGStreamerPluginsBase.cmake   75d8fbd4e20afdd624e538d935f3ebabb10c2778
             cmake/modules/MacroFindGStreamerLibrary.cmake  0b9cca5a62c8d4ccec99e875a36d1531e5a899a1)
  set(_ref a0e95b202a72b6d9e48bd1949ab6811c0f3c91c3)
  _ycm_download(3rdparty-qt-gstreamer
               "qt-gstreamer git repository"
               "https://raw.githubusercontent.com/GStreamer/qt-gstreamer/<REF>/<FILE>"
               ${_ref} "${_dir}" "${_files}")

  file(WRITE "${_dir}/README.qt-gstreamer"
"Some of the files in this folder and its subfolder come from the qt-gstreamer
git repository (ref ${_ref}):

  https://github.com/GStreamer/qt-gstreamer

Redistribution and use is allowed according to the terms of the 3-clause
BSD license. See accompanying file COPYING.qt-gstreamer for details.
")
endif()

# FindGStreamer.cmake and FindGObject require some unmerged patches, therefore
# they are downloaded from the robotology-dependencies fork
if(YCM_DOWNLOAD_3RDPARTY)
  set(_files cmake/modules/FindGStreamer.cmake              457b77fa471d29d79b11c02c88954fff6ec62456
             cmake/modules/FindGObject.cmake                bdb778ace33b0c5a47150594fc048c69ad02a16a)
  set(_ref 383c41d310b14c328ab6d5d02f478f9cca182bfb)
  _ycm_download(3rdparty-qt-gstreamer
               "qt-gstreamer git repository (robotology-dependency fork)"
               "https://raw.githubusercontent.com/robotology-dependencies/qt-gstreamer/<REF>/<FILE>"
               ${_ref} "${_dir}" "${_files}")
endif()

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
