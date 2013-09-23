option(YCM_NO_DEPRECATED "Disable deprecated modules." FALSE)

# Deprecated modules installed for compatibility
if(NOT YCM_NO_DEPRECATED)
    set(YCM_DEPRECATED_FILES FindGthread.cmake
                             FindGtkMM.cmake
                             FindGtkMMUnix.cmake
                             FindGtkMMWin32.cmake
                             FindGtkPlus.cmake
                             FindGtkWin32.cmake)
    install(FILES ${YCM_DEPRECATED_FILES}
            DESTINATION share/YCM/deprecated)
endif()