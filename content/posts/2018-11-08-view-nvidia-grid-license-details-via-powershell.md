---
title: "View NVIDIA GRID license details via PowerShell"
date: 2018-11-08T10:08:30Z
featureimage: "/wp-content/uploads/2018/11/NVIDIA-GRID.png"
categories:
  - "NVIDIA"
  - "PowerShell"
tags:
  - "GRID"
  - "License"
  - "NVIDIA"
  - "PowerShell"
aliases:
  - "/2018/11/08/view-nvidia-grid-license-details-via-powershell/"
  - "/2018/11/08/view-nvidia-grid-license-details-via-powershell/feed/"
  - "/2018/11/08/view-nvidia-grid-license-details-via-powershell/feed/index.html"
---

I recently needed to get some NVIDIA GRID license details in PowerShell for a customers monitoring solution. Unfortunately there was no PowerShell script available and also there is no available api to get these details. But I still needed the data in PowerShell, so I created a script that will just do that. It will retrieve the website with details, clean it up and present you with an object with data. Just run the script on you license server (or from another server, but remember to open the firewall port first) and you will get the details. <img src="/wp-content/uploads/2018/11/2018-11-02-10_11_49-Window.png" class="aligncenter size-medium wp-image-840" width="300" height="267" /> You can find the script <a href="https://github.com/j81blog/Get-NvidiaLicencedFeatureDetails" target="_blank" rel="noopener">here</a>:

``` default
```

Thank you <a href="https://twitter.com/RBRConecto" target="_blank" rel="noopener">Rasmus Raun-Nielsen (@RBRConecto)</a> for testing and providing feedback! NOTE: I can not guarantee it will work with all versions, I had only the opportunity to test it with the latest 2 versions.
