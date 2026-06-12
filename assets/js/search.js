/* Client-side search over the Hugo JSON index. Dependency-free. */
(function () {
  'use strict';

  var input = document.getElementById('search-input');
  var results = document.getElementById('search-results');
  var meta = document.getElementById('search-meta');
  if (!input || !results) return;

  var indexUrl = (document.currentScript && document.currentScript.dataset.index) || '/index.json';
  var index = null;
  var loading = null;

  function load() {
    if (!loading) {
      loading = fetch(indexUrl)
        .then(function (r) { return r.json(); })
        .then(function (data) { index = data; return data; });
    }
    return loading;
  }

  function escapeHtml(s) {
    return s.replace(/[&<>"]/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
    });
  }

  function highlight(text, terms) {
    var safe = escapeHtml(text);
    terms.forEach(function (t) {
      if (!t) return;
      safe = safe.replace(new RegExp('(' + t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi'), '<mark>$1</mark>');
    });
    return safe;
  }

  function excerpt(content, terms) {
    var lower = content.toLowerCase();
    var pos = -1;
    for (var i = 0; i < terms.length; i++) {
      pos = lower.indexOf(terms[i]);
      if (pos > -1) break;
    }
    if (pos < 0) return content.slice(0, 140);
    var start = Math.max(0, pos - 60);
    return (start > 0 ? '…' : '') + content.slice(start, start + 160) + '…';
  }

  function score(page, terms) {
    var s = 0;
    var title = page.title.toLowerCase();
    var content = page.content.toLowerCase();
    var tags = page.tags.join(' ').toLowerCase();
    terms.forEach(function (t) {
      if (title.indexOf(t) > -1) s += 30;
      if (title.indexOf(t) === 0) s += 10;
      if (tags.indexOf(t) > -1) s += 12;
      var m = content.split(t).length - 1;
      s += Math.min(m, 8);
    });
    return s;
  }

  function render(q) {
    var terms = q.toLowerCase().split(/\s+/).filter(Boolean);
    if (!terms.length) {
      results.innerHTML = '';
      meta.textContent = 'type to search ' + index.length + ' entries…';
      return;
    }
    var hits = index
      .map(function (p) { return { p: p, s: score(p, terms) }; })
      .filter(function (h) { return h.s > 0; })
      .sort(function (a, b) { return b.s - a.s; })
      .slice(0, 30);

    meta.textContent = hits.length
      ? hits.length + ' match' + (hits.length === 1 ? '' : 'es')
      : 'no matches — exit code 1';

    results.innerHTML = hits.map(function (h) {
      return '<a class="log-row" href="' + h.p.url + '">' +
        '<time class="log-date">' + h.p.date + '</time>' +
        '<span class="log-title">' + highlight(h.p.title, terms) + '</span>' +
        '<span class="log-tags"><span>' + escapeHtml(h.p.section) + '</span></span>' +
        '<span class="result-summary">' + highlight(excerpt(h.p.content, terms), terms) + '</span>' +
        '</a>';
    }).join('');
  }

  var timer;
  input.addEventListener('input', function () {
    clearTimeout(timer);
    var q = input.value;
    timer = setTimeout(function () {
      load().then(function () { render(q); });
    }, 120);
  });

  /* Support /search/?q=... deep links */
  var params = new URLSearchParams(location.search);
  var q0 = params.get('q');
  if (q0) {
    input.value = q0;
    load().then(function () { render(q0); });
  } else {
    load(); /* warm the index */
  }
})();
