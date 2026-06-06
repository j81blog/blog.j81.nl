---
title: "Command Line Commands for Control  Panel Applets"
date: 2013-02-08T21:50:09Z
categories:
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2013/02/08/command-line-commands-for-control-panel-applets/"
---

<div id="by">

List of Control Panel Commands in Windows 8, 7, Vista, and XP

</div>

Sometimes it's easier, or maybe even necessary, to open a Control Panel applet from a command line in Windows. Each Control Panel applet can be opened by executing a command, you just have to know what that command is. Control Panel itself can be accessed by executing control from a command line in Windows 8, Windows 7, Windows Vsta, and Windows XP. If you want a way to start a Control Panel applet from a script or from the Command Prompt, the following list of commands for Control Panel applets should help: Note: See my List of Control Panel Applets in Windows for Control Panel applet descriptions and information about changes in applets between the Windows operating systems.

## Control Panel Command Line Commands in Windows

<table width="100%" data-border="1" data-cellspacing="0" data-cellpadding="2">
<tbody>
<tr>
<td style="text-align: center;">Control Panel Applet</td>
<td style="text-align: center;">Command</td>
<td style="text-align: center;">OS</td>
</tr>
<tr>
<td style="text-align: center;">Accessibility Options</td>
<td style="text-align: center;">control access.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Action Center</td>
<td style="text-align: center;">control /name Microsoft.ActionCenter</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control wscui.cpl</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">Add Features to Windows 8</td>
<td style="text-align: center;">control /name Microsoft.WindowsAnytimeUpgrade</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Add Hardware</td>
<td style="text-align: center;">control /name Microsoft.AddHardware</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control hdwwiz.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Add or Remove Programs</td>
<td style="text-align: center;">control appwiz.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Administrative Tools</td>
<td style="text-align: center;">control /name Microsoft.AdministrativeTools</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control admintools</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Automatic Updates</td>
<td style="text-align: center;">control wuaucpl.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">AutoPlay</td>
<td style="text-align: center;">control /name Microsoft.AutoPlay</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Backup and Restore Center</td>
<td style="text-align: center;">control /name Microsoft.BackupAndRestoreCenter</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Backup and Restore</td>
<td style="text-align: center;">control /name Microsoft.BackupAndRestore</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">Biometric Devices</td>
<td style="text-align: center;">control /name Microsoft.BiometricDevices</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">BitLocker Drive Encryption</td>
<td style="text-align: center;">control /name Microsoft.BitLockerDriveEncryption</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Bluetooth Devices</td>
<td style="text-align: center;">control bthprops.cpl<sup>13</sup></td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control /name Microsoft.BluetoothDevices</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Color Management</td>
<td style="text-align: center;">control /name Microsoft.ColorManagement</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Color<sup>1</sup></td>
<td style="text-align: center;">WinColor.exe<sup>2</sup></td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Credential Manager</td>
<td style="text-align: center;">control /name Microsoft.CredentialManager</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">Client Service for NetWare</td>
<td style="text-align: center;">control nwc.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Date and Time</td>
<td style="text-align: center;">control /name Microsoft.DateAndTime</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control timedate.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control date/time</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Default Location</td>
<td style="text-align: center;">control /name Microsoft.DefaultLocation</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">Default Programs</td>
<td style="text-align: center;">control /name Microsoft.DefaultPrograms</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Desktop Gadgets</td>
<td style="text-align: center;">control /name Microsoft.DesktopGadgets</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Device Manager</td>
<td style="text-align: center;">control /name Microsoft.DeviceManager</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control hdwwiz.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">devmgmt.msc</td>
<td style="text-align: center;">8, 7, Vista, XP<sup>3</sup></td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Devices and Printers</td>
<td style="text-align: center;">control /name Microsoft.DevicesAndPrinters</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control printers</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Display</td>
<td style="text-align: center;">control /name Microsoft.Display</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control desk.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">control desktop</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Ease of Access Center</td>
<td style="text-align: center;">control /name Microsoft.EaseOfAccessCenter</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control access.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Family Safety</td>
<td style="text-align: center;">control /name Microsoft.ParentalControls</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">File History</td>
<td style="text-align: center;">control /name Microsoft.FileHistory</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">Flash Player Settings Manager</td>
<td style="text-align: center;">control flashplayercplapp.cpl</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Folder Options</td>
<td style="text-align: center;">control /name Microsoft.FolderOptions</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control folders</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Fonts</td>
<td style="text-align: center;">control /name Microsoft.Fonts</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control fonts</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Game Controllers</td>
<td style="text-align: center;">control /name Microsoft.GameControllers</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control joy.cpl</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Get Programs</td>
<td style="text-align: center;">control /name Microsoft.GetPrograms</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Getting Started</td>
<td style="text-align: center;">control /name Microsoft.GettingStarted</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">Home Group</td>
<td style="text-align: center;">control /name Microsoft.HomeGroup</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Indexing Options</td>
<td style="text-align: center;">control /name Microsoft.IndexingOptions</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">rundll32.exe shell32.dll,Control_RunDLL srchadmin.dll</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Infrared</td>
<td style="text-align: center;">control /name Microsoft.Infrared</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control irprops.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control /name Microsoft.InfraredOptions</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Internet Options</td>
<td style="text-align: center;">control /name Microsoft.InternetOptions</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control inetcpl.cpl</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">iSCSI Initiator</td>
<td style="text-align: center;">control /name Microsoft.iSCSIInitiator</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Keyboard</td>
<td style="text-align: center;">control /name Microsoft.Keyboard</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control keyboard</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Language</td>
<td style="text-align: center;">control /name Microsoft.Language</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">Location and Other Sensors</td>
<td style="text-align: center;">control /name Microsoft.LocationAndOtherSensors</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">Location Settings</td>
<td style="text-align: center;">control /name Microsoft.LocationSettings</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">Mail<sup>4</sup></td>
<td style="text-align: center;">control mlcfg32.cpl<sup>5</sup></td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Mouse</td>
<td style="text-align: center;">control /name Microsoft.Mouse</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control main.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control mouse</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Network and Sharing Center</td>
<td style="text-align: center;">control /name Microsoft.NetworkAndSharingCenter</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Network Connections</td>
<td style="text-align: center;">control ncpa.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control netconnections</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Network Setup Wizard</td>
<td style="text-align: center;">control netsetup.cpl</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Notification Area Icons</td>
<td style="text-align: center;">control /name Microsoft.NotificationAreaIcons</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">ODBC Data Source Administrator</td>
<td style="text-align: center;">control odbccp32.cpl</td>
<td style="text-align: center;">XP<sup>6</sup></td>
</tr>
<tr>
<td style="text-align: center;">Offline Files</td>
<td style="text-align: center;">control /name Microsoft.OfflineFiles</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Parental Controls</td>
<td style="text-align: center;">control /name Microsoft.ParentalControls</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Pen and Input Devices</td>
<td style="text-align: center;">control /name Microsoft.PenAndInputDevices</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control tabletpc.cpl</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Pen and Touch</td>
<td style="text-align: center;">control /name Microsoft.PenAndTouch</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control tabletpc.cpl</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">People Near Me</td>
<td style="text-align: center;">control /name Microsoft.PeopleNearMe</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control collab.cpl</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Performance Information and Tools</td>
<td style="text-align: center;">control /name Microsoft.PerformanceInformationAndTools</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Personalization</td>
<td style="text-align: center;">control /name Microsoft.Personalization</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control desktop</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Phone and Modem Options</td>
<td style="text-align: center;">control /name Microsoft.PhoneAndModemOptions</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control telephon.cpl</td>
<td style="text-align: center;">Vista, XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Phone and Modem</td>
<td style="text-align: center;">control /name Microsoft.PhoneAndModem</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control telephon.cpl</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Power Options</td>
<td style="text-align: center;">control /name Microsoft.PowerOptions</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control powercfg.cpl</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Printers and Faxes</td>
<td style="text-align: center;">control printers</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Printers</td>
<td style="text-align: center;">control /name Microsoft.Printers</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control printers</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Problem Reports and Solutions</td>
<td style="text-align: center;">control /name Microsoft.ProblemReportsAndSolutions</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Programs and Features</td>
<td style="text-align: center;">control /name Microsoft.ProgramsAndFeatures</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control appwiz.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Recovery</td>
<td style="text-align: center;">control /name Microsoft.Recovery</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Region</td>
<td style="text-align: center;">control /name Microsoft.RegionAndLanguage</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">control intl.cpl</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">control international</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Region and Language</td>
<td style="text-align: center;">control /name Microsoft.RegionAndLanguage</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">control intl.cpl</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td style="text-align: center;">control international</td>
<td style="text-align: center;">7</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Regional and Language Options</td>
<td style="text-align: center;">control /name Microsoft.RegionalAndLanguageOptions</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control intl.cpl</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control international</td>
<td style="text-align: center;">Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">RemoteApp and Desktop Connections</td>
<td style="text-align: center;">control /name Microsoft.RemoteAppAndDesktopConnections</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Scanners and Cameras</td>
<td style="text-align: center;">control /name Microsoft.ScannersAndCameras</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control sticpl.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Scheduled Tasks</td>
<td style="text-align: center;">control schedtasks</td>
<td style="text-align: center;">XP<sup>7</sup></td>
</tr>
<tr>
<td style="text-align: center;">Screen Resolution</td>
<td style="text-align: center;">control desk.cpl</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Security Center</td>
<td style="text-align: center;">control /name Microsoft.SecurityCenter</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control wscui.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Software Explorers<sup>8</sup></td>
<td style="text-align: center;">msascui.exe<sup>9</sup></td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td rowspan="3" style="text-align: center;" data-valign="top">Sound</td>
<td style="text-align: center;">control /name Microsoft.Sound</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">control /name Microsoft.AudioDevicesAndSoundThemes</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">control mmsys.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Sounds and Audio Devices</td>
<td style="text-align: center;">control mmsys.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Speech Recognition Options</td>
<td style="text-align: center;">control /name Microsoft.SpeechRecognitionOptions</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Speech Recognition</td>
<td style="text-align: center;">control /name Microsoft.SpeechRecognition</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td style="text-align: center;">Speech</td>
<td style="text-align: center;">control sapi.cpl<sup>10</sup></td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Storage Spaces</td>
<td style="text-align: center;">control /name Microsoft.StorageSpaces</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">Sync Center</td>
<td style="text-align: center;">control /name Microsoft.SyncCenter</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">System</td>
<td style="text-align: center;">control /name Microsoft.System</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control sysdm.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">System Properties</td>
<td style="text-align: center;">control sysdm.cpl</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Tablet PC Settings</td>
<td style="text-align: center;">control /name Microsoft.TabletPCSettings</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Task Scheduler<sup>7</sup></td>
<td style="text-align: center;">control schedtasks</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Taskbar</td>
<td style="text-align: center;">control /name Microsoft.Taskbar</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">rundll32.exe shell32.dll,Options_RunDLL 1</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Taskbar and Start Menu</td>
<td style="text-align: center;">control /name Microsoft.TaskbarAndStartMenu</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">rundll32.exe shell32.dll,Options_RunDLL 1</td>
<td style="text-align: center;">7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Text to Speech</td>
<td style="text-align: center;">control /name Microsoft.TextToSpeech</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Troubleshooting</td>
<td style="text-align: center;">control /name Microsoft.Troubleshooting</td>
<td style="text-align: center;">8, 7</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">User Accounts</td>
<td style="text-align: center;">control /name Microsoft.UserAccounts</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control userpasswords</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Welcome Center</td>
<td style="text-align: center;">control /name Microsoft.WelcomeCenter</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows 7 File Recovery</td>
<td style="text-align: center;">control /name Microsoft.BackupAndRestore</td>
<td style="text-align: center;">8</td>
</tr>
<tr>
<td style="text-align: center;">Windows Anytime Upgrade</td>
<td style="text-align: center;">control /name Microsoft.WindowsAnytimeUpgrade</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Windows CardSpace</td>
<td style="text-align: center;">control /name Microsoft.CardSpace</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control infocardcpl.cpl</td>
<td style="text-align: center;">7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows Defender</td>
<td style="text-align: center;">control /name Microsoft.WindowsDefender</td>
<td style="text-align: center;">8, 7, Vista<sup>11</sup></td>
</tr>
<tr>
<td rowspan="2" style="text-align: center;" data-valign="top">Windows Firewall</td>
<td style="text-align: center;">control /name Microsoft.WindowsFirewall</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">control firewall.cpl</td>
<td style="text-align: center;">8, 7, Vista, XP</td>
</tr>
<tr>
<td style="text-align: center;">Windows Marketplace</td>
<td style="text-align: center;">control /name Microsoft.GetProgramsOnline</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows Mobility Center</td>
<td style="text-align: center;">control /name Microsoft.MobilityCenter</td>
<td style="text-align: center;">8, 7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows Sidebar Properties</td>
<td style="text-align: center;">control /name Microsoft.WindowsSidebarProperties</td>
<td style="text-align: center;">Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows SideShow</td>
<td style="text-align: center;">control /name Microsoft.WindowsSideShow</td>
<td style="text-align: center;">8,7, Vista</td>
</tr>
<tr>
<td style="text-align: center;">Windows Update</td>
<td style="text-align: center;">control /name Microsoft.WindowsUpdate</td>
<td style="text-align: center;">8, 7, Vista<sup>12</sup></td>
</tr>
<tr>
<td style="text-align: center;">Wireless Link</td>
<td style="text-align: center;">control irprops.cpl</td>
<td style="text-align: center;">XP</td>
</tr>
<tr>
<td style="text-align: center;">Wireless Network Setup Wizard</td>
<td style="text-align: center;">?</td>
<td style="text-align: center;">XP</td>
</tr>
</tbody>
</table>

