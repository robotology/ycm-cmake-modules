FROM debian:buster-slim

LABEL repository="http://github.com/robotology/ycm"
LABEL homepage="http://github.com/robotology/ycm"
LABEL "com.github.actions.name"="Generate GH Pages"
LABEL "com.github.actions.description"="Automatically generate GH Pages for YCM."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="orange"

RUN apt-get update -qq; \
    apt-get install -y -qq bash curl jq cmake python3-sphinx; \
    apt-get clean

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
