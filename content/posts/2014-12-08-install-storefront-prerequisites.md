---
title: "Install StoreFront prerequisites"
date: 2014-12-08T12:05:23Z
categories:
  - "No Category"
  - "Uncategorized"
aliases:
  - "/2014/12/08/install-storefront-prerequisites/"
---

To install the StoreFront prerequisites, execute the following PowerShell commands on the StoreFront Server.

``` powershell
Import-Module ServerManager
Add-WindowsFeature –Name Web-Server,Web-WebServer,Web-App-Dev,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Security,Web-Basic-Auth,Web-Windows-Auth,Web-Mgmt-Tools,Web-Scripting-Tools,Web-Http-Redirect,Web-Mgmt-Compat,Web-Metabase,Web-WMI,Web-Lgcy-Scripting
```

 
