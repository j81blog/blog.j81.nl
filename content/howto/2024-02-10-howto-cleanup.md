---
group: "NetScaler"
title: "HowTo - (Pre upgrade) Cleanup"
date: 2024-02-10T20:57:37Z
lastmod: 2024-02-10T21:01:49Z
categories:
  - "ADC"
  - "Citrix"
  - "Files"
  - "Netscaler"
tags:
  - "ADC"
  - "Citrix"
  - "Citrix ADC"
  - "Cleanup"
  - "HowTo"
  - "NetScaler"
aliases:
  - "/howto-cleanup/"
---
group: "NetScaler"

Before you start an upgrade. You must make sure to have enough free space available. Although in the GUI you see sometimes that you must have 5 GB available, in my experience you need at least 6,5 GB free space.

After a while using a NetScaler, certain folders can get full with files. Or you might had a problem and had to create a trace file. Some of these files and folders can be removed and with that action free up some space.

Although it's possible to use the GUI to cleanup files, I prefer WinSCP to browse, backup and remove files. Within the GUI it's not really possible to download (backup) the logfiles first before removing them.\
I leave it up to you what method you like to use. If you are familiar with bash you could also use the command line to remove files and folders.

## WinSCP

When using a tool to manipulate files on a NetScaler, my go-to tool is WinSCP. Free and easy to use. You can also just copy over the folder and it wil run without installation.

Launch WinSCP and connect to the NetScaler and login.

Next you can browse to the folder you want to cleanup and remove files or folders.

***NOTE: Backup your (log) files before removing them from your NetScaler. It might be you need these (log) files for audit purposes!***

## Cleanup locations

The following paths can be investigated, to be cleaned (source <a href="https://docs.netscaler.com/en-us/citrix-adc/current-release/upgrade-downgrade-citrix-adc-appliance/upgrade-standalone-appliance.html" target="_blank" rel="nofollow noopener">Citrix</a>).

<figure class="wp-block-table">
<table>
<tbody>
<tr>
<td><strong>Path</strong></td>
<td><strong>Description</strong></td>
</tr>
<tr>
<td>/var/nstrace</td>
<td>This directory contains trace files. This is the most common reason for HDD being filled on the NetScaler appliance. This is due to an nstrace being left running for indefinite amount of time. All traces that are not of interest can and should be deleted. To stop an nstrace, go back to the CLI and issue stop nstrace command.</td>
</tr>
<tr>
<td>/var/nslog</td>
<td>This directory contains NetScaler log files.</td>
</tr>
<tr>
<td>/var/log</td>
<td>This directory contains system specific log files.</td>
</tr>
<tr>
<td>/var/tmp/support</td>
<td>This directory contains technical support files, also known as, support bundles. All files not of interest should be deleted.</td>
</tr>
<tr>
<td>/var/core</td>
<td>Core dumps are stored in this directory. There will be directories within this directory and they will be labeled with numbers starting with 1. These files can be quite large in size. Clear all files unless the core dumps are recent and investigation is required.</td>
</tr>
<tr>
<td>/var/crash</td>
<td>Crash files, such as process crashes are stored in this directory. Clear all files unless the crashes are recent and investigation is required.</td>
</tr>
<tr>
<td>/var/nsinstall</td>
<td>Firmware is placed in this directory when upgrading. Clear all files, except the firmware that is currently being used.</td>
</tr>
<tr>
<td>/var/nssynclog</td>
<td>Synched (HA) config and logs.</td>
</tr>
<tr>
<td>/var/nsproflog</td>
<td>Performance related logs</td>
</tr>
</tbody>
</table>
</figure>

### Path: /var/nstrace

This folder can contain folders with trace files. You can delete all directories with content. 

<figure class="wp-block-image size-full is-resized">
<img src="/wp-content/uploads/2024/01/NS-Cleanup-var-nstrace1.png" class="wp-image-1297" style="width:610px;height:auto" />
</figure>

### Path: /var/nslog

Check for numbered files and or folders like "filename.**0.gz**" or "filename.**0.tar.gz**", you can remove these files an folders.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-02-1.png" class="wp-image-1329" />
</figure>

Also check subdirectories for date or numbered folders, you can remove these.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-03-1.png" class="wp-image-1330" />
</figure>

### Path: /var/log

Check for numbered files and or folders like "filename.**0.gz**" or files with dates in the name, you can remove these files an folders.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-04-1.png" class="wp-image-1328" />
</figure>

### Path: /var/tmp/support

You can remove all "**collector_callhome\_....tar.gz**" files.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-05.png" class="wp-image-1324" />
</figure>

### Path: /var/core

You can remove the numbered folders (with content).

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-06.png" class="wp-image-1325" />
</figure>

### Path: /var/crash

You can remove all subdirectories in this location.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-07.png" class="wp-image-1326" />
</figure>

### Path: /var/nsinstall

You can remove all files and folders except "**adc.version**", "**installns_state**" and "**installns_state_post_reboot**".

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-08.png" class="wp-image-1327" />
</figure>

### Path: /var/nssynclog

Check for numbered files and or folders like "filename.**0**" or files with dates in the name, you can remove these files an folders.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-09.png" class="wp-image-1331" />
</figure>

### Path: /var/nsproflog

Check for numbered files and or folders like "filename.**0.tar.gz**" or "filename.**0.gz**" or files with dates in the name, you can remove these files an folders.

<figure class="wp-block-image size-full">
<img src="/wp-content/uploads/2024/02/NS-Cleanup-var-nstrace-10.png" class="wp-image-1332" />
</figure>

Source information: <a href="https://docs.netscaler.com/en-us/citrix-adc/13-1/system/troubleshooting-citrix-adc/how-to-free-space-on-var-directory.html" target="_blank" rel="nofollow noopener">https://docs.netscaler.com/en-us/citrix-adc/13-1/system/troubleshooting-citrix-adc/how-to-free-space-on-var-directory.html</a>
