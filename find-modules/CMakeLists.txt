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
                     FindTinyXML.cmake)

install(FILES ${YCM_FIND_MODULES}
       DESTINATION share/YCM/find-modules)
