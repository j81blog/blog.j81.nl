---
title: "RES ONE Workspace on Windows 10 lessons learned"
date: 2016-08-07T18:40:54Z
lastmod: 2020-05-23T21:44:56Z
categories:
  - "Citrix"
  - "ONE Workspace"
  - "RES"
  - "Uncategorized"
  - "Windows"
  - "XenDesktop"
tags:
  - "RES"
  - "RES ONE Workspace"
  - "Start menu"
  - "Tile"
  - "Windows 10"
aliases:
  - "/2016/08/07/res-one-workspace-on-windows-10-lessons-learned/"
---

For a while now Windows 10 is supported with RES ONE Workspace 2015 and up. More and more companies are switching from their old versions (Yes, some of them are still using Windows XP) to Windows 10. I've done a couple of implementation now and thought to share some of the knowledge I found during these implementations.

## Pinning tiles to the Start Menu

There are several ways to accomplish this.

- Use a initial Start Menu layout.
- Use RES ONE Workspace to pin items to the Start Menu
- GPO

The first two options can coexist with each-other and will be explained in detail within this post. The last one I would not recommend when using RES ONE Workspace and will not be discussed within this post.

### Initial Start Menu Layout

You can use a initial Start Menu layout to start with and let the users decide what to keep and what to add. This layout will be applied when the user first logs on. (When the user has no preexisting tile-file) When using multiple versions (RTM / 1511 / 1607) use the **lowest** version to create the initial start layout file! Using a file created on a newer version and then applying it to a lower version is just not supported. Start with logging on to a Windows 10 machine (can be a normal user account) and customize the layout as you like when finished simply logoff to save everything to your profile. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_01-1.png" class="alignnone size-medium wp-image-515" width="300" height="210" alt="20160807_Windows10_01" />](/wp-content/uploads/2016/08/20160807_Windows10_01-1-1.png) Next go to your profile directory. E.g. "%HOMESHARE%\Personal Settings" and copy the layout file "res10tiles.xml" to a temporary directory. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_02-1.png" class="alignnone size-medium wp-image-516" width="300" height="137" alt="20160807_Windows10_02" />](/wp-content/uploads/2016/08/20160807_Windows10_02-1-1.png) Rename the file to "DefaultTileLayout_Windows10.xml" and add the file to the root of Custom Resources. (Administration / Custom Resources) [<img src="/wp-content/uploads/2016/08/20160807_Windows10_03-1.png" class="alignnone size-medium wp-image-517" width="300" height="124" alt="20160807_Windows10_03" />](/wp-content/uploads/2016/08/20160807_Windows10_03-1-1.png) You can test the new file simply by removing the "res10tiles.xml" file from your profile. When no tile-file is found the initial layout file (when available) will be set. If all went well you have a custom Start Menu. ***NOTE**: In some case it can happen you end up with an empty Start Menu even tough you had pinned items or have set an initial tile file. Please read my previous post for more info about this topic. [The case of the empty Start Menu (Windows 10).](http://blog.j81.nl/2016/08/06/the-case-of-the-empty-start-menu-windows-10/)*

### Pin items to the Start Menu with RES ONE Workspace

Every application (shortcut) added to RES ONE Workspace can technically be pinned on the Start Menu. You have 3 options for pinning items.

- **Take no action**: No tile will be created on the Start Menu.
- **Set voluntary tile**: This option will create a tile on the Start Menu only once. The user can remove the tile and also add it again. The tile will be displayed at the end of the Start screen unless a **Group name** is specified.
- **Set mandatory tile**: This option will recreate the tile on the Start screen each time the user starts a new session. The tile will be displayed at the end of the Start screen unless a **Group name** is specified. If you later change this setting to **Take no action**, the tile will be removed from the Start screen.

[<img src="/wp-content/uploads/2016/08/20160807_Windows10_04-1.png" class="alignnone size-medium wp-image-519" width="300" height="134" alt="20160807_Windows10_04" />](/wp-content/uploads/2016/08/20160807_Windows10_04-1-1.png) The size can als be set, you have two sizes to choose from.

- **Medium**: the tile is displayed as a medium sized square on the Start screen.
- **Small**: the tile is displayed as a small sized square on the Start screen.

[<img src="/wp-content/uploads/2016/08/20160807_Windows10_05-1.png" class="alignnone size-medium wp-image-520" width="300" height="134" alt="20160807_Windows10_05" />](/wp-content/uploads/2016/08/20160807_Windows10_05-1-1.png) Next you can set a Group Name. This name will be shown above the application(s) in the Start Menu. It's a option to group applications together. If the group does not exist, it will be created. If no group is specified, the tile will be added to the end of the Start screen. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_06-1.png" class="alignnone size-medium wp-image-521" width="300" height="134" alt="20160807_Windows10_06" />](/wp-content/uploads/2016/08/20160807_Windows10_06-1-1.png)

## No sub folders available in the Start Menu

Take for example Windows XP, if you open the start menu you can have a structure like:

- Programs
  - Accessorizes
  - Administrative Tools
    - System
  - Office
    - Office Tools

This isn't possible anymore with Windows 10. This isn't something RES can fix or change. This is by design with Windows 10. You can have only one sub folder any other sub folder (configured in RES ONE Workspace) will be merged with the first sub folder the Start Menu. To show you I configured some sub folders in RES ONE Workspace. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_08-1.png" class="alignnone size-medium wp-image-522" width="300" height="271" alt="20160807_Windows10_08" />](/wp-content/uploads/2016/08/20160807_Windows10_08-1-1.png) And as you can see it's all merged now in the Start Menu in the first (Microsoft Office 2016) sub folder. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_09-1.png" class="alignnone size-medium wp-image-523" width="267" height="300" alt="20160807_Windows10_09" />](/wp-content/uploads/2016/08/20160807_Windows10_09-1-1.png)

