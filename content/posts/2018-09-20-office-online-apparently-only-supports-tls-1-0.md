---
title: "Office Online apparently only supports TLS 1.0"
date: 2018-09-20T19:57:00Z
featureimage: "/wp-content/uploads/2018/09/OOWordOnlineError.png"
categories:
  - "ADC"
  - "Citrix"
  - "Files"
  - "Microsoft"
tags:
  - "Citrix"
  - "Citrix ADC"
  - "Citrix Files"
  - "Microsoft"
  - "NetScaler"
  - "Office Online"
  - "ShareFile"
aliases:
  - "/2018/09/20/office-online-apparently-only-supports-tls-1-0/"
---

Recently I had to configure a new <s>NetScaler</s> Citrix ADC for a new <s>ShareFile</s> Citrix Files deployment. Two Storage Zone Controllers load balanced via a Citrix ADC with a Content switch. Nothing out of the ordinary. It was when I activated the Office Online functionality on the Storage Zone Controller configuration page the error messages appeared. Each time as we tried to open an office document we got an error "Sorry, there was a problem and we can't open this document. If this happens again, try opening the document in Microsoft Word." for Word documents and "We couldn't find the file you wanted. It's possible the file was renamed, moved or deleted." for Excel documents. <img src="/wp-content/uploads/2018/09/OOExcelOnlineError.png" class="aligncenter size-medium wp-image-831" width="300" height="120" /> <img src="/wp-content/uploads/2018/09/OOWordOnlineError.png" class="aligncenter size-medium wp-image-832" width="300" height="130" /> I followed all the necessary checks as described in a Citrix Files <a href="https://docs.citrix.com/en-us/storagezones-controller/5-0/install/configure-storagezones-controller-for-web-app-previews-thumbnails.html" target="_blank" rel="noopener">Article</a>. But everything turned out okay, it worked as expected. What could it be? As it turned out to be the NetScaler SSL configuration was configured to high!? I always want that <a href="https://www.citrix.com/blogs/2018/05/16/scoring-an-a-at-ssllabs-com-with-citrix-netscaler-q2-2018-update/" target="_blank" rel="noopener">A+</a> on <a href="https://www.ssllabs.com/" target="_blank" rel="noopener">SSL Labs,</a> the same with this setup. It was when I reverted the Content Switch to it's default SSL parameters (TLS1.0 and the default Cipher suite) that Office Online started functioning. It could not retrieve the documents from the Storage Zone Controllers and thus it gave me this error messages. Luckily I had a separate Content Switch for internal and external traffic. I only had to lower the SSL settings on the internal Content Switch, this is the Content Switch the Office Online server was communicating with. So I hope Microsoft will add support for TLS 1.2 in Office Online (and give it some updates)
