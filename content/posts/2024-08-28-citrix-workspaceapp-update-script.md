---
title: "Citrix WorkspaceApp Update Script: Check and Alert for Security Risks"
date: 2024-08-28T19:50:19Z
lastmod: 2024-08-29T06:22:35Z
featureimage: "/wp-content/uploads/2024/08/CWADetectionScript.jpeg"
categories:
  - "Citrix"
  - "PowerShell"
  - "Receiver"
  - "WorkspaceApp"
tags:
  - "Citrix"
  - "PowerShell"
  - "Receiver"
  - "WorkspaceApp"
aliases:
  - "/2024/08/28/citrix-workspaceapp-update-script/"
  - "/2024/08/28/citrix-workspaceapp-update-script/feed/"
  - "/2024/08/28/citrix-workspaceapp-update-script/feed/index.html"
---

It's crucial to regularly update your Citrix WorkspaceApp to an up-to date version. Many environments still use outdated versions with significant security vulnerabilities (CVEs). Too often, I encounter environments that are still running old versions, including the antiquated "Receiver" versions. Not updating to a non-vulnerable or recent supported version poses a real security risk!\
In many environments, users have company-managed devices, for example managed via Microsoft Intune, which can be updated centrally. These devices are typically kept up to date. The greatest risk lies with non-company-managed devices, such as privately owned laptops or bring-your-own-device (BYOD) systems, where users are responsible for maintaining updates themselves.

There’s little you can do for users beyond regularly informing them and providing how-to knowledge. However, we can easily detect the installed Citrix WorkspaceApp (or Receiver) version used by the user without accessing their device. When a user connects to the company Citrix environment, the Citrix WorkspaceApp version is shared with the remote session. This is useful information and can help us check the version and inform the user if they have an unsupported or vulnerable version on their local machine.

Several of my customers have asked how to inform users that they need to update outdated or vulnerable versions. This prompted me to create this script. You can run it as part of a login script or as a task in a tool like Citrix WEM. If the user has a supported or not a vulnerable version, nothing will be displayed. However, if the user has an unsupported or vulnerable version with a known CVE, a customizable popup will appear. Depending on the settings, it can also log off the session. The image shows just an example of what’s possible.

An example (test message) when a vulnerable version was detected:

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2024/08/CWADetectionCVE.png" class="wp-image-1350" />
</figure>

An example (test message) when a outdated (EOL) version was detected:

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2024/08/CWADetectionEOL.png" class="wp-image-1351" />
</figure>

You can run the script with parameters or by specifying a customized JSON-file that is up to you. To get an overview of all the parameters and some example just run the following command:

``` text
Get-Help <PathTo>\CWACLientDetection.ps1 -Full
```

This example r<span style="color: initial;">uns the script with the specified parameters in test mode, running locally and showing the user EOL and CVE messages. It will only log the user off if a CVE was detected (-LogoffOnCVE ). Leave the -Test parameter when presenting the script to the user.</span>

**NOTE**: The ***-RunLocal*** parameter allows you to run the script on your laptop for example. Leave this parameter when you run the script in a Citrix Session as a login script!

``` text
C:\Scripts\CWACLientDetection.ps1 -EnableLogging -LoggingPath "C:\Scripts\Logs" -MessageLogo "C:\Scripts\\Logo.png" -MessageTextEOL "Multiline`r`nEnd of life message" -MessageTextCVE "Multiline`r`nCVE message" -MessageTitle "Title" -RunLocal -LogoffOnCVE -Test
```

The next example wil basically show the same while using <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting" target="_blank" rel="nofollow noopener">splatting</a>. <span style="color: initial;">You can optionally use the -Test parameter to run the script in test mode.</span>

``` text
@params = @{
    "EnableLogging" = $true
    "LoggingPath" = "<PathTo>\\Logs"
    "MessageLogo" = "<PathTo>\Logo.png"
    "MessageTextEOL" = @"
Multiline
End of life message
"@ # <= It's very important to add NO spaces in front of the closing tag
    "MessageTextCVE" = @"
Multiline
CVE message
"@
    "MessageTitle" = "Title"
    "RunLocal" = $true
    "LogoffOnEOL" = $false
    "LogoffOnCVE" = $true
}
CWACLientDetection.ps1 @params [-Test]
```

You can also create a JSON file with the same "parameters" and save it for example as "C:\Script\CWACLientDetection.json".

**NOTE:** On the PoSH command line a new line in string is defined as "\`r\`n" the same in a JSON file is "\r\n".

**NOTE:** Path dividers in JSON need a double \\, e.g.: C:\\Script\\CompanyLogo.png

``` text
{
    "MessageTitle": "Company - Citrix Workspace App versie check",
    "MessageTextEOL":  "Multiline\r\nEnd of life message",
    "MessageTextCVE":  "Multiline\r\nCVE message",
    "MessageLogo":  ".\\CWACLientDetection.png",
    "LogoffOnEOL":  false,
    "LogoffOnCVE":  true,
    "RunLocal": false
}
```

You can than run the script with the following parameters and y<span style="color: initial;">ou can optionally use the -Test parameter to run the script in test mode.</span>

``` text
C:\Script\CWACLientDetection.ps1 -JSONFilename "C:\Script\CWACLientDetection.json" [-Test]
```

You can find the latest version <a href="https://github.com/j81blog/Miscellaneous-Code-And-Files/tree/main/Citrix%20-%20CWAClientDetection" target="_blank" rel="nofollow noopener">here on my GitHub repository</a>. I will try to regularly update the script. Especially when a new CVE will be released or when new versions will be added with new EOL dates.

Please send me a message if you miss a CVE or you have suggestions to make it better. I don't use an Apple Mac or Linux client devices. So I haven't really had the opportunity to test those kind of devices. Please contact me if you find something not working correctly.

Hopefully this script can help you keep your environment up-to-date and a little bit safer.
