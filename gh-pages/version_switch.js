(function() {
  'use strict';

  var url_re = /robotology\.github\.io\/ycm\/gh-pages\/(git-master|git-devel|latest|(v\d\.\d+))\//;
  var all_versions = {
    'git-master': 'git-master',
    'latest': 'latest release',
    'v0.13': '0.13',
    'v0.12': '0.12',
    'v0.11': '0.11',
    'v0.10': '0.10',
    'v0.9': '0.9',
    'v0.8': '0.8',
    'v0.6': '0.6',
    'v0.4': '0.4',
    'v0.2': '0.2',
    'v0.1': '0.1',
  };

  function build_select(current_version, current_release) {
    var buf = ['<select>'];

    $.each(all_versions, function(version, title) {
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
    var selected = $(this).children('option:selected').attr('value');

    var url = window.location.href,
        new_url = patch_url(url, selected);

    if (new_url != url) {
      // check beforehand if url exists, else redirect to version's start page
      $.ajax({
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

  $(document).ready(function() {
    var match = url_re.exec(window.location.href);
    if (match) {
      var release = DOCUMENTATION_OPTIONS.VERSION;
      var version = match[1];
      var select = build_select(version, release);
      $('.version_switch').html(select);
      $('.version_switch select').bind('change', on_switch);
    }
  });
})();
