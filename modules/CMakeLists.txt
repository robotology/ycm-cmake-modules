set(YCM_MODULES FindOrBuildPackage.cmake
                IncludeUrl.cmake
                MacroExtractVersion.cmake
                MacroStandardFindModule.cmake
                MacroUninstallTarget.cmake
                YCMEPHelper.cmake)

install(FILES ${YCM_MODULES}
        DESTINATION share/YCM/modules)
