---
group: "NetScaler"
title: "HowTo - NetScaler - Update Certificate"
date: 2023-10-18T13:27:47Z
lastmod: 2024-02-10T21:03:45Z
categories:
  - "ADC"
  - "Citrix"
  - "Netscaler"
tags:
  - "ADC"
  - "Certificate"
  - "Citrix"
  - "Citrix ADC"
  - "HowTo"
  - "NetScaler"
aliases:
  - "/howto-netscaler-update-certificate/"
---
group: "NetScaler"

In this how-to article I will explain the procedure how to update a certificate on a Citrix NetScaler. If you wait until a certificate is expired wil cause a lot of issues for your users or visitors. By being on time with the renewal will save you a lot of trouble.

This article assumes you already renewed the certificate and have a pfx (without the root and intermediate) with matching password available.

You can also follow [this](https://blog.j81.nl/howto-export-certificate-pfx/) article to export a certificate with private key to a pfx file.

If you want to install a certificate on the NetScaler you can follow [this](https://blog.j81.nl/howto-install-certificate-on-a-netscaler/) guide.

Updating an existing certificate is preferred over adding a new certificate. When adding an updated certificate as new, you will have to update all the bindings for all VIP's. You don't have to do this when updating an existing certificate. 

First login to the NetScaler with enough permissions to update/replace the certificate.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert01.png" class="aligncenter wp-image-1211 size-large" width="1024" height="436" alt="Log in the NetScaler" />

Next browse to "**Traffic Management**" / "**SSL**" / "**Certificates**" / "**All Certificates**"

Select the certificate you want to update by clicking on the 3 dots (...) in front of the certificate.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert02.png" class="aligncenter size-full wp-image-1246" width="557" height="395" alt="Select certificate to update" />

In the context menu that follows, select "**Update**".

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert03.png" class="aligncenter size-full wp-image-1247" width="547" height="442" alt="Select update" />

Next, check the checkbox ti "**Update the certificate and key**" this will enable you to change the certificate and key file.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert04.png" class="aligncenter size-full wp-image-1248" width="462" height="540" alt="Enable update" />

To select the certificate, click on the down "**˅"** symbol and select "**Local**".

An open dialog box will appear and you can select the new pfx-file.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert05.png" class="aligncenter size-full wp-image-1249" width="521" height="672" alt="Select new local pfx" />

Click "**Yes**" on the "**Confirm**" dialog prompt that appears.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert06.png" class="aligncenter size-full wp-image-1250" width="611" height="215" alt="Select OK to update" />

Make sure you also change the "**Key File Name**" by selecting the new pfx file.

And don't forget to change/update the password for the new pfx file.

Click "**OK**" if you made all the necessary changes.

**NOTE:** It's best practice to use unique and long (generated) passwords for your pfx-files.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert07.png" class="aligncenter size-full wp-image-1251" width="537" height="676" alt="Update all fields and password" />

If all goes well, the certificate will be updated without any error's.

It can be that you will be shown a message that the link is or will be broken. In the next steps we will validate and update the link if required.

Click the "**Link**" button to update/validate the link.

<img src="/wp-content/uploads/2023/10/HowToNSUpdateCert08.png" class="aligncenter size-full wp-image-1252" width="1331" height="401" alt="Link the new certificate" />

You will see all intermediate and root certificates if they are installed.

It might be that the new certificate requires an updated intermediate or root certificate. You can follow [this](https://blog.j81.nl/howto-install-certificate-on-a-netscaler/) guide to add the new certificate(s).

Click the "**Link Certificates**" button to complete the links.

<img src="/wp-content/uploads/2023/10/HowToCertInstall08.png" class="aligncenter size-full wp-image-1235" width="1129" height="343" alt="Create link between certificates" />

When all goes well, you will see a full (green) line with certificate symbols under the intermediate and root certificate(s).

<img src="/wp-content/uploads/2023/10/HowToCertInstall09.png" class="aligncenter size-full wp-image-1236" width="1129" height="343" alt="View linked certificates" />

And that's it, the certificate is updated.

The next time the user initiates a new SSL session the new certificate will be used.

**NOTE:** If you have a pre-existing session to the webpage and you refresh (F5) the webpage. You might be presented with the previous (old) certificate. Just open an in-private browser session and start a new session to validate the new certificate.
