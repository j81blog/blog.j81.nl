---
title: "Apply patches and updates in Support Mode"
date: 2013-05-31T13:37:15Z
categories:
  - "HP"
  - "P4000"
  - "Uncategorized"
aliases:
  - "/2013/05/31/apply-patches-and-updates-in-support-mode/"
---

- Shutdown the CMC
- Open Users\[user\].storage_systempreferences.txt
- At the top of the file, add the following:

``` text
CmcSystemPreference.supportMode=true
CmcUpgradePreference.useOldUpgrades=true
CmcUpgradePreference.userUpgrade=true
```

- Start CMC, under Configuration Summary there will now be a “Support Upgrades” tab.
- Browse to the patch
- Select the node you want to update
- Apply update

 
