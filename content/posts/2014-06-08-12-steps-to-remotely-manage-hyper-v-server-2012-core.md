---
title: "12 Steps to Remotely Manage Hyper-V Server 2012 Core"
date: 2014-06-08T15:47:51Z
categories:
  - "Hyper-V"
  - "Microsoft"
  - "Uncategorized"
aliases:
  - "/2014/06/08/12-steps-to-remotely-manage-hyper-v-server-2012-core/"
---

Install Hyper-V Server 2012 Core and log in to the console.

1.  Configure date and time (select \#9).

2.  Enable Remote Desktop (select \#7). Also select the ‘Less Secure’ option.

3.  Configure Remote Management (select \#4 then \#1).

4.  Add local administrator account (select \#3). Username and password need to be exactly the same as the account you are going to use on the client computer to manage this Hyper-V Server.

5.  Configure network settings (select \#8). Configure as a static IP. Same subnet as your home network. Don’t forget to configure the DNS IP.

6.  Set the computer name (select \#2). Rename the server and reboot.

7.  Remote Desktop to server. On your client machine, remote to the server via the IP address you assigned it. Use the credentials of the local administrator account you created earlier.

8.  Launch PowerShell. In the black cmd window, run the following command: \[code\]start powershell\[/code\]

9.  Run the following commands:

    ``` powershell
    Enable-NetFirewallRule -DisplayGroup “Windows Remote Management”
    Enable-NetFirewallRule -DisplayGroup “Remote Event Log Management”
    Enable-NetFirewallRule -DisplayGroup “Remote Volume Management”
    Set-Service VDS -StartupType Automatic
    ```

10. Reboot the server (select \#12).

11. Enable Client Firewall Rule. On your client machine, launch an elevated PowerShell prompt and type the following command:

    ``` powershell
    Enable-NetFirewallRule -DisplayGroup “Remote Volume Management”
    ii c:windowssystem32driversetc
    ```

12. Add server hostname and IP to hosts file. Right click hosts and select properties. In the security tab, add your username. Give your account modify rights.This is needed because some remote management tools we need to use rely on the hosts file to resolve the name. Without doing this you are highly likely to encounter some errors while trying to create VHDs and such. Error you might see: There was an unexpected error in configuring the hard disk.

You should now be able to remotely manage the Hyper-V server from the client machine. This includes managing the Hyper-V server’s disk from within the disk management console on the client. You should be able to create VHD’s successfully as well from within Hyper-V Manager on the client (assuming you installed the feature). <a href="http://pc-addicts.com/12-steps-to-remotely-manage-hyper-v-server-2012-core/" target="_blank" title="12 Steps to Remotely Manage Hyper-V Server 2012 Core">Source</a>
