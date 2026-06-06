---
title: "My very first GUI tool: CtxToolbox!"
date: 2018-04-27T08:39:10Z
lastmod: 2018-04-28T09:01:58Z
featureimage: "/wp-content/uploads/2018/04/CtxToolbox_Drain.png"
categories:
  - "Uncategorized"
aliases:
  - "/2018/04/27/my-very-first-gui-tool-ctxtoolbox/"
---

When I started with C# in my spare time I needed a goal, something to build. I have several PowerShell scripts and wanted to add a GUI and so <a href="https://blog.j81.nl/ctxtoolbox/" target="_blank" rel="noopener">CtxToolbox</a> was born! So what to implement first? I started with the basics and worked up from there, and added the Drain functionality. The idea behind this functionality was born in an 24/7 hospital environment. At that time I was building a new XenDesktop 7.x infra for this customer. And when it went to production they needed a way to gradually get machines into maintenance mode to do maintenance without troubling the users. I created a PowerShell script where you could select the machine catalogs (we had a machine catalog per hyper-visor host) and "drain" them into maintenance mode

- add all not used machines in maintenance mode and shut them down
- leave the machines with users (active and disconnected sessions) on them intact
- wait a minute or so
- recheck to repeat the process

For example an admin could start it in the evening before he went home and the next morning all the machines on that particular host or hosts where put into maintenance mode and powered off, without harassing the user. And they could perform the planned maintenance. This is one of the modes (default function) of <a href="https://blog.j81.nl/ctxtoolbox/" target="_blank" rel="noopener">CtxToolbox</a> Drain. The other modes include

- include disconnected sessions (the normal, default mode allows a disconnected user to resume the session and continue their work)
- force all to power off (more like an emergency shutdown)
  - same as before but give the user some time to logoff and save the work by warning them.

I will try to add some more functions later on but hey, I have to start somewhere right? The current version is still in an early stage. By releasing it to the public I hope I can find some people who want to test it and give some feedback. In due time I will add some more functionality and also try to fix issues and make it more stable. If you find bugs or have feedback please fill in the [feedback form](https://blog.j81.nl/ctxtoolbox-feedback/). I still have much to learn and all the input is welcome! [Download CtxToolbox](https://blog.j81.nl/ctxtoolbox/)
