---
title: "GenLeCertForNS New Update"
date: 2020-02-19T16:42:40Z
lastmod: 2020-05-23T21:44:54Z
featureimage: "/wp-content/uploads/2020/02/LetsPowershell.png"
categories:
  - "ADC"
  - "Citrix"
  - "Let's Encrypt"
  - "Netscaler"
  - "PowerShell"
  - "Uncategorized"
tags:
  - "ADC"
  - "Citrix ADC"
  - "Let's Encrypt"
  - "NetScaler"
  - "PowerShell"
aliases:
  - "/2020/02/19/genlecertforns-new-update/"
  - "/2020/02/19/genlecertforns-new-update/feed/"
  - "/2020/02/19/genlecertforns-new-update/feed/index.html"
---

A lot of new users used my script after writing  my <a href="https://www.citrix.com/blogs/2019/06/24/why-certificates-are-more-important-today-than-ever/" target="_blank" rel="noopener noreferrer">first blog article for Citrix</a>. Since then I made some improvements and continuing to add new features. Today I released the latest version of my "GenLeCertForNS" script. Within this version I solved some issues and improved the overall speed (especially with larger orders).

## Release Notes

- FIXED: "ERROR: Could not create the order."; While testing (thanks to <a href="https://twitter.com/MathysRoger" target="_blank" rel="noopener noreferrer">Roger</a>, <a href="https://twitter.com/citrixguyblog" target="_blank" rel="noopener noreferrer">Julian</a>, <a href="https://twitter.com/xenappblog" target="_blank" rel="noopener noreferrer">Erik</a> and <a href="https://twitter.com/virtualwebber" target="_blank" rel="noopener noreferrer">Andrew</a>) we saw that updating the script wasn't always the complete solution. Specifying the parameter "*-CleanPoshACMEStorage*" after updating the script helped fixing this issue completely. This will cleanup the %LOCALAPPDATA%\Posh-ACME directory.
- CHANGED: Removed the verbose logging; I didn't liked the output to screen. Therefore I added a logging function to write everything to a log file. Resulting in a cleaner output to the screen. Specifying the "-Verbose" option has no particular use anymore.
- CHANGED: Overall speed; Changed internal process of configuring the Citrix ADC thus improving the speed.
- NEW: Version check to notify you if there is a new (dev) version available:

<img src="/wp-content/uploads/2020/02/LEVersionInfo.png" class="alignnone wp-image-887" width="778" height="70" /> Sometimes I get the question, which name must I specify with the "*-NSCertNameToUpdate*" parameter? The name you need to specify is the name you entered when adding the certificate for the first time "*Certificate-Key Pair Name*", now you can reuse this name by updating this object. By updating this certificate you don't have to change the binding on each VIP. <img src="/wp-content/uploads/2020/02/LECertName.png" class="alignnone wp-image-888" width="776" height="349" />

## Get the new version

Get the new version here: [v2.6.3](https://github.com/j81blog/GenLeCertForNS/releases/tag/v2.6.3)

## Development

I'm still developing the script to add new features an improve it. If you experience issues let me know, you can also check the <a href="https://github.com/j81blog/GenLeCertForNS/tree/dev" target="_blank" rel="noopener noreferrer">dev channel</a> and verify if you still experience it. The upcoming features currently in dev (v2.7.x):

- NEW: Email functionality; The option to send a mail after the script is finished. Activated by specifying the "*-SendMail*" parameter and the following are also required: "*-SMTPTo, -SMTPFrom, SMTPServer and optionally if required -SMTPCredential*"
- IMPROVED: "*-NSCertNameToUpdate"; In previous versions you could only specify this parameter if you had an existing certificate you wanted to update. With newer version you can specify this parameter. If the certificate name doesn't yet exists it will be created.*
