---
title: "Manage Native OTP tokens via Windows, Part 2"
date: 2021-04-20T19:31:56Z
lastmod: 2021-04-20T19:31:58Z
featureimage: "/wp-content/uploads/2021/04/ADC-logo.jpg"
categories:
  - "Active Directory"
  - "ADC"
  - "Citrix"
  - "Netscaler"
  - "PowerShell"
  - "Windows"
tags:
  - "ADC"
  - "Certificate"
  - "Decryption"
  - "Encryption"
  - "Native OTP"
  - "NetScaler"
  - "OTP4ADC"
  - "PowerShell"
  - "Secret"
  - "Token"
aliases:
  - "/2021/04/20/manage-native-otp-tokens-via-windows-part-2/"
  - "/2021/04/20/manage-native-otp-tokens-via-windows-part-2/feed/"
  - "/2021/04/20/manage-native-otp-tokens-via-windows-part-2/feed/index.html"
---

A couple weeks ago someone asked me if OTP4ADC could also support encrypted tokens. And at that time I hadn't done anything with encrypted tokens on a Citrix ADC. And if you not have heard of the OTP4ADC tool/script you can read my <a href="https://blog.j81.nl/2020/09/29/manage-native-otp-tokens-via-windows/" target="_blank" rel="nofollow noopener" title="Manage Native OTP tokens via Windows">initial blog article</a> from when I released the first version and the basics of how it works.

First I started with reading the <a href="https://docs.citrix.com/en-us/citrix-adc/current-release/aaa-tm/authentication-methods/native-otp-authentication/otp-encrypt-secret.html" target="_blank" rel="nofollow noopener">docs at Citrix</a> but very soon after I got stuck... I could not get the desired results with the by <a href="https://docs.citrix.com/en-us/citrix-adc/current-release/aaa-tm/authentication-methods/native-otp-authentication/otp-encryption-tool.html" target="_blank" rel="nofollow noopener">Citrix provided python script</a>. It simply didn't work on my test machines? I could also not run it on the ADC because of the missing requirements. So I could not run the script and convert my pre-existing secrets to the encrypted format. Until today I have not yet figured out what went wrong.

I reached out to the community and got help from <a href="https://twitter.com/metadaddy" target="_blank" rel="nofollow noopener">Pat Patterson</a> someone who really knows a lot about Python, PowerShell and encryption, be sure to follow him on <a href="https://twitter.com/metadaddy" target="_blank" rel="nofollow noopener">Twitter</a>! He helped me with converting the code from python to PowerShell. And after some initial tests I added the functions to the OTP4ADC tool/script.

<img src="/wp-content/uploads/2021/04/20210412_OTP4ADC_Encryption.png" class="aligncenter wp-image-1110 size-full" width="570" height="360" alt="OTP4ADC Encryption Tab" />

The new functionality will be available as a new tab next to the already pre-existing features to add and manage the secrets for users as already explained in my <a href="https://blog.j81.nl/2020/09/29/manage-native-otp-tokens-via-windows/" target="_blank" rel="nofollow noopener">first article</a>.

You can find the new v0.5.0 version at my GitHub repository:

- <a href="https://github.com/j81blog/OTP4ADC" target="_blank" rel="nofollow noopener">Public (stable) version</a>
- <a href="https://github.com/j81blog/OTP4ADC/tree/dev" target="_blank" rel="nofollow noopener">Development version</a>

## The Basics

There are two formats a secrets can have in a Active Directory user attribute:

- ClearText
- Encrypted

##### **ClearText**

The clear text format is pretty basic it starts with two characters "#@" followed by the Device name a string consisting of alpha and numeric characters a "=" character and again a string of alpha and numeric characters depicting the secret ending with "&,". Everything after "#@" can be repeated when using multiple secrets. This results in a string like:

``` default
#@Mobile=CHYA3NHIW2QPCGS4Z6VYLV6WBY&,
```

##### **Encrypted**

The format for an encrypted secret is a bit different. The encrypted secret is JSON formatted. It follows basically the same structure with a device name and a secret (encrypted) but then in JSON format. 

``` default
{
  "otpdata": {
    "devices": {
      "Mobile": "9tdkfHjemvPj0odSbkKOASuvgkQ=.oWZC4ts_iOeLvEvK.0bb0wGYQFrdeL2su6BaEC5-kAgD4wLiBGJPo0j-55om9SKnE5vv-"
    }
  }
}
```

