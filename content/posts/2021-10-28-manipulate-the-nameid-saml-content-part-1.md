---
title: "Manipulate the 'NameID' SAML content - part 1"
date: 2021-10-28T15:22:45Z
lastmod: 2021-10-28T15:22:49Z
categories:
  - "Active Directory"
  - "ADC"
  - "ADFS"
  - "AzureAD"
  - "Citrix"
  - "FAS"
  - "Netscaler"
  - "PowerShell"
tags:
  - "ADC"
  - "ADFS"
  - "AzureAD"
  - "Citrix"
  - "Citrix ADC"
  - "Claims"
  - "EnterpriseApp"
  - "Federation"
  - "NetScaler"
  - "PowerShell"
aliases:
  - "/2021/10/28/manipulate-the-nameid-saml-content-part-1/"
---

Some companies want to allow other (guest) companies to connect to their environment and for example allow them to open a Citrix Desktop. This can be achieved by Connecting an existing Citrix environment to the guest company via SAML (and yes there are other possibilities). SAML is an authentication method based on a two-way trust. Two Microsoft products that can offer SAML authentication are ADFS (Active Directory Federation Services, an on-premises solution) and the other is and Enterprise App you can configure from the Azure portal. The other requirement is Citrix FAS (Federated Authentication Services). In this article I will show you a way to connect a guest (company) via SAML to allow them access to your Citrix environment without the need for adding the guest companies suffix to your domain. 

I will not dive into exactly what Citrix FAS is, just a global overview. This is not a guide how to deploy and configure it (there are a lot of examples out there). What I do want to say about it is that Citrix FAS orchestrates the login for you.

When you login via an external authentication source, an IdP (Identity Provider) for example via SAML. You a SP (Service Provider) hand of the authentication and authorization to the IdP you trust, trust that they verify the users username, password and for example MFA before allowing access. When everything is in order (the user is authenticated and authorized to login) the ADC will receive back one or more attributes. Among the attributes is often a "**NameID**" attribute. This "**NameID**" attribute will contain the users "login" name (or what you specify as login name). This will be most likely a UPN or email formatted object (E.g. user.name@domain.com). But the users password is not one of the attributes... How can the user login to the environment you may ask and that's where Citrix FAS comes in action.

A Citrix ADC will accept the login (after a successful authentication by the IdP), that's because of the trust you have setup between the ADC and the IdP (configured in a ADC SAML Action). StoreFront also needs a "valid" username when not using an Anonymous store config. StoreFront wants to use the identity to find out the resources assigned to that user (or group).

When you configured Citrix FAS you had to authorize it (request and approve a certificate). With this authorization (Certificate) Citrix FAS is able to generate a user (smartcard)certificate on behalf of the user and can utilize this certificate to handle the logon to StoreFront and the machine you are trying to logon to. This will only work as long as the user(object) is found in AD (Active Directory), Citrix FAS can only request a certificate for a user that exists in AD. The matching of the user is done via UPN. So if the SAML "**NameID**" attribute (more on this later) has the value "*john.doe@domain.com*" a user object must exist in AD with the UPN that's equal to "*john.doe@domain.com*". This AD account is sometimes reffered to as a Shadow Account. 

Now back to the "**NameID**" attribute. In most of the deployment guides you will find online is the **"NameID**" attribute configured as the attribute used for login (that will contain the users login ID), in this article I will also use that attribute. This attribute must contain the value that matches a UPN in AD. We cannot do a wildcard search or something, it must match exactly. There are several possibilities to achieve that goal.

**NOTE**: I assume you got a working setup for ADFS or Azure AD, therefor the next steps are configuration changes on these working configs.

*As an example we have a Company environment <span style="color: initial;">(E.g. AD domain: company.com) and you want your customers (E.g. AD domain: customer.nl - ) to be able to logon and start a desktop or app from your Citrix environment, log on (SSON experience) with their own company account.</span>*

1.  **Add an alternative UPN suffixes to the domain and configure the shadow accounts accordingly**
2.  **Change the content of the "Name ID" attribute before it's being send by the IdP**
3.  **Send a custom attribute as "Name ID"**

For option 1 to work you need to add the domain suffix "customer.nl" to the "company.com" domain first. And after that action add users to the "company.com" domain with the suffix "customer.nl" that need to logon to the domain (or modify existing accounts by changing the UPN/domain suffix). Now "Customer" users are able to logon to the domain with their own account.

