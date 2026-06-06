---
group: "NetScaler"
title: "HowTo - NetScaler - Upgrade firmware"
date: 2024-02-10T21:00:55Z
lastmod: 2024-02-16T15:35:30Z
categories:
  - "ADC"
  - "Citrix"
  - "Netscaler"
tags:
  - "ADC"
  - "Citrix"
  - "Citrix ADC"
  - "HowTo"
  - "NetScaler"
aliases:
  - "/howto-netscaler-upgrade-firmware/"
---
group: "NetScaler"

Upgrading firmware on time is crucial for the business continuity. Especially when new firmware become available containing fixes for high CVE's we have seen recently.

This how to guide focuses on upgrading the NetScaler manually. If you are using an ADM appliance or ADM service, you can use those as well, to automatically upgrade the node(s). 

In most cases you can use the GUI to upgrade the NetScaler and if you might run in to an issue or upgrading from a very old version then you might revert to the CLI (Command Line Interface) and execute the upgrade from there. You can also start at the GUI, whatever you feel comfortable with as long as the NetScaler get it upgrade in-time.

The first step is something I see a lot of people forget from time to time, is to save the config. If you don't save the config and the NetScaler reboots, you might lose some configuration. Therefore always click the save button or enter "**save ns conf**" on the command line before continuing.

Always create a (full) backup (you can follow <a href="https://blog.j81.nl/howto-netscaler-create-a-backup/" target="_blank" rel="nofollow noopener" title="HowTo – NetScaler – Create a backup">this guide to create a backup</a>) and if you like to play is save, download the backup and store it somewhere save. This way you have the necessary details to restore the NetScaler if something happens that cannot be fixed.

Next, make a note of all the VIPs that are down or don't have an UP state, this way you can validate if the states are the same after the upgrade.

If the NetScaler is a VPX appliance, you might want to create a Snapshot (never create a snapshot with memory in running state). You can create a snapshot while the appliance is on but uncheck the option to "**Include virtual machines's memory**" and check the option to "**Quiesce guest file system**".

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-01.png" class="wp-image-1306" />
</figure>

Before continuing, make sure you have enough free space available. You can use the following <a href="https://blog.j81.nl/howto-cleanup/" target="_blank" rel="nofollow noopener" title="(Pre upgrade) Cleanup">HowTo guide</a> to help you identify files that can be removed.

Login on the NetScaler management page with a user account with enough permissions to perform a cleanup if required.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-02.png" class="wp-image-1307" />
</figure>

Make sure you are on the "Configuration" tab.

- Select "**System**".
- On the "**System Information**" tab, click on "**System Upgrade**"

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-03.png" class="wp-image-1308" />
</figure>

The NetScaler shows that it needs 4GB of free space, my personal experience is, that you need at least 5GB to run the upgrade. Make sure you have enough free space

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-04-1024x378.png" class="wp-image-1309" />
</figure>

You can follow this guide to create some free space. When the NetScaler appliance is part of a HA pair, make sure to cleanup also the other appliance before continuing.

***NOTE: If you are upgrading from to a different base version 13.0, 13.1, 14.1 (e.g. from 13.0 to 13.1) you might want to consider using the command line (CLI) upgrade.***

## GUI

Login on the NetScaler management page with a user account with enough permissions to perform a upgrade.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-02.png" class="wp-image-1307" />
</figure>

If the appliance is a member of a HA pair you will be presented with the following Warning message, this is as expected. We want to start the upgrade on the secondary node, not on the primary one.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-05.png" class="wp-image-1310" />
</figure>

Make sure you are on the "Configuration" tab.

- Select "**System**".
- On the "**System Information**" tab, click on "**System Upgrade**"

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-03.png" class="wp-image-1308" />
</figure>

Select the firmware upgrade file by selecting the "Local" option.

And browse and select the firmware file "**build-13.1-51.15_nc_64.tgz**"

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-06.png" class="wp-image-1311" />
</figure>

Next you can (un)check options if you like.

I like to leave the "**Reboot after successful installation**" unchecked. I like to verify the output before rebooting.

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-08-1024x850.png" class="wp-image-1313" />
</figure>

***NOTE: If the firmware upgrade should hang, you might want to execute the upgrade via the command line. If you have selected the "Reboot after successful installation" option, you might want to check if the appliance is restarting before you consider to restart the upgrade via the command line.***

If you receive the message "**Installation cancelled; if you wish to run the NSEPEPI tool during installation, then use the -M option; or if you wish to force the installation use the -Y option but invalid configuration will be lost.**", close the GUI upgrade and continue the command line upgrade.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-09.png" class="wp-image-1314" />
</figure>

When the upgrade is finished, you will be presented with a reboot option, click to reboot.

If you left the "**Reboot after successful installation**" checked, the NetScaler will automatically reboot.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-10.png" class="wp-image-1342" />
</figure>

When the NetScaler is rebooted, logon again.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-02.png" class="wp-image-1307" />
</figure>

