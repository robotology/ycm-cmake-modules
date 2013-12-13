# TemplatePkg
include(YCMEPHelper)

ycm_ep_helper(TemplatePkg TYPE GIT
                          STYLE GITLAB_ICUB_ORG
                          REPOSITORY walkman/template-pkg.git
                          TAG master
                          COMPONENT templates)
