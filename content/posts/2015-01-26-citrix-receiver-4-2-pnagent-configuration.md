---
title: "Citrix Receiver 4.2 & PNAgent Configuration"
date: 2015-01-26T07:22:59Z
categories:
  - "No Category"
  - "Uncategorized"
aliases:
  - "/2015/01/26/citrix-receiver-4-2-pnagent-configuration/"
---

There is an undocumented regkey setting required to add PNAgent functionality using the new Citrix Receiver 4.2.

``` default
[HKEY_LOCAL_MACHINESOFTWARECitrixDazzle]
"PnaSSONEnabled"="true"
```

Once applied the Citrix Receiver 4.2 can utilise a PNAgent/config.xml configuration. [Source](http://www.lukecjdavis.com/citrix-receiver-4-2-pnagent/)