As for option 2 to work the admin (at "Customer") needs to configure some additional steps to change the suffix before it's being send. This is possible with [ADFS](#MicrosoftADFS) and [AAD](#AzureADEnterpriseApp) and those are two configurations I will explain in this article.

Option 3 will be explained in a different article most likely part 2.

## <span id="MicrosoftADFS"></span>Microsoft ADFS

Less and less companies are utilizing Microsoft ADFS (in our case) as most of them are migrating everything to Azure. There are still several companies utilizing Microsoft ADFS. To make it work we need to modify some "claim" rules. I will only explain the claim rules used for this part, not the complete steps to configure ADFS for use with a Citrix ADC.

Select the ADFS Relying Party Trust you are using for the Citrix ADC and edit the "**Claim Issuance Policy**"

<img src="/wp-content/uploads/2021/10/20211012_210253_ADFS01.png" class="aligncenter size-full wp-image-1166" width="569" height="339" />

Backup (or make a note of the current configuration) and remove your existing claims (except logoff rules)

Add a new rule, a Custom Rule.

<img src="/wp-content/uploads/2021/10/20211012_210253_ADFS02.png" class="aligncenter size-full wp-image-1167" width="716" height="582" />

Give it a name like "**Get user UPN from ActiveDirectory**"

Add the following Custom rule.

``` default
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"]
=> add(store = "Active Directory", types = ("userattrb"), query = ";userPrincipalName;{0}", param = c.Value);
```

If you want to send the email address instead of the UPN you can change "**userPrincipalName**" to **"mail"** or any other attribute.

With this rule we (temporary) use the type "**userattrb**" to store the attribute data we want to edit before it is being send.

Save the rule and add a new rule, again a Custom Rule.

Give it a name like "**Rename attribute and send as NameID**"

<img src="/wp-content/uploads/2021/10/20211012_210253_ADFS02.png" class="aligncenter size-full wp-image-1167" width="716" height="582" />

Add the following Custom rule.

``` default
c:[Type == "userattrb"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Value = RegexReplace(c.Value, "(?<user>[^\\]+)@(?<domain>.+)", "${user}@company.com"));
```

<span style="font-size: revert; font-family: inherit; font-weight: inherit; color: initial;">In this example we use a RegexReplace (yellow), with this option we need to select the text (with a regex expression: "***(?\<user\>\[^\\\]+)@(?\<domain\>.+)***", in red) and replace it with something we want to send (in blue).</span>

<span style="background-color: #ffff00;">RegexReplace(<span style="background-color: #00ff00;">Source</span>, <span style="background-color: #ff6600;">Expression</span>, <span style="color: #000000; background-color: #00ccff;">WhatToReplaceWith</span>) </span>

Fot this example we want to change "*john.doe@customer.nl*" to "*john.doe@company.com*"

Value = <span style="background-color: #ffff00;">RegexReplace(<span style="background-color: #00ff00;">c.Value</span>, <span style="background-color: #ff6600;">"(?\<user\>\[^\\\]+)@(?\<domain\>.+)"</span>, <span style="background-color: #00ccff;">"${user}@company.com"));"</span></span>

This regex (red) selects the complete address <span style="font-size: revert; font-family: inherit; font-weight: inherit; color: initial;">the part before the "@" and temporarily saved in a group named "</span>**user**<span style="font-size: revert; font-family: inherit; font-weight: inherit; color: initial;">" and the part after @ will be temporarily saved in a group named "</span>**domain**<span style="font-size: revert; font-family: inherit; font-weight: inherit; color: initial;">" (named capture groups in the regex expression).</span>

In the last part (blue) we will build our new "**NameID**" content, in our case this will be "**${user}@company.com**"

But you can change it of course to any format or combination you like.

When finished save & test!

This concludes the configuration change required for ADFS.

## <span id="AzureADEnterpriseApp"></span>AzureAD (Enterprise App)

Unfortunately for AzureAD the configuration is not GUI/Web based (yet). You will need to dive into PowerShell to achieve the same goal. And please note that the option is currently (30-09-2021) still in Preview, therefore we need to install and use the "AzureADPreview" PowerShell module.

I will use the same approach, tactics and example as ADFS.

As said before, because this feature is currently still in Preview we need to Install and import the AzureADPreview Module

``` powershell
Install-Module -Name AzureADPreview [-AllowClobber]

Import-Module AzureADPreview
```

