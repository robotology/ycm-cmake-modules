include(${CMAKE_CURRENT_LIST_DIR}/YCMDeprecatedWarning.cmake)
ycm_deprecated_warning("MacroStandardFindModule.cmake is deprecated. Use StandardFindModule instead.")

if(NOT YCM_NO_DEPRECATED)

    include(StandardFindModule)
    macro(MACRO_STANDARD_FIND_MODULE)
        ycm_deprecated_warning("MACRO_STANDARD_FIND_MODULE is deprecated. Use STANDARD_FIND_MODULE instead")
        standard_find_module(${ARGN})
    endmacro()

endif(NOT YCM_NO_DEPRECATED)