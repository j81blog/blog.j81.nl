---
title: "Windows 8 Maintenance jobs"
date: 2015-04-15T11:27:08Z
categories:
  - "Citrix"
  - "Provisioning Services"
  - "Uncategorized"
aliases:
  - "/2015/04/15/windows-8-maintenance-jobs/"
  - "/2015/04/15/windows-8-maintenance-jobs/feed/"
  - "/2015/04/15/windows-8-maintenance-jobs/feed/index.html"
---

Windows 8 has some new maintenance jobs. These are great when you have an physical machine. But not when you're using Citrix PVS to stream the OS. To disable these tasks enter the following commands:

``` batch
schtasks /change /TN "MicrosoftWindowsTaskSchedulerIdle Maintenance" /disable
psexec -s schtasks /change /TN "MicrosoftWindowsTaskSchedulerMaintenance Configurator" /disable
schtasks /change /TN "MicrosoftWindowsTaskSchedulerManual Maintenance" /disable
schtasks /change /TN "MicrosoftWindowsTaskSchedulerRegular Maintenance" /disable
```

psexec can be downloaded <a href="https://technet.microsoft.com/en-us/sysinternals/bb897553.aspx" target="_blank">here</a> To see if i's dsiabled:

``` batch
SCHTASKS /Query
```

Look for "Folder: MicrosoftWindowsTaskScheduler"

``` batch
Folder: MicrosoftWindowsTaskScheduler
TaskName                                 Next Run Time          Status
======================================== ====================== ===============
Idle Maintenance                         N/A                    Disabled
Maintenance Configurator                 N/A                    Disabled
Manual Maintenance                       N/A                    Disabled
Regular Maintenance                      N/A                    Disabled
```

 
