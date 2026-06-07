---
title: "Windows 10 LTSB 2016 (Build 1607) stuck at Other User while logging in"
date: 2017-01-27T13:57:48Z
categories:
  - "Microsoft"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2017/01/27/windows-10-ltsb-2016-build-1607-stuck-at-other-user-while-logging-in/"
  - "/2017/01/27/windows-10-ltsb-2016-build-1607-stuck-at-other-user-while-logging-in/feed/"
  - "/2017/01/27/windows-10-ltsb-2016-build-1607-stuck-at-other-user-while-logging-in/feed/index.html"
---

While testing with the latest Windows 10 LTSB 2016 version I found out in 9 of 10 logins failed, it was stuck on the message "Welcome other user"... I used the same deployment steps as with LTSB 2015 and not working, what was wrong? After reading the Citrix forum I found out that more users were experiencing this issue. After some testing I found out that my issue was caused by a disabled Service named "Device Association Service". This is one of the optimizations in the "Technical Note – Optimize Windows 10" guide from Citrix. Don't disable this service but leave it on Automatic. Since I found out I haven't seen this issue since.
