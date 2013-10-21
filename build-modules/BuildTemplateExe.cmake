# TemplateExe
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(TemplateLib QUIET)

ycm_ep_helper(TemplateExe TYPE GIT
                          STYLE GITHUB
                          REPOSITORY robotology-playground/template-exe.git
                          TAG master
                          DEPENDS TemplateLib)
