---
title: "ESXi from USB"
date: 2013-11-11T20:37:24Z
categories:
  - "ESXi"
  - "Uncategorized"
  - "VMware"
aliases:
  - "/2013/11/11/esxi-from-usb/"
---

A USB drive can be set up to boot into any LInux distribution using UNetBootin. Fortunately, ESXi is a Linux distribution. The steps are surprisingly easy.

1.  Download ESXi from VMWare
2.  Download <a href="http://unetbootin.sourceforge.net/" target="_blank">UNetbootin from Sourceforge</a>
3.  Plug your USB drive into your computer.
4.  Double click on the downloaded exe file. UNetbootin is a stand alone executable. No installation is needed.
5.  Select the second radio button, Diskimage. Click the button with the ellipses on it, browse to and select the ESXi iso you just downloaded.
6.  Once UNetbootin is finished, remove your USB drive from your current system. Plug it into the computer you want to install ESXi onto, restart the system and you are off and running.

Everything will work just as if you were installing from any other media.
