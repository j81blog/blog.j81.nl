---
title: "Provisioning Target Device Unattended Deployment"
date: 2016-03-05T18:57:44Z
lastmod: 2020-05-23T21:44:57Z
categories:
  - "Citrix"
  - "ONE Automation"
  - "Provisioning Services"
  - "RES"
  - "Uncategorized"
tags:
  - "Citrix PVS"
  - "RES ONE Automation"
  - "SCCM"
  - "Target Device"
  - "Unattended"
aliases:
  - "/2016/03/05/provisioning-target-device-unattended-deployment/"
  - "/2016/03/05/provisioning-target-device-unattended-deployment/feed/"
  - "/2016/03/05/provisioning-target-device-unattended-deployment/feed/index.html"
---

When deployoing the Citrix PVS Target Device software with for example SCCM or RES ONE Automation, this fails. As it turns out "CFsDep2.sys" is missing from the System32\Drivers directory. This is because during the (unattended) installation of the Target Device software the installation of "CFsDep2" fails. When you install the software by hand, everything is works as it should. This can be solved to run the following command after the installation of the Target Device Software.

``` batch
rundll32.exe setupapi,InstallHinfSection DefaultInstall 128 c:\Program Files\Citrix\Provisioning Services\drivers\cfsdep2.inf
```

This could be a installation script for SCCM:

``` batch
@echo off
START /WAIT PVS_Device.exe /S /v/qn" ALLUSERS=TRUE REBOOT=SUPPRESS"
set ERRCODE=%ERRORLEVEL%
Rundll32.exe setupapi,InstallHinfSection DefaultInstall 128 c:\Program Files\Citrix\Provisioning Services\drivers\cfsdep2.inf
exit /B %ERRCODE%
```

 
