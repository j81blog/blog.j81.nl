---
title: "Spontaneously changing default printer"
date: 2017-03-18T13:53:21Z
lastmod: 2020-05-23T21:44:56Z
categories:
  - "Microsoft"
  - "Uncategorized"
  - "Windows"
tags:
  - "Default Printer"
  - "Exact"
  - "Labelprinter"
  - "Labels"
  - "Microsoft"
  - "Printer"
  - "Windows 10"
  - "Zebra"
aliases:
  - "/2017/03/18/spontaneously-changing-default-printer/"
  - "/2017/03/18/spontaneously-changing-default-printer/feed/"
  - "/2017/03/18/spontaneously-changing-default-printer/feed/index.html"
---

Yesterday I was at a Customers location and they had an issue with their printers on the XenDesktop VDI environment. Some users are using Exact to print all kinds of labels, in this case a Zebra label printer. And while they were printing labels, the label printer was set automagically as default. They started noticing this because when they wanted to print other (A4) reports, the layout was wrong and some information fell of the report. They could change the default printer back to the MFP, but when they printed labels again, you'll get it right? I recently helped them move from Windows 10 LTSB 2015 (1507) to Windows 10 LTSB 2016 (1607) and they started noticing this issue after the switch to the new Windows version. So what could it be? Turned out to be a setting in Windows... After changing this, the issue was gone. You can change it in "Settings", "Devices", "Printers & Scanners" and change the setting "Let Windows manage my Default printer" to off. <img src="/wp-content/uploads/2017/03/20170318_Win10PrinterSettings.png" class="alignnone size-medium wp-image-609" width="300" height="111" /> Or you can set the following registry key:

``` default
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows]
"LegacyDefaultPrinterMode"=dword:00000001
```

Edit (03-04-2017, Additional notes from the new RES Workspace v10 version)

> **Note** With the release of Windows 10 version 1511, Microsoft made a change to the way Windows 10 handles the default printer: the printer that was last used by the user becomes the new default printer. If the Printers feature is enabled (at Composition \> Actions By Type \> Printers, on the Settings tab), RES ONE Workspace now reverts handling of the default printer to the method Windows 10 used before version 1511, using the Microsoft Windows registry value LegacyDefaultPrinterMode. This registry value impacts not only managed default printers, but also user selected default printers.

Hope is can somehow help you to.