\[1\] Color is not available by default but is available for free from Microsoft here. \[2\] WinColor.exe must be run from the C:Program FilesPro Imaging PowertoysMicrosoft Color Control Panel Applet for Windows XP folder. \[3\] I've listed Device Manager here because it's such a commonly used feature of Windows but please know that it is not a true Control Panel applet in Windows XP. See How To Open Windows XP Device Manager for more information. \[4\] The Mail applet is only available if a version of Microsoft Office Outlook is installed. \[5\] The control mlcfg32.cpl command must be run from the C:Programs FilesMicrosoft OfficeOfficeXX folder, replacing OfficeXX with the folder pertaining to the Microsoft Office version you have installed. \[6\] ODBC Data Source Administrator was removed from Control Panel after Windows XP but is still available from Administrative Tools. \[7\] In Windows 8, 7, and Vista, task scheduling is performed by Task Scheduler which is not directly accessible from Control Panel. However, executing this command in those versions of Windows will forward to Task Scheduler. \[8\] Software Explorers is the name for the Control Panel applet for Windows Defender, available for free from Microsoft here. \[9\] Msascui.exe must be run from the C:Program FilesWindows Defender folder. \[10\] The control sapi.cpl command must be run from the C:Program FilesCommon FilesMicrosoft SharedSpeech folder. \[11\] Windows Defender is available in Windows XP but the Control Panel applet is instead called Software Explorers. \[12\] Windows Update is also used in Windows XP but only via the Windows Update website, not via a Control Panel applet like in later versions of Windows. \[13\] In Windows 8, bthprops.cpl opens Devices in PC Settings which will list any Bluetooth Devices. In Windows 7, bthprops.cpl opens athe Bluetooth Devices list under Devices and Printers. In Windows Vista, bthprops.cpl opens a true Control Panel applet called Bluetooth Devices.