If you had chosen for the -M option to convert the classic expressions, you might want to check this if everything is correctly converted. (Primary and secondary authentication policies on the Gateway are still classic for 13.1)

If this is a single node, you can skip the next step to issue a failover.

***NOTE 1: Users may have to clear the browser cache for the Gateway, the cache can contain old data that can give users blank pages or unexpected errors.***

***NOTE 2: You may want to change the portal theme on the gateway (and AAA) vip to "RfWebUI", all the other themes are deprecated and may be removed in later versions.***

If this is a HA pair, you need to failover first before you can test everything. You might want to make changes like changing the Portal Theme first, before continuing.

***NOTE: It's normal at this stage that the VIPs are offline, they will become online after the failover.***

To execute a failover, make sure you are on the "Configuration" tab.

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-10a-1024x522.png" class="wp-image-1318" />
</figure>

On the Confirm dialog, select "**Yes**" to trigger a failover.

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-10b-1024x491.png" class="wp-image-1319" />
</figure>

Select "**OK**" to close the Information dialog

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-10c-1024x360.png" class="wp-image-1317" />
</figure>

Now is the time to check and validate everything.

- Check if everything is online that should be online.
- Validate that all the VIPs have the same state as before.
- Validate internal and external access to (web) applications, gateways, etc.

If all goes well, you are finished with this appliance.

If this node is a member of a HA pair, repeat the same upgrade steps on the other node that now will be secondary.

## Command Line (CLI)

For the Command Line upgrade procedure I will use 2 tools, WinSCP to transfer files and easily browse the filesystem and PuTTY an SSH tool to enter commands and execute the firmware upgrade.

Open WinSCP and connect to the node (the secondary if  this is an HA pair) logon with a user account with enough permissions to perform a upgrade.

In this example we are going to upgrade to version 13.1 build 51.15 (from a 13.0 version)

- Make sure you have around 5GB free space available.
- Navigate to /var/nsinstall 
- Make sure all (old) "**build-xx.x-xx.xx...**" directory and files are removed.
- Create a directory (F7) "**build-13.1-51.15_nc_64**" and upload "**build-13.1-51.15_nc_64.tgz**" to this newly created directory.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-11.png" class="wp-image-1315" />
</figure>

Start PuTTY and connect to the (secondary) node.

Login with an account with enough permissions to execute the upgrade.

Start the upgrade by entering the following commands

``` text
shell
cd /var/nsinstall/build-13.1-51.15_nc_64
tar xvfz build-13.1-51.15_nc_64.tgz
```

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-12-1024x615.png" class="wp-image-1316" />
</figure>

To get a litle bit of extra space, you could remove the firmware file "**build-13.1-51.15_nc_64.tgz**"

``` text
rm build-13.1-51.15_nc_64.tgz
```

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-13.png" class="wp-image-1302" />
</figure>

Next we can start the upgrade process. If you want to upgrade for example from 13.0 to 13.1 and still have some classic policies in use, you might want to add the extra parameter "-M". The upgrade will try to convert the classic polices to advanced policies.

***NOTE: Only add the -M parameter if you intend to convert classic policies to advanced policies!***

Start the upgrade process with the following command:

``` text
./installns -M
```

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-14.png" class="wp-image-1303" />
</figure>

On the question "**Do you wish to delete old signature files and kernel images?**" you can answer "**Y**", this will cleanup old files.

When the installation is completed, you can answer with "Y" on the question "**Reboot NOW?**". The NetScaler wil restart directly. When the NetScaler is online again the upgrade is completed.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-15.png" class="wp-image-1304" />
</figure>

Login again on the NetScaler SSH command line and validate your configuration. 

If you had chosen for the -M option to convert the classic expressions, you might want to check this if everything is correctly converted. (Primary and secondary authentication policies on the Gateway are still classic for 13.1)

If this is a single node, you can skip the next step to issue a failover.

***NOTE 1: Users may have to clear the browser cache for the Gateway, the cache can contain old data that can give users blank pages or unexpected errors.***

***NOTE 2: You may want to change the portal theme on the gateway (and AAA) vip to "RfWebUI", all the other themes are deprecated and may be removed in later versions.***

If this is a HA pair, you need to failover first before you can test everything. You might want to make changes like changing the Portal Theme first, before continuing.

***NOTE: It's normal at this stage that the VIPs are offline, they will become online after the failover.***

To execute a failover, enter the following command:

``` text
force HA failover
```

On the question "**Please confirm whether you want force-failover (Y/N)?**" you can answer "**Y**" as this is to be expected. The Secondary node has now a newer version, and we want to activate this node.

<figure class="wp-block-image size-large">
<img src="/wp-content/uploads/2024/02/ns-fw-upgrade-16-1024x361.png" class="wp-image-1305" />
</figure>

Now is the time to check and validate everything.

- Check if everything is online that should be online.
- Validate that all the VIPs have the same state as before.
- Validate internal and external access to (web) applications, gateways, etc.

If all goes well, you are finished with this appliance.

If this node is a member of a HA pair, repeat the same upgrade steps on the other node that now will be secondary.
