---
title: "Generate an Let's Encrypt certificate what can be used on the NetScaler"
date: 2016-07-03T18:32:28Z
lastmod: 2017-04-08T07:24:17Z
categories:
  - "Netscaler"
  - "PowerShell"
  - "Uncategorized"
tags:
  - "Certificate"
  - "Let's Encrypt"
  - "NetScaler"
  - "PowerShell"
aliases:
  - "/2016/07/03/generate-an-lets-encrypt-certificate-what-can-be-used-on-the-netscaler/"
---

Edit 07-04-2017: [Check out my new and updated version!](https://blog.j81.nl/2017/04/06/lets-encrypt-certificates-on-a-netscaler/) I'm trying to create an (PowerShell) script to automate the Let's Encrypt certificate creation. Specifically for the Citrix NetScaler. Currently still Work In Progress... It's not yet finished. The prerequisite is that you have a configured NetScaler (http) Content Switch vServer. The script will present you with the required configuration rules (it will also be copied to your clipboard so you only have to copy it in the cli of the NetScaler) For the meantime you can find it on GitHub: <a href="https://github.com/j81blog/GenCertForNS" target="_blank">GenCertForNS on GitHub</a> More soon (I hope)...
