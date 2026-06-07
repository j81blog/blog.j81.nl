---
title: "Changing Microsoft ADCS from sha1 to sha256"
date: 2014-11-05T13:34:14Z
categories:
  - "Active Directory"
  - "ADCS"
  - "Microsoft"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2014/11/05/changing-microsoft-adcs-from-sha1-to-sha256/"
  - "/2014/11/05/changing-microsoft-adcs-from-sha1-to-sha256/feed/"
  - "/2014/11/05/changing-microsoft-adcs-from-sha1-to-sha256/feed/index.html"
---

When ADCS uses sha1 for their certificates, you might want to change it to sha254. ***NOTE: Make sure all your devices support sha256*** sha1 [<img src="//10.250.1.231/wp-content/uploads/2014/11/2014-11-05-13_59_49-sha1.png" class="alignnone size-medium wp-image-228" width="300" height="104" alt="2014-11-05 13_59_49-sha1" />](/wp-content/uploads/2014/11/2014-11-05-13_59_49-sha1-1-1.png) sha256 [<img src="//10.250.1.231/wp-content/uploads/2014/11/2014-11-05-13_59_12-sha256.png" class="alignnone size-medium wp-image-229" width="300" height="108" alt="2014-11-05 13_59_12-sha256" />](/wp-content/uploads/2014/11/2014-11-05-13_59_12-sha256-1-1.png) To achieve this enter the following commands in an elivated DOS-box:

``` batch
certutil -setreg cacspCNGHashAlgorithm SHA256
net stop certsvc
net start certsvc
```

[<img src="//10.250.1.231/wp-content/uploads/2014/11/2014-11-05-13_58_38-DOS_BOX.png" class="alignnone size-medium wp-image-230" width="300" height="151" alt="2014-11-05 13_58_38-DOS_BOX" />](/wp-content/uploads/2014/11/2014-11-05-13_58_38-DOS_BOX-1-1.png)
