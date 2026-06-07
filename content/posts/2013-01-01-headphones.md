---
title: "Headphones"
date: 2013-01-01T15:33:52Z
categories:
  - "QNAP"
  - "Uncategorized"
aliases:
  - "/2013/01/01/headphones/"
  - "/2013/01/01/headphones/feed/"
  - "/2013/01/01/headphones/feed/index.html"
---

QNAP - Headphones Updating:

    /etc/init.d/Headphones.sh stop
    cd /share/MD0_DATA/.qpkg/Headphones/
    mv headphones/__init__.py headphones/__init__.py.bak
    git remote set-url origin git://github.com/rembo10/headphones.git
    git pull
    git checkout master
    /etc/init.d/Headphones.sh start
    rm -rf headphones/__init__.py.bak