You can find more info about the encryption in the <a href="https://docs.citrix.com/en-us/citrix-adc/current-release/aaa-tm/authentication-methods/native-otp-authentication/otp-encryption-tool.html" target="_blank" rel="nofollow noopener">docs at Citrix.</a>

## Encrypted Secrets

To use Native OTP (with or without encryption) you must have an Advanced (Enterprise) or higher license and configure your ADC's LDAP profiles and nFactor configuration. I won't go into these initial configuration steps as there are many blog articles available like <a href="https://www.carlstalhood.com/native-one-time-passwords-otp-citrix-gateway-13/" target="_blank" rel="nofollow noopener">this one at Carl Stalhood</a> that shows you how to configure and setup native OTP. What I will show you is how to enable encrypted secrets and convert the ones already in use. Make sure you configure the correct Active Directory attribute in the LDAP Action(s).

It is up to you how to proceed with the following steps. You can start directly with encryption and thus don't need my tool to convert your pre-existing secrets. This new addition of my tool is mainly for the folks that already deployed Native OTP without encryption and want to improve the security. But if you just want to know how to enable secret encryption, skip to the ***Citrix ADC, enable encryption*** section near the end of this article.

My suggested order would be:

1.  Make sure Native OTP works with the ClearText secret so you'll have a baseline.
2.  Convert the current secrets (for example located in ***userParameters***, let's call this the source attribute) and save the converted (encrypted) secret to a different one (for example ***unixHomeDirectory***, let's call this the target attribute)
3.  Configure the ADC to enable encryption.
4.  Test the encrypted secrets.

You will need a (web) certificate (public & private key) to use use encryption. Without it the secret cannot be encrypted and decrypted. Make sure you have a certificate imported in your ADC. You can use a public or a self signed that makes no difference. And have the certificate in a PFX format ready to import this certificate in your Windows machine to convert your secrets.

## Conversion with OTP4ADC

To use the OTP4ADC tool you need a minimum version of 5.1, but to use the encryption functionality you need to use PowerShell version 7.1 or higher. This is because of certain encryption functionalities are not available in version 5.x. When a lower version of PowerShell is detected, the encryption functionality will be disabled.

<img src="/wp-content/uploads/2021/04/20210412_OTP4ADC_EncryptionDisabled.png" class="aligncenter size-full wp-image-1141" width="569" height="111" alt="OTP4ADC Encryption Disabled" />

You can find some more information about PowerShell 7 in the <a href="https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1" target="_blank" rel="nofollow noopener">Microsoft Docs</a>. You can also use the following one-liner to install PowerShell 7.x.

``` powershell
Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
```

To run the script with PowerShell 7 you can use the following command:

``` powershell
& "C:\Program Files\PowerShell\7\pwsh.exe" -ExecutionPolicy bypass "C:\OTP4ADC\OTP4ADC.ps1"
```

To start with the conversion of ClearText secrets to Encrypted secrets make sure you import the PFX into your (personal) Windows store and make a note of the certificate Thumbprint.

<img src="/wp-content/uploads/2021/04/20210412_Certificate_Thumbprint.png" class="aligncenter wp-image-1123" width="301" height="383" alt="OTP4ADC Certificate Thumbprint" />

Next you need to select an ***attribute operation*** **(1) **Here you can select one of the following options:

- ***Convert plaintext OTP secrets to an encrypted format*** - Use this option to convert ClearText formatted secrets in the source (current) attribute and save it into the target (new) attribute as an encrypted formatted secret.
- ***Convert the encrypted OTP secrets back to plaintext*** - Use this option to convert the encrypted secret in the source (current)attribute and save it into the target (new) attribute to a ClearText formatted secret.
- ***Update the certificate to a new certificate*** - Use this option to decrypt all source (current) attributes with the current certificate and and encrypt it again with the new certificate and save it into the target (new) attribute.

Next select the source/target attribute save option **(2)**. Here you can determine if you want to save the attribute in the current (source = target) or save the changed data to a different attribute.

- ***Save to same attribute*** - This will overwrite your previous attribute value with the new converted value.
- ***Save to different attribute*** - This option will save the converted attribute value to a different attribute of your choosing, the safest option! You will still have access to your original secrets. Be sure to remove the original values at some point if everything is good to go.

