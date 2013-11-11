set(YCM_MODULES AddUninstallTarget.cmake
                ExtractVersion.cmake
                FindOrBuildPackage.cmake
                IncludeUrl.cmake
                StandardFindModule.cmake
                YCMEPHelper.cmake)

install(FILES ${YCM_MODULES}
        DESTINATION share/YCM/modules)
