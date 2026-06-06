---
title: "AD Defragmentatie (Server 2012)"
date: 2013-05-14T10:16:42Z
categories:
  - "Active Directory"
  - "Microsoft"
  - "Server 2012"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2013/05/14/ad-defragmentatie-server-2012/"
---

Stop de ADDS Service

``` text
ntdsutil
activate instance ntds
files
compact to c:

copy "c:ntds.dit" "c:WindowsNTDSntds.dit"

del c:WindowsNTDS*.log
```

Start de ADDS Service  
