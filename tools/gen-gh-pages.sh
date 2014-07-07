#!/bin/bash

#=============================================================================
# Copyright 2014 iCub Facility, Istituto Italiano di Tecnologia
#   Authors: Daniele E. Domenichelli <daniele.domenichelli@iit.it>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of YCM, substitute the full
#  License text for the above reference.)


if [ $# -gt 1 ]; then
    echo "Usage: $(basename $0) [remote (default=origin)]"
fi

if [ ! -f YCMConfig.cmake.in ]; then
    echo "You must run this script in YCM main dir"
    exit 1
fi

if [ $# -eq 1 ]; then
    remote=$1
else
    remote=origin
fi

git branch -q -f gh-pages master || exit 1
git checkout -q gh-pages || exit 1
#git rm -rf .

rm -Rf build-docs
git clone -q $(git config --get remote.$remote.url) build-docs || exit 1

cat > index.html << EOF
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="1;url=gh-pages/master/index.html">
        <script type="text/javascript">
            window.location.href = "gh-pages/master/index.html"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        If you are not redirected automatically, follow the <a href='gh-pages/master/index.html'>link to example</a>
    </body>
</html>
EOF

rm -Rf gh-pages
mkdir -p gh-pages

branches=$(git for-each-ref --format="%(refname)" refs/remotes/$remote | grep -v "HEAD\|gh-pages" | sed "s#refs/remotes/$remote/##")
tags=$(git for-each-ref --format="%(refname)" refs/tags/ | sed "s#refs/tags/##")

for ref in $branches $tags; do
    echo Generating documentation for ref $ref
    (cd build-docs && git checkout -q $ref)
    mkdir build-docs/build
    (cd build-docs/build && cmake .. -DSPHINX_HTML:BOOL=TRUE && make documentation) >/dev/null 2>&1

    if [ -d build-docs/build/docs/html/ ]; then
        cp -R build-docs/build/docs/html/ gh-pages/$ref

        mv gh-pages/$ref/_sources/ gh-pages/$ref/sources
        mv gh-pages/$ref/_static/ gh-pages/$ref/static

        (cd gh-pages/$ref/ && grep -Rl _sources | xargs sed -i 's/_sources/sources/g')
        (cd gh-pages/$ref/ && grep -Rl _static | xargs sed -i 's/_static/static/g')
        echo "    done"
    else
        echo "    no documentation produced"
    fi
    rm -Rf build-docs/build
done

rm -Rf build-docs

git add gh-pages/ index.html
git commit -q -m "Generate documentation"

git checkout -q master
