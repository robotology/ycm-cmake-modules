
file(READ "${QTHELP_DIR}/YCM.qhcp" QHCP_CONTENT)

string(REPLACE
  "<homePage>qthelp://org.sphinx.ycm" "<homePage>qthelp://eu.robotology.ycm"
  QHCP_CONTENT "${QHCP_CONTENT}"
)
string(REPLACE
  "<startPage>qthelp://org.sphinx.ycm" "<startPage>qthelp://eu.robotology.ycm"
  QHCP_CONTENT "${QHCP_CONTENT}"
)

string(REPLACE
  "<output>YCM.qch" "<output>YCM-${YCM_VERSION}.qch"
  QHCP_CONTENT "${QHCP_CONTENT}"
)
string(REPLACE
  "<file>YCM.qch" "<file>YCM-${YCM_VERSION}.qch"
  QHCP_CONTENT "${QHCP_CONTENT}"
)

file(WRITE "${QTHELP_DIR}/YCM.qhcp" "${QHCP_CONTENT}")


file(READ "${QTHELP_DIR}/YCM.qhp" QHP_CONTENT)

string(REPLACE
  "<namespace>org.sphinx.ycm" "<namespace>eu.robotology.ycm"
  QHP_CONTENT "${QHP_CONTENT}"
)

file(WRITE "${QTHELP_DIR}/YCM.qhp" "${QHP_CONTENT}")
