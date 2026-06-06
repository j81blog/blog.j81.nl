---
title: "Making a remote PowerShell connection"
date: 2018-04-26T15:16:44Z
lastmod: 2018-04-26T18:12:09Z
featureimage: "/wp-content/uploads/2018/04/05_PoSH_RemoteConnection.png"
categories:
  - "PowerShell"
  - "Uncategorized"
tags:
  - "Microsoft"
  - "PowerShell"
  - "Remote"
aliases:
  - "/2018/04/26/making-a-remote-powershell-connection/"
---

In this article I will make a short description how to make a remote PowerShell connection. I needed this for a job once, tried to make a remote PowerShell connection from a Non Domain Joined machine to a Domain Joined server. I needed to re-configure the server first before making a connection. With the following code you can try and test the connection:

``` powershell
$computer = "controller01.domain.local"
$credential = get-credential
Invoke-Command -ScriptBlock {get-host} -ComputerName $computer -Credential $credential
```

At the popup enter the credentials. <img src="/wp-content/uploads/2018/04/02_PoSH_RemoteConnection-300x243.png" class="alignnone wp-image-768" width="170" height="137" /> If you are lucky, a successful connection can be made, but in my case this wasn't so. I got a nice error. <img src="/wp-content/uploads/2018/04/06_PoSH_RemoteConnection-300x80.png" class="alignnone size-medium wp-image-773" width="300" height="80" /> This meant that I needed to make a secure connection (client machine was not Domain Joined). You can create a secure remote connection by adding the -UseSSL option

``` powershell
Invoke-Command -ScriptBlock {get-host} -ComputerName $computer -Credential $credential -UseSSL
```

But that alone is not enough, you also need to configure the server you are connecting to. You can configure the server to listen to secure connection by running the following command.

``` batch
winrm quickconfig -transport:https
```

Before a secure connection can be setup, you need to have a certificate (in the personal computer store) that matches the fqdn of your server. If you don't have a (correct) certificate you can get an error. <img src="/wp-content/uploads/2018/04/03_PoSH_RemoteConnection-300x152.png" class="alignnone size-medium wp-image-769" width="300" height="152" /> If you have the certificate in place, run the following command again.

``` batch
winrm quickconfig -transport:https
```

<img src="/wp-content/uploads/2018/04/04_PoSH_RemoteConnection-300x152.png" class="alignnone size-medium wp-image-770" width="300" height="152" /> ***Note: additional configuration regarding security may be required! These are just the default configuration.*** Depending on you certificate used you may have to configure the "-SkipRevocationCheck" and "-SkipCACheck" to make a successful connection.

``` powershell
$computer = "controller01.domain.local"
$credential = get-credential
$sessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck
Invoke-Command -ScriptBlock {get-host} -ComputerName $computer -Credential $credential -SessionOption $sessionOption -UseSSL
```

And I had a successful connection. <img src="/wp-content/uploads/2018/04/05_PoSH_RemoteConnection-300x89.png" class="alignnone size-medium wp-image-771" width="300" height="89" /> I hope with sharing this knowledge I could help you to.
