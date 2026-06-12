/* Site behavior: theme toggle, mobile nav, code copy, reading progress. */
(function () {
  'use strict';

  /* ── Theme toggle ── */
  var toggle = document.getElementById('theme-toggle');
  if (toggle) {
    toggle.addEventListener('click', function () {
      var root = document.documentElement;
      var current = root.dataset.theme ||
        (matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark');
      var next = current === 'dark' ? 'light' : 'dark';
      root.dataset.theme = next;
      localStorage.setItem('theme', next);
    });
  }

  /* ── Mobile nav ── */
  var navToggle = document.getElementById('nav-toggle');
  var nav = document.getElementById('site-nav');
  if (navToggle && nav) {
    navToggle.addEventListener('click', function () {
      var open = nav.classList.toggle('open');
      navToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    nav.addEventListener('click', function (e) {
      if (e.target.tagName === 'A') nav.classList.remove('open');
    });
  }

  /* ── Copy buttons on code blocks ── */
  document.querySelectorAll('.prose pre').forEach(function (pre) {
    var code = pre.querySelector('code');
    if (!code) return;
    var btn = document.createElement('button');
    btn.className = 'copy-btn';
    btn.type = 'button';
    btn.textContent = 'copy';
    btn.addEventListener('click', function () {
      navigator.clipboard.writeText(code.innerText).then(function () {
        btn.textContent = '[ OK ]';
        btn.classList.add('copied');
        setTimeout(function () {
          btn.textContent = 'copy';
          btn.classList.remove('copied');
        }, 1600);
      });
    });
    /* Anchor the button on the scroll container's parent so it stays put */
    var host = pre.closest('.highlight') || pre;
    host.style.position = 'relative';
    host.appendChild(btn);
  });

  /* ── Reading progress (article pages only) ── */
  var bar = document.querySelector('.progress');
  if (bar) {
    var update = function () {
      var doc = document.documentElement;
      var max = doc.scrollHeight - innerHeight;
      doc.style.setProperty('--progress', max > 0 ? Math.min(1, scrollY / max) : 0);
    };
    addEventListener('scroll', update, { passive: true });
    update();
  }

  /* ── Back to top ── */
  var top = document.getElementById('back-to-top');
  if (top) {
    top.addEventListener('click', function (e) {
      e.preventDefault();
      scrollTo({ top: 0, behavior: 'smooth' });
    });
  }
})();