<img src="/wp-content/uploads/2021/04/20210412_OTP4ADC_Encryption_steps.png" class="aligncenter size-full wp-image-1111" width="570" height="360" alt="OTP4ADC Encryption steps" />

Depending of the previous selections you need to fill the following fields.

- ***Current Attribute* (3)** - This is the current (source) attribute, where the secrets are currently stored.
- ***New Attribute* (4)** - This is the new (target) attribute location, where the converted secrets are being saved to.
- ***Current Certificate*** **(5)** - If the source attribute is encrypted, this needs to contain the Thumbprint to decrypt the attribute data.
- ***New Certificate* (6)** - If the target attribute needs to be encrypted, this field must contain the Thumbprint of the new certificate.

If you want to save all events to a logfile, select the logfile and location by clicking the ***Browse*** button **(8)** and the path will be shown in the ***Log File*** field **(7)**.

When everything is ready you can click the ***Convert*** button **(9)**. The status of the conversion will be shown in the progress bar **(10)**.

When all your target attributes are encrypted you will receive a question if you want to save the used (new) Thumbprint into the settings.

<img src="/wp-content/uploads/2021/04/20210412_OTP4ADC_SaveThumbprint.png" class="aligncenter size-full wp-image-1124" width="373" height="152" alt="OTP4ADC Save Thumbprint" />

If you have chosen ***Yes*** to the previous choice, you will find the new ***Certificate Thumbprint*** in the ***Settings*** tab. Here you can also enable if the Secrets in the attribute is encrypted.

<img src="/wp-content/uploads/2021/04/20210412_OTP4ADC_Settings.png" class="aligncenter size-full wp-image-1125" width="597" height="436" alt="OTP4ADC Settings" />

If everything went well you can continue and change the settings in the ADC configuration.

## Citrix ADC, enable encryption

To enable encryption you need to enable it on the Citrix ADC. As said earlier make sure you added the Certificate to the ADC. You need it in the next steps. Choose either the CLI or GUI steps.

##### CLI

``` default
bind vpn global -userDataEncryptionKey otp_encryption2
set aaa otpparameter -encryption ON
```

##### GUI

Log on into the Citrix ADC administration page and go to ***Security / AAA - Application Traffic***. Under ***Policy Manager*** click ***Certificate Bindings***. 

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_AAA_Settings.png" class="aligncenter size-full wp-image-1113" width="699" height="708" alt="ADC Config AAA Certificate Settings" />

Next click ***Add*** next to the ***User Data Encryption Key*** field.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_Certificate.png" class="aligncenter size-full wp-image-1117" width="393" height="258" alt="ADC Config Certificate Add" />

Click ***Add Binding***.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_Binding.png" class="aligncenter size-full wp-image-1115" width="1242" height="287" alt="ADC Config Certificate Selection" />

Select the Certificate you want to use for the encryption and decryption of the secrets. Click ***OK*** when certificate is added.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_Binding2.png" class="aligncenter size-full wp-image-1116" width="1211" height="295" alt="ADC Config Certificate Binding" />

Next click **Create** to finish the action.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_Certificate2.png" class="aligncenter size-full wp-image-1118" width="391" height="287" alt="ADC Config Certificate Save" />

Now you have a certificate and are ready to enable the encryption.

Under **Authentication Settings** click the link ***Change authentication AAA OTP Parameter***.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_AAA_Settings2.png" class="aligncenter size-full wp-image-1114" width="948" height="499" alt="ADC Config AAA OTP Settings" />

Check the ***OTP Secret encryption*** checkbox to enable encryption.

<img src="/wp-content/uploads/2021/04/20210412_ADC_Config_AAA_OTP_Param.png" class="aligncenter size-full wp-image-1112" width="430" height="234" alt="ADC Config AAA OTP Param" />

And finally if you might have configured the search filter on your LDAP Action (like <a href="http://www.jgspiers.com/netscaler-native-otp/" target="_blank" rel="nofollow noopener">George Spiers blogged about</a>) for your verify profile like:

``` default
userParameters>=#@
```

You might want to change it to the following string (change your attribute name accordingly):

``` default
userParameters>={"otpdata"
```

This should be it. If all went well you should be able to use the new encrypted secrets.

Please reach out to me via Github, Slack (World of EUC), twitter or contact form if you have issues or ideas.

 
