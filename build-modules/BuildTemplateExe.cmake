# TemplateExe
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(TemplatePkg QUIET)

ycm_ep_helper(TemplateExe TYPE GIT
                          STYLE GITLAB_ICUB_ORG
                          COMPONENT templates
                          REPOSITORY walkman/template-exe.git
                          TAG master
                          DEPENDS TemplatePkg)
