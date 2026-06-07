---
title: "How To Image, Sysprep and Deploy Windows 7 a Complete Guide – Using sysprep and Imagex"
date: 2012-12-04T15:49:51Z
categories:
  - "Microsoft"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2012/12/04/how-to-image-sysprep-and-deploy-windows-7-a-complete-guide-using-sysprep-and-imagex/"
  - "/2012/12/04/how-to-image-sysprep-and-deploy-windows-7-a-complete-guide-using-sysprep-and-imagex/feed/"
  - "/2012/12/04/how-to-image-sysprep-and-deploy-windows-7-a-complete-guide-using-sysprep-and-imagex/feed/index.html"
---

## Getting Ready

- Install Windows 7 from scratch on to your test machine. **DO NOT** upgrade from Windows XP, this needs to be a fresh install.
- Customise Windows 7 with any software, security settings or general settings you wish. When you install from this image all the settings as well as user accounts will be installed by default.
- Install WAIK for 7/2008 on the test PC. Download from [here](http://www.microsoft.com/downloads/details.aspx?displaylang=en&FamilyID=696dd665-9f76-4177-a811-39c26d3b3b34) (1.7GB).

## Create WINPE Disk

- Right click command prompt run as admin

<!-- -->

- Change to directory **“C:Program FilesWindows AIKToolsPETools”**

<!-- -->

- run command **“copype x86 c:winpe”**

<!-- -->

- run command **“imagex /mountrw c:winpewinpe.wim 1 c:winpemount”**

<!-- -->

- copy imagex.exe from **“C:Program FilesWindows AIKToolsx86imagex.exe”** to **“c:winpemountwindowssystem32″**

<!-- -->

- Create wimscript.ini in **“c:winpemountwindowssystem32″** with following inside

<!-- -->

    [ExclusionList]
    ntfs.log
    hiberfil.sys
    pagefile.sys
    "System Volume Information"
    RECYCLER
    WindowsCSC

    [CompressionExclusionList]
    *.mp3
    *.zip
    *.cab
    WINDOWSinf*.pnf 

- Run Command **“imagex.exe /unmount /commit c:winpemount”**

<!-- -->

-  Run Command **“copy c:winpewinpe.wim c:winpeisosourcesboot.wim /y”**

<!-- -->

- Run Command **“oscdimg -n -h -bc:winpeetfsboot.com c:winpeiso c:winpewinpe.iso”**

<!-- -->

-  This will create an ISO in **c:winpewinpe.iso**.

<!-- -->

- **Burn this and keep.** Now we need to sysprep our machine. (You can remove WAIK and any files you don’t need, test your iso first!)

Sysprep Your Machine

- change to the folder **“c:windowssystem32sysprep”**

 

- - run command **“sysprep /generalize /oobe /shutdown”**
  - If you want to use run an unattended installation you can run the following command **sysprep /generalize /oobe /shutdown /unattend:unattend.xml**(The unattend.xml will need to be in the sysprep folder). Check out the[unattend.xml generator](http://benosullivan.co.uk/windows-7-unattend-xml-generator/)
  - Sysprep will remove any unique information and reseal the OS. Then the system will **shutdown**

![sysprep Windows 7](//maxcdn.benosullivan.co.uk/images/posts/2009/october/06/8.png)

- **Now boot the ISO** we created previously and load into WinPE

 

## Capture Image

- Once WinPE is booted you will be in a Command Prompt window
- Run Command **“diskpart”**
- Run Command **“select disk 0″**
- Run Command **“list volume”**
- Note the letter of the drive you are imaging. C: in WinPE is set as the running OS not as the internal HDD
- Run Command **“exit”**
- Run Command **“imagex /capture d: d:install.wim “My Windows partition”"** where d: is the drive you are copying
- This will create a file called **install.wim** in the root of your HDD. This is the custom image and will need to be added to the Windows 7 Install DVD

 

## Create Installation Media

- You will probably need to install from USB as the image will probably be to large for a DVD. Here is a guide for [Windows 7 USB Install](http://benosullivan.co.uk/windows/installing-windows-7-from-a-usb-stick-from-windows-xp/)
- overwrite install.wim to sources on the windows 7 install source
- If you didn’t use the sysprep to include unattend.xml you can also add it directly to the root of the install media. You can easily [Generate an unattend.xml](http://benosullivan.co.uk/windows-7-unattend-xml-generator/) here

 

<div>

<div>

Install Windows 7 as normal. Your changes will be installed along with Windows 7

</div>

</div>

<div>

</div>

<div>

<a href="http://itshi-tech.blogspot.nl/2012/05/how-to-image-sysprep-and-deploy-windows.html" target="_blank"><strong>Source</strong></a>

</div>
