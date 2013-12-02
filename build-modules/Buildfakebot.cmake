# fakebot
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP REQUIRED)

ycm_ep_helper(fakebot TYPE GIT
                           STYLE GITHUB
                           REPOSITORY lornat75/fakebot.git
                           TAG master
                           DEPENDS YARP)
