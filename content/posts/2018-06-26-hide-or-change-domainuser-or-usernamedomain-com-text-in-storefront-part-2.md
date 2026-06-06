---
title: "Hide or change \"domain user or username@domain.com\" text in Storefront, part 2"
date: 2018-06-26T21:08:27Z
lastmod: 2020-05-23T21:44:55Z
featureimage: "/wp-content/uploads/2018/06/CtxClearSTFLoginText_Changed_empty.png"
categories:
  - "Citrix"
  - "PowerShell"
  - "StoreFront 3.x"
tags:
  - "Citrix"
  - "PowerShell"
  - "StoreFront"
aliases:
  - "/2018/06/26/hide-or-change-domainuser-or-usernamedomain-com-text-in-storefront-part-2/"
---

A while ago I wrote a blog about how to change the "domain\user or username@domain.com" text in Citrix StoreFront. Now I've create a small PowerShell script that can do that for you.

## The Script

The script can be found on <a href="https://github.com/j81blog/CtxClearSTFLoginText" target="_blank" rel="noopener noreferrer">Github</a>

## Changing the text

With this script you can change the default text into something else or just empty. <img src="/wp-content/uploads/2018/06/CtxClearSTFLoginText_Default.png" class="size-medium wp-image-811 aligncenter" width="300" height="108" />  <img src="/wp-content/uploads/2018/06/CtxClearSTFLoginText_Changed_empty.png" class="size-medium wp-image-809 aligncenter" width="300" height="106" />  If you run the script by default it will first create a backup if it not already exists, then it clears the text (make it empty). If you don't specify the "-Store" parameter, a choice will be presented.

``` powershell
.\CtxClearSTFLoginText.ps1 -Store "Store"
```

You can specify the parameter "-InnerText \<Custom Text\>" with your own text for example "test":

``` powershell
.\CtxClearSTFLoginText.ps1 -Store "Store" -InnerText "test" -RestartIIS
```

[<img src="/wp-content/uploads/2018/06/CtxClearSTFLoginText_Changed.png" class="aligncenter wp-image-808 size-medium" width="300" height="183" />](/wp-content/uploads/2018/06/CtxClearSTFLoginText_Changed.png) This will be the result after IIS is restarted: <img src="/wp-content/uploads/2018/06/CtxClearSTFLoginText_Changed_text.png" class="aligncenter size-medium wp-image-810" width="300" height="65" /> You can <span style="text-decoration: underline;">choose</span> to let the script restart IIS by specifying the "**-RestartIIS**" parameter. If you want to do this manually, **don't** specify this parameter.

> **NOTE: Make sure to run this on all StoreFront servers!**

As said before, the original files are back-upped before any changes are made, the backup files will get the extension ".orig". [<img src="/wp-content/uploads/2018/06/CtxClearSTFLoginText_OrigFiles.png" class="aligncenter wp-image-814 size-medium" width="300" height="104" />](/wp-content/uploads/2018/06/CtxClearSTFLoginText_OrigFiles.png)

## Restore the original files

If you want to restore the original files, execute the script with the following parameters (again the "**-RestartIIS**" is optional)

``` powershell
.\CtxClearSTFLoginText.ps1 -Restore -RestartIIS
```
