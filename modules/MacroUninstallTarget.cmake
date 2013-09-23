# Add the "uninstall" target
#
# MACRO_UNINSTALL_TARGET(<package_name>)
#
# Create the uninstall target. For example
#
#    macro_uninstall_target(FOO)
#
# will create a file FOOConfigUninstall.cmake in the build directory and add a
# custom target uninstall that will remove the files installed by the FOO
# package (using install_manifest.txt)

# Copyright (C) 2011  RobotCub Consortium
# Copyright (C) 2013  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Lorenzo Natale <lorenzo.natale@iit.it>
#          Daniele E. Domenichelli <daniele.domenichelli@iit.it>
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

macro(MACRO_UNINSTALL_TARGET PKG)

set(_filename ${CMAKE_CURRENT_BINARY_DIR}/${PKG}ConfigUninstall.cmake)

file(WRITE ${_filename}
"if(NOT EXISTS \"${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt\")
    message(FATAL_ERROR \"Cannot find install manifest: \\\"${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt\\\"\")
endif()
file(READ \"${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt\" files)
string(REGEX REPLACE \"\\n\" \";\" files \"\${files}\")
foreach(file \${files})
    message(STATUS \"Uninstalling: \$ENV{DESTDIR}\${file}\")
    if(EXISTS \"\$ENV{DESTDIR}\${file}\")
        exec_program(\${CMAKE_COMMAND} ARGS \"-E remove \\\"\$ENV{DESTDIR}\${file}\\\"\"
                     OUTPUT_VARIABLE rm_out
                     RETURN_VALUE rm_retval)
        if(NOT \"\${rm_retval}\" STREQUAL 0)
            message(FATAL_ERROR \"Problem when removing \"\$ENV{DESTDIR}\${file}\"\")
        endif()
    else()
        message(STATUS \"File \\\"\$ENV{DESTDIR}\${file}\\\" does not exist.\")
    endif()
endforeach(file)
")

add_custom_target(uninstall COMMAND "${CMAKE_COMMAND}" -P "${_filename}")

endmacro()



#     message(STATUS "Uninstalling \\\"\$ENV{DESTDIR}\${file}\\\"\")
#     if(EXISTS \"\$ENV{DESTDIR}\${file}\")
#     else(EXISTS \"\$ENV{DESTDIR}\${file}\")
#         message(STATUS "File \\\"\$ENV{DESTDIR}\${file}\\\" does not exist.\")
#     endif(EXISTS \"\$ENV{DESTDIR}\${file}\")
