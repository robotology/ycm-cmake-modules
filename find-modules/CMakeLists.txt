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
                     FindGLUT.cmake
                     FindGooCanvas.cmake
                     FindGooCanvasMM.cmake
                     FindGSL.cmake
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
                     FindOpenGL.cmake
                     FindOpenNI.cmake
                     FindOpenNI2.cmake
                     FindPLXCANAPI.cmake
                     FindPortAudio.cmake
                     FindqpOASES.cmake
                     FindQt3.cmake
                     FindReadline.cmake
                     FindSQLite.cmake
                     FindStage.cmake
                     FindTinyXML.cmake
                     FindYamlCpp.cmake
                     FindZFP.cmake)

_ycm_install(find-modules FILES ${YCM_FIND_MODULES}
                          DESTINATION "${YCM_INSTALL_MODULE_DIR}/find-modules")

# Print a warning if we are overriding some module from CMake
foreach(_module IN LISTS YCM_FIND_MODULES)
  if(EXISTS ${CMAKE_ROOT}/Modules/${_module})
    message(AUTHOR_WARNING "A \"${_module}\" module already exists in CMAKE_ROOT. Please remove it, or move it to proposed.")
  endif()
endforeach()
