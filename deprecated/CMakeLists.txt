option(YCM_NO_DEPRECATED "Disable deprecated modules." FALSE)
mark_as_advanced(YARP_NO_DEPRECATED)

# Deprecated modules installed for compatibility
if(NOT YCM_NO_DEPRECATED)
    set(YCM_DEPRECATED_FILES YCMDeprecatedWarning.cmake
                             FindGthread.cmake
                             FindGtkMM.cmake
                             FindGtkMMUnix.cmake
                             FindGtkMMWin32.cmake
                             FindGtkPlus.cmake
                             FindGtkWin32.cmake)
    install(FILES ${YCM_DEPRECATED_FILES}
            DESTINATION share/YCM/deprecated)
endif()