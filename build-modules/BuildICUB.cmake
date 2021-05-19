# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
BuildICUB
---------

ICUB
#]=======================================================================]

include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(ICUB TYPE GIT
                   STYLE GITHUB
                   REPOSITORY robotology/icub-main.git
                   DEPENDS YARP
                   CMAKE_CACHE_ARGS -DYARP_USE_GTK2:BOOL=ON
                                    -DICUB_SHARED_LIBRARY:BOOL=ON
                                    -DICUB_USE_GLUT:BOOL=ON
                                    -DENABLE_icubmod_DFKI_hand_calibrator:BOOL=ON
                                    -DENABLE_icubmod_dragonfly2:BOOL=OFF
                                    -DENABLE_icubmod_dragonfly2raw:BOOL=OFF
                                    -DENABLE_icubmod_fakecan:BOOL=ON
                                    -DENABLE_icubmod_analogServer:BOOL=ON
                                    -DENABLE_icubmod_cartesiancontrollerclien:BOOL=ON
                                    -DENABLE_icubmod_cartesiancontrollerserver:BOOL=ON
                                    -DENABLE_icubmod_debugInterfaceClient:BOOL=ON
                                    -DENABLE_icubmod_gazecontrollerclient:BOOL=ON
                                    -DENABLE_icubmod_icubarmcalibrator:BOOL=ON
                                    -DENABLE_icubmod_icubarmcalibratorj4:BOOL=ON
                                    -DENABLE_icubmod_icubarmcalibratorj8:BOOL=ON
                                    -DENABLE_icubmod_icubhandcalibrator:BOOL=ON
                                    -DENABLE_icubmod_icubheadcalibrator:BOOL=ON
                                    -DENABLE_icubmod_icubheadcalibratorV2:BOOL=ON
                                    -DENABLE_icubmod_icublegscalibrator:BOOL=ON
                                    -DENABLE_icubmod_icubtalkingheadcalibrator:BOOL=ON
                                    -DENABLE_icubmod_icubtorsoonlycalibrator:BOOL=ON
                                    -DENABLE_icubmod_logpolarclient:BOOL=ON
                                    -DENABLE_icubmod_logpolargrabber:BOOL=ON
                                    -DENABLE_icubmod_sharedcan:BOOL=ON
                                    -DENABLE_icubmod_skinWrapper:BOOL=ON
                                    -DENABLE_icubmod_skinprototype:BOOL=ON
                                    -DENABLE_icubmod_socketcan:BOOL=ON
                                    -DENABLE_icubmod_static_grabber:BOOL=ON
                                    -DENABLE_icubmod_virtualAnalogServer:BOOL=ON
                                    -DENABLE_icubmod_xsensmtx:BOOL=ON)
