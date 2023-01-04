# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

set(YCM_FIND_MODULES FindACE.cmake
                     Findassimp.cmake
                     FindAtlas.cmake
                     FindCFW2CANAPI.cmake
                     FindDRAGONFLYAPI.cmake
                     FindESDCANAPI.cmake
                     FindFreenect.cmake
                     FindFTDI.cmake
                     FindFuse.cmake
                     FindGLFW3.cmake
                     FindGLM.cmake
                     FindGooCanvas.cmake
                     FindGooCanvasMM.cmake
                     FindGtkDatabox.cmake
                     FindGtkDataboxMM.cmake
                     FindI2C.cmake
                     FindIPOPT.cmake
                     FindIPP.cmake
                     FindLibdc1394.cmake
                     FindLibedit.cmake
                     FindLibOVR.cmake
                     FindLibusb1.cmake
                     FindLibv4l2.cmake
                     FindLibv4lconvert.cmake
                     FindNVIDIACg.cmake
                     FindODE.cmake
                     FindOpenCV.cmake
                     FindOpenNI.cmake
                     FindOpenNI2.cmake
                     FindPLXCANAPI.cmake
                     FindPortAudio.cmake
                     FindqpOASES.cmake
                     FindReadline.cmake
                     FindSOXR.cmake
                     FindSQLite.cmake
                     FindStage.cmake
                     FindTinyXML.cmake
                     FinduSockets.cmake
                     FinduWebSockets.cmake
                     FindYamlCpp.cmake
                     FindZFP.cmake)

_ycm_install(find-modules FILES ${YCM_FIND_MODULES}
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/find-modules")

# Print a warning if we are overriding some module from CMake
foreach(_module IN LISTS YCM_FIND_MODULES)
  if(EXISTS "${CMAKE_ROOT}/Modules/${_module}")
    message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
  endif()
endforeach()
