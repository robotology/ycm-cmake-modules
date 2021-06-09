# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindSQLite
----------

Try to find the SQLite library.
Once done this will define the following variables::

 SQLite_FOUND         - System has SQLite
 SQLite_INCLUDE_DIRS  - SQLite include directory
 SQLite_LIBRARIES     - SQLite libraries
 SQLite_DEFINITIONS   - Additional compiler flags for SQLite
 SQLite_VERSION       - SQLite version
 SQLite_MAJOR_VERSION - SQLite major version
 SQLite_MINOR_VERSION - SQLite minor version
 SQLite_PATCH_VERSION - SQLite patch version
 SQLite_TWEAK_VERSION - SQLite tweak version
#]=======================================================================]


include(StandardFindModule)
standard_find_module(SQLite sqlite3)

# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(SQLite PROPERTIES DESCRIPTION "Self-contained, serverless, zero-configuration, transactional SQL database engine"
                                             URL "http://sqlite.org/")
endif()
