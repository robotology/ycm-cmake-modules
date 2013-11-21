# This module is intentionally kept as small as possible in order to
# avoid the spreading of different modules.
#
# The real bootstrap is performed by the ycm_bootstrap macro from the
# YCMEPHelper module that is downloaded from the YCM package.


if(DEFINED __YCMBOOTSTRAP_INCLUDED)
  return()
endif()
set(__YCMBOOTSTRAP_INCLUDED TRUE)


set(YCM_BOOTSTRAP_BASE_ADDRESS "https://raw.github.com/robotology/ycm/HEAD/" CACHE STRING "Base address of YCM repository")
mark_as_advanced(YCM_BOOTSTRAP_BASE_ADDRESS)

include(IncludeUrl)
include_url(${YCM_BOOTSTRAP_BASE_ADDRESS}/modules/YCMEPHelper.cmake)
ycm_bootstrap()
