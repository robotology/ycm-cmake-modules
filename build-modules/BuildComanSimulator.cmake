# ComanSimulator

include(YCMEPHelper)
include(FindOrBuildPackage)

find_package(LibXml2 REQUIRED)

ycm_ep_helper(ComanSimulator TYPE GIT
                             STYLE GITHUB
                             REPOSITORY HDallali/ComanSimulator.git
                             TAG master)
