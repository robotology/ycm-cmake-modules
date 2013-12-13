# TemplatePkg
include(YCMEPHelper)

ycm_ep_helper(TemplatePkg TYPE GIT
                          STYLE GITLAB_ICUB_ORG
                          COMPONENT templates
                          REPOSITORY walkman/template-lib.git
                          TAG master)
