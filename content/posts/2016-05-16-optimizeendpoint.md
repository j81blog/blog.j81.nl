---
title: "OptimizeEndpoint"
date: 2016-05-16T13:40:44Z
categories:
  - "Citrix"
  - "Optimization"
  - "PowerShell"
  - "Provisioning Services"
  - "Uncategorized"
  - "XenApp 7.x"
  - "XenDesktop"
tags:
  - "Citrix"
  - "Optimize"
  - "OptimizeEndpoint"
  - "Windows 10"
  - "Windows 7"
  - "Windows 8"
  - "Windows 8.1"
  - "XenApp"
  - "XenDesktop"
aliases:
  - "/2016/05/16/optimizeendpoint/"
---

I've been using my "Windows optimize script" for a while now. Most issues are resolved and it's been tested thoroughly. So I thought why not give it back to the community, so here it is: <a href="https://github.com/j81blog/OptimizeEndpoint" target="_blank">OptimizeEndpoint</a>. It can be used to optimize Windows 7, 8, 8.1 and 10. (It can also be used for Windows Server versions, but this is not tested) I used the script made by <a href="http://www.ingmarverheij.com/citrix-pvs-optimize-endpoint-with-powershell/" target="_blank">Ingmar Verheij</a>, and made some changes. It contains most of the Citrix XenDesktop Best Practices. Please don't run the script without reviewing the options, it can damage you master image if you're not careful! At the top of the image there are some parameters that can be set. Read the comments. Run it on your own risk. If you have issues or questions let me know.
