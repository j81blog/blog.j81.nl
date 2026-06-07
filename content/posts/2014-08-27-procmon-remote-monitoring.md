---
title: "procmon remote monitoring"
date: 2014-08-27T19:48:42Z
lastmod: 2020-05-23T21:44:58Z
categories:
  - "Microsoft"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2014/08/27/procmon-remote-monitoring/"
  - "/2014/08/27/procmon-remote-monitoring/feed/"
  - "/2014/08/27/procmon-remote-monitoring/feed/index.html"
---

psexec \COMPUTERNAME -u domainuser -sd -i 0 "c:Procmon.exe" /accepteula /backingfile c:output.pml /nofilter /quiet Aanmelden met de gebruiker, en afmelden (kan wat langer duren door de logging) Daarna procmon stoppen (om de log file te sluiten) psexec \COMPUTERNAME -u domainuser -sd -i 0 "c:Procmon.exe" Terminate   Sysinternals tools benodigd:   psexec procmon
