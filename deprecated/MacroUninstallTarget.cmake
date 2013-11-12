include(${CMAKE_CURRENT_LIST_DIR}/YCMDeprecatedWarning.cmake)
ycm_deprecated_warning("MacroUninstallTarget.cmake is deprecated. Use AddUninstallTarget instead.")

if(NOT YCM_NO_DEPRECATED)

    include(AddUninstallTarget)
    macro(MACRO_UNINSTALL_TARGET)
        ycm_deprecated_warning("MACRO_UNINSTALL_TARGET is deprecated. Use UNINSTALL_TARGET instead")
        uninstall_target(${ARGN})
    endmacro()

endif(NOT YCM_NO_DEPRECATED)