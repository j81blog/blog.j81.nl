---
title: "How to use FSlogix AppMasking on Intune managed devices"
date: 2020-07-05T09:50:02Z
lastmod: 2020-07-05T09:50:07Z
featureimage: "/wp-content/uploads/2020/05/fslogix-microsoft-1.jpg"
categories:
  - "FSlogix"
  - "Intune"
  - "Microsoft"
  - "PowerShell"
tags:
  - "Application Masking"
  - "FSlogix"
  - "Intune"
  - "intunewin"
  - "IntuneWinAppUtil"
  - "PowerShell"
  - "Rules"
  - "Win32"
aliases:
  - "/2020/07/05/how-to-use-fslogix-appmasking-on-intune-managed-devices/"
  - "/2020/07/05/how-to-use-fslogix-appmasking-on-intune-managed-devices/feed/"
  - "/2020/07/05/how-to-use-fslogix-appmasking-on-intune-managed-devices/feed/index.html"
---

<div class="wp-block-group">

<div class="wp-block-group__inner-container">

<div class="wp-block-group">

<div class="wp-block-group__inner-container">

A while ago I was asked to apply FSLogix App Masking at a company to hide MS Office for certain users. Normally with just Active Directory that’s a done deal. But the targets were Intune managed. And since FSLogix Application Masking Is not yet supporting AzureAD we had to find other options.

We found that Hybrid Azure AD-joined offered us the best of both worlds (until Microsoft will support AzureAD in FSLogix App Masking)

I will not describe in this article how to configure a Hybrid Azure-AD configuration, but <a href="https://docs.microsoft.com/en-us/mem/intune/enrollment/windows-autopilot-hybrid" class="aioseop-link" target="_blank" aria-label="this site (opens in a new tab)" rel="noreferrer noopener nofollow">this site</a> is a good starting point.

To start we will need a copy of FSLogix and a valid license is required. More information about the license requirements can be <a href="https://docs.microsoft.com/en-us/fslogix/overview" class="aioseop-link" target="_blank" aria-label="found here (opens in a new tab)" rel="noreferrer noopener nofollow">found here</a><a href="https://docs.microsoft.com/en-us/fslogix/overview" class="aioseop-link">.</a>

<a href="https://aka.ms/fslogix_download" class="aioseop-link" aria-label="Download the latest version of FSLogix from the following location (opens in a new tab)" target="_blank" rel="noreferrer noopener nofollow">Download the latest version of FSLogix from this location</a><a href="https://aka.ms/fslogix_download" class="aioseop-link">.</a>

At the time of writing the version is 2004.

Extract the 2 files:

- FSLogixAppsSetup.exe
- FSLogixAppsRuleEditorSetup.exe

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-00.png" class="wp-image-900" />
</figure>

Install these two files on a test target device.

After these applications are installed you can get the installation GUIDs for example via PowerShell, we will use these GUID’s later in this article.

``` powershell
Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize
```

<div class="wp-block-urvanov-syntax-highlighter-code-block">

</div>

<div class="wp-block-urvanov-syntax-highlighter-code-block">

</div>

<div class="wp-block-urvanov-syntax-highlighter-code-block">

</div>

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-01.png" class="wp-image-901" />
</figure>

``` 2
#MSI GUID for Microsoft FSLogix Apps:
{98BEF1EB-609D-4C0F-8FF1-FA0C17CF7108}

#MSI GUID for Microsoft FSLogix Apps RuleEditor:
{501A1A8E-6628-48AB-9B06-56C0284D1707}
```

EXE files are unfortunately not as easily to distribute as MSI files. But there is a solution, create a Win32 app package of the EXE files. To create a Win32 package (.intunewin file) you will need “Microsoft-Win32-Content-Prep-Tool” (<a href="https://go.microsoft.com/fwlink/?linkid=2065730" class="aioseop-link" aria-label="IntuneWinAppUtil.exe (opens in a new tab)" target="_blank" rel="noreferrer noopener nofollow">IntuneWinAppUtil.exe</a>) this can be <a href="https://go.microsoft.com/fwlink/?linkid=2065730" class="aioseop-link" target="_blank" aria-label="downloaded here (opens in a new tab)" rel="noreferrer noopener nofollow">downloaded here</a>. At the time of writing v1.8.1 was the latest version. More information about this tool can be <a href="https://docs.microsoft.com/en-us/mem/intune/apps/apps-win32-app-management" class="aioseop-link" aria-label="found here (opens in a new tab)" target="_blank" rel="noreferrer noopener nofollow">found here</a>.

Download the tool and extract “IntuneWinAppUtil.exe”.

To create these packages start by creating two folders and place the respective files “FSLogixAppsSetup.exe” and “FSLogixAppsRuleEditorSetup.exe” in those folders.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-02.png" class="wp-image-902" />
</figure>

Start by opening Command Prompt with administrative privileges.

You can create the necessary packages by executing the following command:

