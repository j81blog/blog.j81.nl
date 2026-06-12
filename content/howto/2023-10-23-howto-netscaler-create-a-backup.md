---
group: "NetScaler"
title: "HowTo - NetScaler - Create a backup"
date: 2023-10-23T13:07:03Z
lastmod: 2024-02-10T21:02:23Z
categories:
  - "ADC"
  - "Citrix"
  - "Netscaler"
tags:
  - "ADC"
  - "Backup"
  - "Citrix"
  - "Citrix ADC"
  - "HowTo"
  - "NetScaler"
aliases:
  - "/howto-netscaler-create-a-backup/"
---

A backup can save you a lot of time in case of emergencies, configuration errors or hacks. You could download and save it in a secure environment. And when needed restore a new appliance with the saved backup.

## GUI

As always, login to the NetScaler by using an account with enough permissions to execute your task.

<img src="/wp-content/uploads/2023/10/HowToNSLogon.png" class="aligncenter size-full wp-image-1265" width="1418" height="624" alt="NetScaler logon" />

 

On the "**Configuration**" tab, open the menu "**System**" (1) and "**Backup & Restore**" (2).

Next click on the button "**Backup/Import**" (3).

**NOTE**: you will only see the button when no backup is created or available.

<img src="/wp-content/uploads/2023/10/HowToNSBackup01.png" class="aligncenter size-full wp-image-1263" width="983" height="1600" alt="Open Backup&amp;Restore" />

 

If there is one or more backups already available, you'll see the following screen/button. Click "**Backup/Import**" to create a backup.

<img src="/wp-content/uploads/2023/10/HowToNSBackup01b.png" class="aligncenter size-full wp-image-1266" width="613" height="361" alt="Open Backup&amp;Restore" />

 

Next make sure "**Create**" (1) is selected as option.

Enter a "**File Name**" (2) meaningful for you or your company. I like to specify the type of backup (Full or Basic) the date and time of the backup. The name can be a maximum of 63 characters long.

Select the backup "**Level**" (3) Full or Basic.

- **Basic**; You can perform this type of backup if you want to back up files that constantly change. The files that you can back up are in the following table.

<table style="border-collapse: collapse; width: 100%;">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr>
<td style="width: 50%"><strong>Directory</strong></td>
<td style="width: 50%"><strong>Sub-Directory or Files</strong></td>
</tr>
<tr>
<td style="width: 50%">/nsconfig/</td>
<td style="width: 50%">ns.conf<br />
ZebOS.conf<br />
rc.netscaler<br />
snmpd.conf<br />
nsbefore.sh<br />
nsafter.sh<br />
inetd.conf<br />
ntp.conf<br />
syslog.conf<br />
newsyslog.conf<br />
crontab<br />
host.conf<br />
hosts<br />
ttys<br />
sshd_config<br />
httpd.conf<br />
monitrc<br />
rc.conf<br />
ssh_config<br />
localtime<br />
issue<br />
issue.net</td>
</tr>
<tr>
<td style="width: 50%">/var/</td>
<td style="width: 50%">download/*<br />
log/wicmd.log<br />
wi/tomcat/webapps/*<br />
wi/tomcat/logs/*<br />
wi/tomcat/conf/catalina/localhost/*<br />
nslw.bin/etc/krb.conf<br />
nslw.bin/etc/krb.keytab<br />
netscaler/locdb/*<br />
lib/likewise/db/*<br />
vpn/bookmark/*<br />
netscaler/crl<br />
nstemplates/*<br />
learnt_data/*</td>
</tr>
<tr>
<td style="width: 50%">/netscaler/</td>
<td style="width: 50%">custom.html<br />
vsr.htm</td>
</tr>
</tbody>
</table>

- **Full**; In addition to the files that are backed up by a basic backup, a full backup has less frequently updated files. The files that are backed up when you use the “Full” backup option are:

<table style="border-collapse: collapse; width: 100%; height: 159px;">
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr style="height: 28px;">
<td style="width: 50.9524%; height: 28px"><strong>Directory</strong></td>
<td style="width: 49.0476%; height: 28px"><strong>Sub-Directory or Files</strong></td>
</tr>
<tr>
<td style="width: 50.9524%">nsconfig</td>
<td style="width: 49.0476%">sl*<br />
license*<br />
fips*</td>
</tr>
<tr>
<td style="width: 50.9524%">/var/</td>
<td style="width: 49.0476%">netscaler/ssl/*<br />
wi/java_home/jre/lib/security/cacerts/*<br />
wi/java_home/lib/security/cacerts/*</td>
</tr>
</tbody>
</table>

And lastly add a "**Comment**" (4). This is a text field where you can add your own description up to 255 characters.

Click "**Backup**" to start the backup.

<img src="/wp-content/uploads/2023/10/HowToNSBackup02.png" class="aligncenter size-full wp-image-1264" width="700" height="865" alt="Enter name and select backup type" />

If you want to save created backup, you can download the file.

Select the file you want to download and choose "**Download**" in the Action menu. Your browser wil initiate the download. Store the file somewhere safe! This unencrypted backup may contain sensitive information and data.

<img src="/wp-content/uploads/2023/10/HowToNSBackup03.png" class="aligncenter size-full wp-image-1271" width="1436" height="497" alt="Downlaod the backup" />

## CLI

You can also initiate a backup from the CLI.

``` text
create system backup "Full_20231023_1502" -level full -comment "CLI Backup"
```

<img src="/wp-content/uploads/2023/10/HowToNSBackup04.png" class="aligncenter size-full wp-image-1274" width="1100" height="110" alt="Backup via CLI" />

And that's it! Make sure to backup your config regularly.
