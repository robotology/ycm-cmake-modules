set(YCM_MODULES MacroExtractVersion.cmake
                MacroStandardFindModule.cmake
                MacroUninstallTarget.cmake)

install(FILES ${YCM_MODULES}
        DESTINATION share/YCM/modules)
