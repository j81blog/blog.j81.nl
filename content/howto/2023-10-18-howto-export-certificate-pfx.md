---
group: "Windows"
title: "HowTo - Windows - Export certificate (pfx)"
date: 2023-10-18T09:45:25Z
lastmod: 2024-02-10T21:04:38Z
categories:
  - "ADC"
  - "Citrix"
  - "Microsoft"
  - "Netscaler"
  - "Windows"
tags:
  - "ADC"
  - "Certificate"
  - "Citrix"
  - "Citrix ADC"
  - "HowTo"
  - "Microsoft"
  - "NetScaler"
aliases:
  - "/howto-export-certificate-pfx/"
---
group: "Windows"

Certificates are an important part of a modern environment. They make communication safer by encrypting the traffic between the client and server. A safe way to move certificates between servers or store them safely is by exporting the certificate (private and public key) to an encrypted format. A commonly used format is "pfx" (Personal Information Exchange also known as PKCS#12). A pfx file can contain one or more certificates and is encrypted with a password. Without the correct password the pfx is useless. You commonly see that a pfx contains a (web) server certificate and one or more intermediate certificate(s) and a root certificate.

A Windows machine has two certificate stores

- Machine store\
  Can be accessed by opening "certlm.msc"
- User store\
  Can be accessed by opening "certmgr.msc"

For this example we are opening the machine store, there my private and public key is located. 

Click on the start menu or press windows key + r and run "certlm.msc"

<img src="/wp-content/uploads/2023/10/HowToCertExport01.png" class="aligncenter wp-image-1214 size-full" width="657" height="512" alt="Run certlm.msc" />

Next, open the folders **"Personal"** and **"Certificates".**

**NOTE**: Make sure the certificates has a matching private key! You can easily verify it by looking at the icon in front of the certificate. If a key symbol is visible at the left upper corner of the certificate a matching private key is present.

Select the certificate you want to export. 

<img src="/wp-content/uploads/2023/10/HowToCertExport02.png" class="aligncenter wp-image-1215 size-large" width="1024" height="710" alt="Export certificate" />

In the "**Welcome to the Certificate Export Wizard**" window, click "**Next**".

<img src="/wp-content/uploads/2023/10/HowToCertExport03.png" class="aligncenter wp-image-1216 size-full" width="937" height="964" alt="Certificate export introduction" />

Make sure "**Yes, export the private key**" is selected before you click **"Next".**

**NOTE:** It might be that you cannot select this option and that it is greyed out. This means that the private key cannot be exported. When the certificate was created or imported the option to export the private key must have been selected. Without that option you cannot export the certificate and continue this procedure.

<img src="/wp-content/uploads/2023/10/HowToCertExport04.png" class="aligncenter wp-image-1217 size-full" width="937" height="964" alt="Export with private key" />

By default the options "**include all certificates in the certification path if possible**" (this includes the intermediate certificates and root certificate if present) and "**enable certificate privacy**" (If enabled all certificates are encrypted if disabled only the private key is encrypted) are selected. You can leave them on if you want to move these from one Windows server to another. But if you want to use the exported pfx file on a NetScaler I like to disable these options. And additionally I select the option "**Export all extended properties**".

<img src="/wp-content/uploads/2023/10/HowToCertExport05.png" class="aligncenter wp-image-1218 size-full" width="937" height="964" alt="Select only cert without int and root" />

Make sure you select the checkmark before "**Password**" and enter a secure password before clicking on "**Next**".

<img src="/wp-content/uploads/2023/10/HowToCertExport06.png" class="aligncenter wp-image-1219 size-full" width="937" height="964" alt="Enter password" />

Enter a path and name where you want to store the pfx-file. I like to use the "Common Name" as name for the certificate and append the date (formatted as "**\_MMYYYY**") or year (formatted as "\_**YYYY**") at the end. This way I easily can see when the certificates are expired and cleanup those files. 

<img src="/wp-content/uploads/2023/10/HowToCertExport07.png" class="aligncenter wp-image-1220 size-full" width="937" height="964" alt="Specify a name" />

Click "**Finish**" on the final wizard page to finalize the export.

<img src="/wp-content/uploads/2023/10/HowToCertExport08.png" class="aligncenter wp-image-1221 size-full" width="937" height="964" alt="Certificate export overview" />

When all goes well you are presented with a "**The export was successful**" dialog box.

<img src="/wp-content/uploads/2023/10/HowToCertExport09.png" class="aligncenter wp-image-1222 size-full" width="937" height="964" alt="Certificate export finished" />

You can now safely transfer or store your certificate!

 
