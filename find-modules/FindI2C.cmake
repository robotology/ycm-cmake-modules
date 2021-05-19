# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindI2C
-------

Find the I2C device library.

Once done this will define the following variables::

  I2C_INCLUDE_DIRS    - I2C include directory
  I2C_LIBRARIES       - I2C libraries
  I2C_FOUND           - if false, you cannot build anything that requires I2C
#]=======================================================================]

include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

find_path(I2C_smbus_h_INCLUDE_DIR
          NAMES i2c/smbus.h)
mark_as_advanced(I2C_smbus_h_INCLUDE_DIR)

if(I2C_smbus_h_INCLUDE_DIR)
  find_library(I2C_i2c_LIBRARY
               NAMES i2c)
  mark_as_advanced(I2C_i2c_LIBRARY)

  set(I2C_LIBRARIES ${I2C_i2c_LIBRARY})
  set(I2C_INCLUDE_DIRS ${I2C_smbus_h_INCLUDE_DIR})
  set(I2C_DEFINITIONS I2C_HAS_SMBUS_H)
  find_package_handle_standard_args(I2C
                                    FOUND_VAR I2C_FOUND
                                    REQUIRED_VARS I2C_INCLUDE_DIRS
                                                  I2C_LIBRARIES)
else()
  find_path(I2C_i2c_dev_h_INCLUDE_DIR
            NAMES linux/i2c-dev.h)
  mark_as_advanced(I2C_i2c_dev_h_INCLUDE_DIR)
  if(EXISTS "${I2C_i2c_dev_h_INCLUDE_DIR}/linux/i2c-dev.h")
    file(READ "${I2C_i2c_dev_h_INCLUDE_DIR}/linux/i2c-dev.h" _i2c_dev_content)
    if(NOT "${_i2c_dev_content}" MATCHES "i2c_smbus_access")
      set(I2C_i2c_dev_h_INCLUDE_DIR I2C_i2c_dev_h_INCLUDE_DIR-NOTFOUND CACHE STRING "" FORCE)
    endif()

    set(I2C_LIBRARIES "")
    set(I2C_INCLUDE_DIRS ${I2C_i2c_dev_h_INCLUDE_DIR})
    set(I2C_DEFINITIONS "")
  endif()
  find_package_handle_standard_args(I2C
                                    FOUND_VAR I2C_FOUND
                                    REQUIRED_VARS I2C_INCLUDE_DIRS)
endif()


# Set package properties if FeatureSummary was included
if(COMMAND set_package_properties)
    set_package_properties(I2C PROPERTIES DESCRIPTION "Userspace I2C programming library"
                                          URL "https://www.kernel.org/pub/software/utils/i2c-tools/")
endif()

