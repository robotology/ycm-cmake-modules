# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

set(YCM_FIND_MODULES FindACE.cmake
                     FindAtlas.cmake
                     FindCFW2CANAPI.cmake
                     FindDRAGONFLYAPI.cmake
                     FindESDCANAPI.cmake
                     FindFFMPEG.cmake
                     FindGLUT.cmake
                     FindGooCanvas.cmake
                     FindGooCanvasMM.cmake
                     FindGSL.cmake
                     FindGtkDatabox.cmake
                     FindGtkDataboxMM.cmake
                     FindIPOPT.cmake
                     FindIPP.cmake
                     FindODE.cmake
                     FindOpenCV.cmake
                     FindOpenGL.cmake
                     FindPLXCANAPI.cmake
                     FindPortAudio.cmake
                     FindQt3.cmake
                     FindSQLite.cmake
                     FindTinyXML.cmake
                     FindYamlCpp.cmake)

install(FILES ${YCM_FIND_MODULES}
       DESTINATION share/YCM/find-modules)
