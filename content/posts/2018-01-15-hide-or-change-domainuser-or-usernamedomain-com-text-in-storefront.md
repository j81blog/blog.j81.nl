---
title: "Hide or change \"domain user or username@domain.com\" text in Storefront."
date: 2018-01-15T12:05:16Z
lastmod: 2020-05-23T21:44:55Z
categories:
  - "Citrix"
  - "StoreFront 3.x"
tags:
  - "Citrix"
  - "StoreFront"
aliases:
  - "/2018/01/15/hide-or-change-domainuser-or-usernamedomain-com-text-in-storefront/"
  - "/2018/01/15/hide-or-change-domainuser-or-usernamedomain-com-text-in-storefront/feed/"
  - "/2018/01/15/hide-or-change-domainuser-or-usernamedomain-com-text-in-storefront/feed/index.html"
---

The following was tested om 3.10+ versions, not sure if it works on older or 2.x versions.

## Hide the default text

You can hide the default text "domain\user or username@domain.com" in the storefront username field. <img src="/wp-content/uploads/2018/01/StoreFrontLogonDefault-e1516023050803.png" class="alignnone size-full wp-image-738" width="628" height="394" /> This can be done by simply editing the "custom style.css" file. This file is located in "C:\inetpub\wwwroot\Citrix\\Store\>Web\custom". Replace "\<Store\>" with your own store name. You need to edit each store separately. Add the following to hide the text (1):

``` css
/* Hide text username field */
.credentialform span.pseudo-input.show {
 visibility: hidden;
}
```

You can add the custom code at the end of the "style.css" file after "/\* You may add custom styles below this line. \*/". <img src="/wp-content/uploads/2018/01/StoreFrontLogonEdit.png" class="alignnone wp-image-729" width="430" height="270" /> Make sure that when you are finished you replicate the changes to the other StoreFront server(s).

## Change the Default text

To change the text you can edit the language resource files located in "C:\inetpub\wwwroot\Citrix\\Store\>Auth\App_Data\resources\ExplicitFormsCommon.en.resx" Depending on the language you have configured for your browser a corresponding file will be selected. So make sure you change all the files you or your users will use. <img src="/wp-content/uploads/2018/01/StoreFrontExplicitFormsCommon.png" class="alignnone wp-image-730" width="511" height="202" /> Search for the text "\<data name="DomainUserAssistiveText" xml:space="preserve"\>" and change the text between "\<value\>**TEXT**\</value\>"

``` default
  <data name="DomainUserAssistiveText" xml:space="preserve">
    <value>Your own custom text</value>
  </data>
```

If the text is not directly visible execute a iisreset to force an update. Make sure that when you are finished you replicate the changes to the other StoreFront server(s).
