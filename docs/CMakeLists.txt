# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-FileCopyrightText: 2000-2013 Kitware Inc.
# SPDX-FileCopyrightText: 2000-2013 Insight Software Consortium
# SPDX-License-Identifier: BSD-3-Clause

# if(NOT YCM_SOURCE_DIR)
#   set(CMakeHelp_STANDALONE 1)
#   cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR)
#   get_filename_component(tmp "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
#   get_filename_component(YCM_SOURCE_DIR "${tmp}" DIRECTORY)
#   include(${YCM_SOURCE_DIR}/Modules/CTestUseLaunchers.cmake)
#   include(${YCM_SOURCE_DIR}/Source/CMakeVersionCompute.cmake)
#   include(${YCM_SOURCE_DIR}/Source/CMakeInstallDestinations.cmake)
#   unset(CMAKE_DATA_DIR)
#   unset(CMAKE_DATA_DIR CACHE)
# endif()
project(YCMHelp NONE)

option(SPHINX_MAN "Build man pages with Sphinx" OFF)
option(SPHINX_HTML "Build html help with Sphinx" OFF)
option(SPHINX_SINGLEHTML "Build html single page help with Sphinx" OFF)
option(SPHINX_QTHELP "Build Qt help with Sphinx" OFF)
option(SPHINX_TEXT "Build text help with Sphinx (not installed)" OFF)
find_program(SPHINX_EXECUTABLE
  NAMES sphinx-build
  DOC "Sphinx Documentation Builder (sphinx-doc.org)"
  )

mark_as_advanced(SPHINX_EXECUTABLE
                 SPHINX_MAN
                 SPHINX_HTML
                 SPHINX_SINGLEHTML
                 SPHINX_QTHELP
                 SPHINX_TEXT)

if(NOT SPHINX_MAN AND NOT SPHINX_HTML AND NOT SPHINX_SINGLEHTML AND NOT SPHINX_QTHELP AND NOT SPHINX_TEXT)
  return()
elseif(NOT SPHINX_EXECUTABLE)
  message(FATAL_ERROR "SPHINX_EXECUTABLE (sphinx-build) is not found!")
endif()

# set(copyright_line_regex "^Copyright (2000-20[0-9][0-9] Kitware.*)")
# file(STRINGS "${YCM_SOURCE_DIR}/Copyright.txt" copyright_line
#   LIMIT_COUNT 1 REGEX "${copyright_line_regex}")
# if(copyright_line MATCHES "${copyright_line_regex}")
#   set(conf_copyright "${CMAKE_MATCH_1}")
# else()
#   set(conf_copyright "Kitware, Inc.")
# endif()

set(conf_copyright "Copyright 2012-2021 Istituto Italiano di Tecnologia (IIT)")

set(conf_docs "${YCM_SOURCE_DIR}/help")
set(conf_path "${CMAKE_CURRENT_SOURCE_DIR}")
set(conf_version "${YCM_VERSION_MAJOR}.${YCM_VERSION_MINOR}.${YCM_VERSION_TWEAK}")
set(conf_release "${YCM_VERSION}")
configure_file(conf.py.in conf.py @ONLY)

set(doc_formats "")
if(SPHINX_HTML)
  list(APPEND doc_formats html)
endif()
if(SPHINX_MAN)
  list(APPEND doc_formats man)
endif()
if(SPHINX_SINGLEHTML)
  list(APPEND doc_formats singlehtml)
endif()
if(SPHINX_TEXT)
  list(APPEND doc_formats text)
endif()
if(SPHINX_QTHELP)
  find_program(QCOLLECTIONGENERATOR_EXECUTABLE
    NAMES qcollectiongenerator
    DOC "qcollectiongenerator tool"
    )
  mark_as_advanced(QCOLLECTIONGENERATOR_EXECUTABLE)
  if (NOT QCOLLECTIONGENERATOR_EXECUTABLE)
    message(FATAL_ERROR "QCOLLECTIONGENERATOR_EXECUTABLE (qcollectiongenerator) not found!")
  endif()
  list(APPEND doc_formats qthelp)

  set(qthelp_extra_commands
    # Workaround for assistant prior to
    # https://codereview.qt-project.org/#change,82250 in Qt 4.
    COMMAND ${CMAKE_COMMAND} "-DCSS_DIR=${CMAKE_CURRENT_BINARY_DIR}/qthelp/_static"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/apply_qthelp_css_workaround.cmake"
    # Workaround sphinx configurability:
    # https://bitbucket.org/birkenfeld/sphinx/issue/1448/make-qthelp-more-configurable
    COMMAND ${CMAKE_COMMAND} "-DQTHELP_DIR=${CMAKE_CURRENT_BINARY_DIR}/qthelp/"
      "-DYCM_VERSION=${YCM_VERSION_MAJOR}${YCM_VERSION_MINOR}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/fixup_qthelp_names.cmake"
    COMMAND qcollectiongenerator "${CMAKE_CURRENT_BINARY_DIR}/qthelp/YCM.qhcp"
  )
endif()


set(doc_format_outputs "")
set(doc_format_last "")
foreach(format ${doc_formats})
  set(doc_format_output "doc_format_${format}")
  set(doc_format_log "build-${format}.log")
  add_custom_command(
    OUTPUT ${doc_format_output}
    COMMAND ${SPHINX_EXECUTABLE}
            -c "${CMAKE_CURRENT_BINARY_DIR}"
            -d "${CMAKE_CURRENT_BINARY_DIR}/doctrees"
            -b ${format}
            "${YCM_SOURCE_DIR}/help"
            "${CMAKE_CURRENT_BINARY_DIR}/${format}"
            > ${doc_format_log} # log stdout, pass stderr
    ${${format}_extra_commands}
    DEPENDS ${doc_format_last}
    COMMENT "sphinx-build ${format}: see ${CMAKE_CURRENT_BINARY_DIR}/docs/${doc_format_log}"
    VERBATIM
    )
  set_property(SOURCE ${doc_format_output} PROPERTY SYMBOLIC 1)
  list(APPEND doc_format_outputs ${doc_format_output})
  set(doc_format_last ${doc_format_output})
endforeach()

add_custom_target(documentation ALL DEPENDS ${doc_format_outputs})

if(SPHINX_MAN)
  file(GLOB man_rst RELATIVE "${YCM_SOURCE_DIR}/help/manual"
    "${YCM_SOURCE_DIR}/help/manual/*.[1-9].rst")
  foreach(m ${man_rst})
    if("x${m}" MATCHES "^x(.+)\\.([1-9])\\.rst$")
      set(name "${CMAKE_MATCH_1}")
      set(sec "${CMAKE_MATCH_2}")
      install(FILES "${CMAKE_CURRENT_BINARY_DIR}/man/${name}.${sec}"
              DESTINATION "${YCM_MAN_DIR}/man${sec}")
    endif()
  endforeach()
endif()

if(SPHINX_HTML)
  install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/html"
          DESTINATION "${YCM_DOC_DIR}"
          PATTERN .buildinfo EXCLUDE
          PATTERN objects.inv EXCLUDE
          )
endif()

if(SPHINX_SINGLEHTML)
  install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/singlehtml"
          DESTINATION "${YCM_DOC_DIR}"
          PATTERN .buildinfo EXCLUDE
          PATTERN objects.inv EXCLUDE
          )
endif()

if(SPHINX_QTHELP)
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/qthelp/YCM-${YCM_VERSION_MAJOR}${YCM_VERSION_MINOR}.qch"
          DESTINATION "${YCM_DOC_DIR}"
          )
endif()
