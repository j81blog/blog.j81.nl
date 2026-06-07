---
title: "CtxVdContinuousShutdown Script"
date: 2016-01-14T19:28:42Z
categories:
  - "Citrix"
  - "PowerShell"
  - "Provisioning Services"
  - "Uncategorized"
  - "XenDesktop"
aliases:
  - "/2016/01/14/ctxvdcontinuousshutdown/"
  - "/2016/01/14/ctxvdcontinuousshutdown/feed/"
  - "/2016/01/14/ctxvdcontinuousshutdown/feed/index.html"
---

For a customer we needed a solution to recycle "old" PVS Virtual Desktops. And because Citrix XenDesktop doesn't use the oldest desktops first (without using power options), we had to come up with a solution. And so my Shutdown Script was born. The script basically checks which Virtual Machines are the oldest, puts them in maintenance mode so no user can use it anymore. After this is done the vm's are given a shutdown command. When their down , maintenance mode will be turned off. You can get it <a href="https://github.com/j81blog/CtxVdContinuousShutdown" target="_blank">here</a>.
