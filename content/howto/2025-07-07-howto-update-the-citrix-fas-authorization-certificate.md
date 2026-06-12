---
group: "Citrix FAS"
title: "HowTo - Update the Citrix FAS Authorization Certificate"
date: 2025-07-07T19:54:57Z
lastmod: 2025-09-18T15:56:46Z
categories:
  - "Citrix"
  - "FAS"
tags:
  - "Authorization"
  - "Certificate"
  - "Citrix"
  - "FAS"
  - "HowTo"
  - "PowerShell"
  - "SmartCard"
aliases:
  - "/howto-update-the-citrix-fas-authorization-certificate/"
---

When you are using Citrix FAS you will also have a Authorization Certificate. Without this certificate Citrix FAS would not be able to function. The same is applicable when the Authorization Certificate is expired, FAS can no longer do it's job. When the Authorization Certificate is expired users are no longer able to login. Because FAS cannot request new smartcard certificates for a user.

The best way to make sure this does not happens is to renew the certificate before the current Authorization certificate expires, 30~60 days before for example. If you have a monitoring solution, you could configure a monitor to check the expiration date. One option would be to monitor this via PowerShell.

``` text
Add-PSSnapin Citrix.Authentication.FederatedAuthenticationService.V1
Get-FasAuthorizationCertificate -Address localhost -FullCertInfo | Select-Object -ExpandProperty ExpiryDate
```

If the expitation date is near or maybe already expired you need to renew/update this Authoriation certificate to get it up and running again. For this you can follow the next steps. To get you started open the FAS Console and don't forget to "***Run as Administrator***".

On the "**Initial Setup**" tab, you might see an orange warning sign before "**Authorize this service**", this might be a sign that the Authorization certificate is already expired. If not, it will show a green checkmark icon seen below. To start the renewal proces, click on the "**Reauthorize**" button.

<figure class="wp-block-image aligncenter size-full is-resized">
<img src="/wp-content/uploads/2025/05/FASAuthCert001.png" class="wp-image-1394" style="width:840px;height:auto" />
</figure>

A new window will appear letting you select a Certificate Authority. In my case, the FAS servers are also Issue servers, so I select the Issue CA corresponding with the FAS server I want to renew the certificate for. 

Next, click "**OK**", to initiate the request.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/05/FASAuthCert002.png" class="wp-image-1395" />
</figure>

Next, you or a CA administrator needs to Issue the certificate. Open "**certsrv.msc**" on the Issue CA server or connect to the Issue CA server you selected in the previous step. If all went right, you will see a new pending request in the "Pending Requests" menu item. Check that is the request from the FAS server (*Citrix_RegistrationAuthority_ManualAuthorization Template*)

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/05/FASAuthCert003.png" class="wp-image-1396" />
</figure>

After you have issued the new certificate you can switch back to the Citrix FAS console. You will notice that the spinning wheel wil change to a orange warning sign within a couple of seconds after the new certificate was issued. If not, there might be something wrong in your setup.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/05/FASAuthCert004.png" class="wp-image-1397" />
</figure>

Currently the new certificate is not yet active. To activate you will need to click the "**Update the configuration**" link in the FAS console. This will trigger the update proces, switch the previous Authorization certificate to the new Authorization certificate.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/05/FASAuthCert005.png" class="wp-image-1398" />
</figure>

A confirmation popup will appear with an option to remove the previous certificate after replacement. Make sure this is selected and click "**OK**" to trigger the process.

After a couple of seconds this is finished and a new Authorization certificate is active and a green checkmark icon will be showed in the console.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2025/05/FASAuthCert006.png" class="wp-image-1399" />
</figure>

To see the details of the Authorization certificate, you can click on the "**authorization certificate**" text in the console. The certificate details window will open, allowing you to examine the details.

If you want to check the expiration date of the Authorization certificate, you can execute the following command on the FAS server in PowerShell.

``` text
Add-PSSnapin Citrix.Authentication.FederatedAuthenticationService.V1
Get-FasAuthorizationCertificate -Address localhost -FullCertInfo | Select-Object -ExpandProperty ExpiryDate
```
