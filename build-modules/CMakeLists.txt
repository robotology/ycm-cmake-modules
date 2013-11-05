set(YCM_BUILD_MODULES BuildECM.cmake
                      BuildGooCanvas.cmake
                      BuildTemplateExe.cmake
                      BuildTemplateLib.cmake
                      BuildTinyXML.cmake
                      BuildYARP.cmake
                      BuildICUB.cmake)

install(FILES ${YCM_BUILD_MODULES}
        DESTINATION share/YCM/build-modules)