``` 2
IntuneWinAppUtil.exe -c "<source_folder>" -s "<source_setup_file>" -o "<output_folder>" -q
```

For our FSLogix Agent executable the command will be:

``` 2
IntuneWinAppUtil.exe -q -c "C:\Sources\FSLogix2004Agent" -s "FSLogixAppsSetup.exe" -o "C:\Sources\"
```

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-03.png" class="wp-image-903" />
</figure>

And for the FSLogix RulesEditor:

``` 2
IntuneWinAppUtil.exe -q -c "C:\Sources\FSLogix2004RulesEditor" -s "FSLogixAppsRuleEditorSetup.exe" -o "C:\Sources\"
```

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-04.png" class="wp-image-904" />
</figure>

We are now ready to import the applications in Intune and distribute it to our test machine.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-05.png" class="wp-image-905" />
</figure>

Go to <a href="https://devicemanagement.microsoft.com/" class="aioseop-link" aria-label="Intune (opens in a new tab)" target="_blank" rel="noreferrer noopener nofollow">Intune</a> and logon.

Select “Apps” and select “Windows Apps”.

Next click “Add” to add.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-06.png" class="wp-image-906" />
</figure>

Click “Windows app (Win32)” and click the “Select” button.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-07.png" class="wp-image-907" />
</figure>

Click “Select app package file”

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-08.png" class="wp-image-908" />
</figure>

Next select the created .intunewin file and click “OK” to continue.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-09.png" class="wp-image-909" />
</figure>

Enter a Name, Description and a Publisher. All other items are optionally.

Click “Next” when finished.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-10.png" class="wp-image-910" />
</figure>

Next enter the “Install” and “Uninstall” commands leave install behavior to “System”. Select “Next” when finished.

``` 2
#Install:
FSLogixAppsSetup.exe /install /quiet /norestart
#Uninstall:
FSLogixAppsSetup.exe /uninstall /quiet /norestart
```

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-11.png" class="wp-image-911" />
</figure>

In our case select 64-bit and Windows build 1903. You can fill the rest but these are also optional. Click “Next” when finished.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-12.png" class="wp-image-912" />
</figure>

Next we need to add a detection rule this way Intune can verify if the software was installed.

Select the rule format “Manually configure detection rules”.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-13.png" class="wp-image-913" />
</figure>

Click “Add” to add a detection rule.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-14.png" class="wp-image-914" />
</figure>

Select the type “MSI” and enter the respective MSI GUID we collected earlier and click “OK”.

``` 2
#MSI GUID:
{98BEF1EB-609D-4C0F-8FF1-FA0C17CF7108}
```

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-15.png" class="wp-image-915" />
</figure>

Click “Next” to continue tot the next step.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-16.png" class="wp-image-916" />
</figure>

If you want, you can add Dependencies. As this is not necessary for this application we can click “Next” to continue.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-17.png" class="wp-image-917" />
</figure>

Next click “Add Group” to add a group. The intention is that you can add computers to that group. Each member will receive the application. You can also skip this for now and configure this later.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-18.png" class="wp-image-918" />
</figure>

Click “Next” to continue.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-19.png" class="wp-image-919" />
</figure>

Finally click “Create” to create the application in Intune.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-20.png" class="wp-image-920" />
</figure>

Next do the same for the FSLogix Rule Editor.

``` 2
#Install:
FSLogixAppsRuleEditorSetup.exe /install /quiet /norestart
#Uninstall:
FSLogixAppsRuleEditorSetup.exe /uninstall /quiet /norestart
#MSI GUID:
{501A1A8E-6628-48AB-9B06-56C0284D1707}
```

Now wait for the Applications to get installed on the test device.

When installed run the FSLogix Apps RuleEditor with Administrative privileges.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-21.jpg" class="wp-image-921" />
</figure>

Create a new Rule Set.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-21.png" class="wp-image-922" />
</figure>

Give the set a name like “MSOffice365”.

NOTE: The rules will be saved in the Documents folder by default.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-22.png" class="wp-image-923" />
</figure>

Next select the application we want to hide, in this case Microsoft Office. Click “Scan”.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-23.png" class="wp-image-924" />
</figure>

If you have extra language packs click “Add Another Application”.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-24.png" class="wp-image-925" />
</figure>

Select the other application and click “Scan”.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-25.png" class="wp-image-926" />
</figure>

If needed you can add extra files, folders or other objects to hide.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-26.png" class="wp-image-927" />
</figure>

You can test the rules by selecting “Apply Rules to System”. As soon as this option is selected the rules are active. If you select the option again the rules are disabled.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-27.png" class="wp-image-928" />
</figure>

Select “Manage Assignments” in the File menu.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-28.png" class="wp-image-929" />
</figure>

From the documentation:

*“Assignments are executed from top to bottom.*

*Consider if two assignments were made for the same Rule Set. The first assignment applies the Rule Set to Everyone, the second specifies the Rule Set does NOT apply to User1. In this case, the Rule Set would apply to everyone except User1.”* (<a href="https://docs.microsoft.com/en-us/fslogix/application-masking-users-groups-ht" class="aioseop-link" aria-label="Source (opens in a new tab)" target="_blank" rel="noreferrer noopener nofollow">More Info</a>)

