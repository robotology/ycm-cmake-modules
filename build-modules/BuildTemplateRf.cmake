# TemplateRf
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP)

ycm_ep_helper(TemplateRf TYPE GIT
                         STYLE GITLAB_ICUB_ORG
                         COMPONENT templates
                         REPOSITORY walkman/template-rf.git
                         TAG master
                         DEPENDS YARP)