## Internet shortcuts not visible in the Start Menu

When you like to add shortcuts to the start menu you can add a shortcut to Internet Explorer and add the site as parameter. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_10-1.png" class="alignnone size-medium wp-image-524" width="300" height="142" alt="20160807_Windows10_10" />](/wp-content/uploads/2016/08/20160807_Windows10_10-1-1.png) [<img src="/wp-content/uploads/2016/08/20160807_Windows10_11-1.png" class="alignnone size-medium wp-image-525" width="300" height="163" alt="20160807_Windows10_11" />](/wp-content/uploads/2016/08/20160807_Windows10_11-1-1.png) But as you soon find out, no shortcuts (or only one if you haven't added Internet Explorer itself to the Start Menu) will be visible in the Start Menu. And when you investigate this issue you will find out the shortcuts are created in the "%AppData%\Roaming\Microsoft\Windows\Start Menu\Programs" directory. To make them visible in the Start Menu you need to add a registry value. It must be set before login in and before the service was started. It was a known solution for Windows 8(.1) but still valid for Windows 10.

``` default
x86: HKLM\Software\RES\Workspace Manager\EnableMultipleIE (REG_SZ) = Yes
x64: HKLM\Software\Wow6432Node\RES\Workspace Manager\EnableMultipleIE(REG_SZ) = Yes
```

## **Overlapping desktop icons**

This also is a know issue for windows 8(.1) in some cases it can happen that the desktop shortcuts could be placed on top of each other. This is not something you want. To change this behavior a registry value must be specified. It must be set before logging in and before the service was started.

``` default
x86: HKLM\Software\RES\Workspace Manager\DoNotAllowOverlappedDesktopItems (REG_SZ) = Yes
x64: HKLM\Software\Wow6432Node\RES\Workspace Manager\DoNotAllowOverlappedDesktopItems(REG_SZ) = Yes
```

## Empty power menu in the Start Menu

You might notice when you click on the power option in the Start Menu an empty menu and question your self, shouldn't there be an option to logoff? [<img src="/wp-content/uploads/2016/08/20160807_Windows10_12-1-1.png" class="alignnone size-full wp-image-528" width="256" height="227" alt="20160807_Windows10_12" />](/wp-content/uploads/2016/08/20160807_Windows10_12-1-1.png) You can change it by disabling the option "Disable Shutdown for all users on all computers" in the RES ONE Workspace console or when configured set the GPO "Remove and prevent access to the Shut Down, Restart, Sleep and Hibernate commands" to disabled or Not Configured. These two are the same. And thus leave you with an empty menu. [<img src="/wp-content/uploads/2016/08/20160807_Windows10_13-1.png" class="alignnone size-medium wp-image-529" width="300" height="87" alt="20160807_Windows10_13" />](/wp-content/uploads/2016/08/20160807_Windows10_13-1-1.png) When the two options aren't configured you'll get an filled power menu. I think that Microsoft should build in the option when the menu is empty, remove it from the start menu... [<img src="/wp-content/uploads/2016/08/20160807_Windows10_14-1-1.png" class="alignnone size-medium wp-image-530" width="250" height="165" alt="20160807_Windows10_14" />](/wp-content/uploads/2016/08/20160807_Windows10_14-1-1.png) When using VDI showing Shut down and/or Restart is not preferred. E.g. when using XenDesktop MCS the machine must be turned off to be cleaned up, when it reboots the machine isn't reverted to it's original state. Normally when using remote desktop to connect to a machine, in this menu you'll find disconnect here. So why isn't it showing in the power menu? I think it's because of the combination of Windows 10 with Citrix XenDesktop, it looks like you have the console session not a remote session.   When I have more I will add it to this post... [RES Website](http://res.com) [RES ONE Workspace Administration Guide](https://help.res.com/WorkspaceAdminGuide2015/)
