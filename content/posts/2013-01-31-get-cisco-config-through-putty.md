---
title: "get Cisco config through putty"
date: 2013-01-31T07:54:13Z
categories:
  - "Cisco"
  - "Uncategorized"
aliases:
  - "/2013/01/31/get-cisco-config-through-putty/"
---

enable session\> logging in putty using connection properties, then term len 0 sh run In this way all the file is placed without need to press for next page  then you stop logging and you have your file. To have again pages type: term len 25 Putty saves an header with date and time at the beginning after that you have clean text file.
