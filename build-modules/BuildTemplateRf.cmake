# TemplateExe
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP)

ycm_ep_helper(TemplateRf TYPE GIT
                         STYLE GITLAB_ICUB_ORG
                         REPOSITORY walkman/template-rf.git
                         TAG master)
