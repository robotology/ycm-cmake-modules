#!/bin/bash

# SPDX-FileCopyrightText: 2012-2021 Istituto Italiano di Tecnologia (IIT)
# SPDX-License-Identifier: BSD-3-Clause


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

git checkout -q master || exit 1
git branch -q -f gh-pages master || exit 1
git checkout -q gh-pages || exit 1
#git rm -rf .

rm -Rf build-docs
git clone -q $(git config --get remote.${remote}.url) build-docs || exit 1

cat > index.html << EOF
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="1;url=gh-pages/latest/index.html">
        <script type="text/javascript">
            window.location.href = "gh-pages/latest/index.html"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        If you are not redirected automatically, follow the <a href='gh-pages/latest/index.html'>link to the documentation</a>
    </body>
</html>
EOF

rm -Rf gh-pages
mkdir -p gh-pages

branches=$(git for-each-ref --format="%(refname)" refs/remotes/${remote} | grep -v "HEAD\|gh-pages\|travis\|appveyor\|ycm-\|/pr/\|fix/" | sed "s#refs/remotes/${remote}/##")
all_tags=$(git for-each-ref --format="%(refname)" refs/tags/ | sed "s#refs/tags/##" | sort -V)

# Keep only the last tag for each series
for tag in ${all_tags}; do
    vmaj=$(echo ${tag} | sed 's/v//' | cut -d'.' -f1)
    vmin=$(echo ${tag} | sed 's/v//' | cut -d'.' -f2)
    if [ "${cur_vmaj}.${cur_vmin}" != "${vmaj}.${vmin}" ]; then
        if [ -n "${cur_tag}" ]; then
            tags="${tags}${cur_tag}"$'\n'
        fi
    fi
    cur_vmaj=${vmaj}
    cur_vmin=${vmin}
    cur_tag=${tag}
done
tags="${tags}${cur_tag}"


for ref in ${branches} ${tags}; do
    if [[ ${ref} =~ ^v[0-9]+\.[0-9]+ ]]; then
        dir=$(echo ${ref} | sed 's/^\(v[0-9]\+\.[0-9]\+\).*$/\1/')
        all_tags_versions="${all_tags_versions}    '${dir}': '$(echo ${dir} | sed 's/v//')',"$'\n'
    else
        dir="git-${ref}"
        all_versions="${all_versions}    '${dir}': '${dir}',"$'\n'
    fi

    echo "Generating documentation for ref ${ref} in dir ${dir}"
    (cd build-docs && git checkout -q ${ref})
    mkdir build-docs/build
    (cd build-docs/build && cmake .. -DSPHINX_HTML:BOOL=TRUE && make documentation) >/dev/null 2>&1

    if [ -d build-docs/build/docs/html/ ]; then
        cp -R build-docs/build/docs/html/ gh-pages/${dir}

        mv gh-pages/${dir}/_sources/ gh-pages/${dir}/sources
        mv gh-pages/${dir}/_static/ gh-pages/${dir}/static
        mv gh-pages/${dir}/_images/ gh-pages/${dir}/images

        (cd gh-pages/${dir}/ && grep -Rl _sources | xargs sed -i 's/_sources/sources/g')
        (cd gh-pages/${dir}/ && grep -Rl _static | xargs sed -i 's/_static/static/g')
        (cd gh-pages/${dir}/ && grep -Rl _images | xargs sed -i 's/_images/images/g')

        ln -sfn ${dir} gh-pages/latest
        echo "    done"
    else
        echo "    WARNING: no documentation produced"
    fi
    rm -Rf build-docs/build
    echo "-------------------------------"
done

all_tags_versions="$(echo "${all_tags_versions}" | sort -Vr)"
all_versions="${all_versions}    'latest': 'latest release',"$'\n'"${all_tags_versions}"

rm -Rf build-docs

# Add version_switch script
find gh-pages -mindepth 2 -maxdepth 2 -name "*.html" -print0 | \
    xargs -0 -n1 sed -i 's|</head>|  <script type="text/javascript" src="../version_switch.js"></script>\n  </head>|g'
find gh-pages -mindepth 3 -maxdepth 3 -name "*.html" -print0 | \
    xargs -0 -n1 sed -i 's|</head>|  <script type="text/javascript" src="../../version_switch.js"></script>\n  </head>|g'
find gh-pages -mindepth 2 -maxdepth 3 -name "*.html" -print0 | \
    xargs -0 -n1 sed -i 's|<a href="\(.\+\)">\(.\+\) Documentation</a>|<span class="version_switch">\2</span>\n    <a href="\1">Documentation</a>|g'

cat > gh-pages/version_switch.js << EOF
(function() {
  'use strict';

  var url_re = /robotology\.github\.io\/ycm\/gh-pages\/(git-master|git-devel|latest|(v\d\.\d+))\//;
  var all_versions = {
${all_versions}
  };

  function build_select(current_version, current_release) {
    var buf = ['<select>'];

    \$.each(all_versions, function(version, title) {
      buf.push('<option value="' + version + '"');
      if (version == current_version) {
        buf.push(' selected="selected">');
        if (version[0] == 'v') {
          buf.push(current_release);
        } else {
          buf.push(title + ' (' + current_release + ')');
        }
      } else {
        buf.push('>' + title);
      }
      buf.push('</option>');
    });

    buf.push('</select>');
    return buf.join('');
  }

  function patch_url(url, new_version) {
    return url.replace(url_re, 'robotology.github.io/ycm/gh-pages/' + new_version + '/');
  }

  function on_switch() {
    var selected = \$(this).children('option:selected').attr('value');

    var url = window.location.href,
        new_url = patch_url(url, selected);

    if (new_url != url) {
      // check beforehand if url exists, else redirect to version's start page
      \$.ajax({
        url: new_url,
        success: function() {
           window.location.href = new_url;
        },
        error: function() {
           window.location.href = 'http://robotology.github.io/ycm/gh-pages/' + selected;
        }
      });
    }
  }

  \$(document).ready(function() {
    var match = url_re.exec(window.location.href);
    if (match) {
      var release = DOCUMENTATION_OPTIONS.VERSION;
      var version = match[1];
      var select = build_select(version, release);
      \$('.version_switch').html(select);
      \$('.version_switch select').bind('change', on_switch);
    }
  });
})();
EOF

git add gh-pages/ index.html
git commit -q -m "Generate documentation"

git checkout -q master || exit 1


echo
echo "Finished. You can now push with"
echo
echo "     git push --force ${remote} gh-pages"
echo