If loaded connect to AzureAD

``` powershell
Connect-AzureAD -Confirm
```

The configuration for AzureAD is based on a JSON structure, here you define the claim (as with the custom claim rules in ADFS)

``` default
{
    "ClaimsMappingPolicy": {
        "Version": 1,
        "IncludeBasicClaimSet": "false",
        "ClaimsSchema": [
            {
                "Source": "user",
                "ID": "userprincipalname"
            },
            {
                "Source": "transformation",
                "ID": "DataReplace",
                "SamlClaimType": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier",
                "TransformationId": "userattrb"
            }
        ],
        "ClaimsTransformations": [
            {
                "ID": "userattrb",
                "TransformationMethod": "RegexReplace",
                "InputClaims": [
                    {
                        "ClaimTypeReferenceId": "userPrincipalName",
                        "TransformationClaimType": "sourceClaim"
                    }
                ],
                "InputParameters": [
                    {
                        "ID": "regex",
                        "Value": "@(?<domain>.+)"
                    },
                    {
                        "ID": "replacement",
                        "Value": "@company.com"
                    }
                ],
                "OutputClaims": [
                    {
                        "ClaimTypeReferenceId": "DataReplace",
                        "TransformationClaimType": "outputClaim"
                    }
                ]
            }
        ]
    }
}
```

The rename of the attribute ( "*john.doe@customer.nl*" to "*john.doe@company.com*" ) happens in the "ClaimsTransformations" section. There you will find the "TransformationMethod" with the value "RegexReplace". The section "InputParameters" is responsible for the regex what text to select that needs to be replaced. And the next the text value with ID "replacement" that will replace the "selected" text.

``` powershell
$claimDefinition = '{"ClaimsMappingPolicy":{"Version":1,"IncludeBasicClaimSet":"false","ClaimsSchema":[{"Source":"user","ID":"userprincipalname"},{"Source":"transformation","ID":"DataReplace","SamlClaimType":"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier","TransformationId":"userattrb"}],"ClaimsTransformations":[{"ID":"userattrb","TransformationMethod":"RegexReplace","InputClaims":[{"ClaimTypeReferenceId":"userPrincipalName","TransformationClaimType":"sourceClaim"}],"InputParameters":[{"ID":"regex","Value":"@(?<domain>.+)"},{"ID":"replacement","Value":"@company.com"}],"OutputClaims":[{"ClaimTypeReferenceId":"DataReplace","TransformationClaimType":"outputClaim"}]}]}}'<br>
```

**Tip**: Convert the JSON code to a compressed version via PowerShell, by replacing the part staring with "{" en ending with "}", with the above code:

``` default
$compressedJson = @"
{
    "Code": "JOSN"
}
"@ | Convertto-Json -Compress
```

Next you will need to create a new "Azure AD Policy" with the above specified data (JSON)

``` powershell
$newAzureADPolicy = New-AzureADPolicy -Definition @($claimDefinition) -DisplayName "TransformClaimsCustomer" -Type "ClaimsMappingPolicy" $newAzureADPolicy
```

To apply (attach) the policy to your Enterprise App you will need to gather the Object ID of your Enterprise App. You can find it in the Manage section in Properties.

Copy the GUID. You will need this for the next step.

<img src="/wp-content/uploads/2021/10/FAS-AzureAD-01.jpg" class="aligncenter size-full wp-image-1174" width="950" height="783" />

Next change the ID ("\<EnterpriseAppObjectID\>") in the next code accordingly and execute the command

``` powershell
Add-AzureADServicePrincipalPolicy -Id <EnterpriseAppObjectID> -RefObjectId $newAzureADPolicy.ID
```

Please note the following, after the policy is applied. If you visit the Enterprise App and select "Single sign-on" (1) and click "Edit" (2).

<img src="/wp-content/uploads/2021/10/FAS-AzureAD-02.jpg" class="aligncenter size-full wp-image-1187" width="1067" height="731" />

You will see a notification that a change was made via PowerShell.

<img src="/wp-content/uploads/2021/10/FAS-AzureAD-03.jpg" class="aligncenter size-full wp-image-1186" width="656" height="168" />

This concludes the configuration change required for AzureAD.

As you can see there are several options available to manipulate the "**NameID**"  before it's being send to a SP (Service Provider). 

In the next part I will show you how you can use a different AD attribute instead of the UPN.

 
