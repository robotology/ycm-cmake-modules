include(${CMAKE_CURRENT_LIST_DIR}/YCMDeprecatedWarning.cmake)
ycm_deprecated_warning("MacroExtractVersion.cmake is deprecated. Use ExtractVersion instead.")

if(NOT YCM_NO_DEPRECATED)

    include(ExtractVersion)
    macro(MACRO_EXTRACT_VERSION)
        ycm_deprecated_warning("MACRO_EXTRACT_VERSION is deprecated. Use EXTRACT_VERSION instead")
        extract_version(${ARGN})
    endmacro()

endif(NOT YCM_NO_DEPRECATED)