If you want to hide MS Office only for a certain group and allow for anyone else you can configure the following assignments.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-29.png" class="wp-image-930" />
</figure>

You can change the “Applies” option by selecting the rule and change the option.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-30.png" class="wp-image-931" />
</figure>

If you want to hide MS Office for everyone and only show it to members of a certain group you can configure the following assignment.

*NOTE: In tests this way didn't prove to be reliable. There were issues during first login and the intune deployment.*

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-31.png" class="wp-image-932" />
</figure>

I’ve seen that the usage of an Active Directory group directly in the Assignment Rules did not always apply to new users. Until today I haven’t figured out why that happened. Maybe something to do with hybrid joined machines and timing?

I found out that using a Local group in between did the trick. If you want to configure it for yourself try first without the local group. If this doesn’t give a consistent results try it with the following steps.

Create a (new) GPO and link it to the OU where the Hybrid Computer accounts are stored.

Navigate to “Computer Configuration” / “Preferences” / “Control Panel Settings” / “Local Users and Groups”

Select “New” / “Local Group” in the “Action” menu.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-32.png" class="wp-image-933" />
</figure>

Enter a (Local) Group name and add the AD Group as a member. You can use for example the same name as the Domain Group. This way a Local Group will be added to each (Hybrid) Domain joined target.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-33.png" class="wp-image-934" />
</figure>

To use this Local Group we need to make a change to the FSLogix Masking Rules.

Open the “File” menu and select the “Manage Assignments” option.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-34.png" class="wp-image-935" />
</figure>

Double-click the Domain Group.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-35.png" class="wp-image-936" />
</figure>

You can now change it to the Local Group.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-36.png" class="wp-image-937" />
</figure>

To distribute the rules to our clients we’ll going to create a MSI file. MSI’s are easily to distribute via Intune. MSI’s can be created with the free version of Advanced Installer.

Start by creating a “Simple” project.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-37.png" class="wp-image-938" />
</figure>

Select “Product Details” and enter Product Name and Publisher. You can leave the version number for now. If you ever want to update the rules simply reopen this project change the rules and update the version for example to v1.0.1.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-38.png" class="wp-image-939" />
</figure>

You’ll have to make different packages, one for 32-bit and one for 64-bit to get the files in the right location. As our target OS is 64-bit we are going to make a 64-bit package.

Set the package to 64-bit under Install Parameters. And optionally you can set the “Limit to basic user interface” option.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-39.png" class="wp-image-940" />
</figure>

Go to “Files and Folders” right click “Program Files 64” (this will be the “Program Files” directory on a 64-bit OS) and create the folder structure “FSLogix\Apps\Rules”

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-40.png" class="wp-image-941" />
</figure>

Do you remember where we created the AppMasking Rules? (Hint, by default in the Documents folder or where you saved it)

Drag the rules files into the created folder.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-41.png" class="wp-image-942" />
</figure>

When you are finished making the project, save it.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-42.png" class="wp-image-943" />
</figure>

Finally click the Build button. In the location where you saved the project a new directory will be created, “\<Project name\>-SetupFiles” where the MSI will be stored.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-43.png" class="wp-image-944" />
</figure>

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-44.png" class="wp-image-945" />
</figure>

Install the MSI on a test machine and validate if the files are in the expected directory.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-45.png" class="wp-image-946" />
</figure>

You can verify and get the MSI install GUID on the installed machine (we going to need this later on)

``` powershell
Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize
```

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-46.png" class="wp-image-947" />
</figure>

If you have validated the files you can uninstall the MSI so we can import it in Intune and test the deployment.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-47.png" class="wp-image-948" />
</figure>

Go back to Intune again and add an application.

This time add an “Line-of-business app” to add a MSI file.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-48.png" class="wp-image-949" />
</figure>

Click “Select app package file”.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-49.png" class="wp-image-950" />
</figure>

Select the MSI file we created earlier.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-50.png" class="wp-image-951" />
</figure>

Add a name for your application and a description. Also add a Publisher for example your company name, because you have created these rules. You can add extra command-line arguments here, but that is not necessary for our created MSI file. The rest is optional. Click “Next” when finished.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-51.png" class="wp-image-952" />
</figure>

Again you can add an assignment or do this at a later stage. Click Next when finished.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-52.png" class="wp-image-953" />
</figure>

Finally click “Create” to create the App.

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-53.png" class="wp-image-954" />
</figure>

After you assigned it you can verify in the App Overview

<figure class="wp-block-image">
<img src="/wp-content/uploads/2020/05/how-to-use-fslogix-appmasking-on-intune-managed-devices-54.png" class="wp-image-955" />
</figure>

And you can verify it on the target device by checking the Program Files directory.

And that’s it. I know that these are a lot of steps

</div>

</div>

</div>

</div>
