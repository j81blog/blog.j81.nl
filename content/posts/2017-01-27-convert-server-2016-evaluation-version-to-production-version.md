---
title: "Convert Server 2016 Evaluation version to Production version"
date: 2017-01-27T08:55:30Z
categories:
  - "Uncategorized"
aliases:
  - "/2017/01/27/convert-server-2016-evaluation-version-to-production-version/"
---

I'ts possible to convert your Server 2016 evaluation version to a production version using one of the following commands depending on your version: Standard:

``` default
DISM /online /Set-Edition:Serverstandard /ProductKey:WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY /AcceptEula /Norestart
```

Datacenter:

``` default
DISM /online /Set-Edition:ServerDatacenter /ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG /AcceptEula /Norestart
```

Source: <a href="https://technet.microsoft.com/en-us/library/jj612867(v=ws.11).aspx" target="_blank">KMS Client Keys</a> Make sure you've installed all windows updates first before continuing.  Keep in mind that it can take a while to complete. In my case it was stuck at 10% for a long time. Just let it complete and reboot afterwards.
