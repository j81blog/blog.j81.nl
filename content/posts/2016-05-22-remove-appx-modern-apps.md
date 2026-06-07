---
title: "Remove AppX (Modern) Apps"
date: 2016-05-22T07:47:15Z
categories:
  - "Optimization"
  - "PowerShell"
  - "Uncategorized"
  - "Windows"
aliases:
  - "/2016/05/22/remove-appx-modern-apps/"
  - "/2016/05/22/remove-appx-modern-apps/feed/"
  - "/2016/05/22/remove-appx-modern-apps/feed/index.html"
---

With the following PowerShell script you can remove AppX Apps in Windows 8(.1) and 10. **Note**: The apps will be removed for the <span style="text-decoration: underline;">**Current**</span> and <span style="text-decoration: underline;">**New**</span> users only!

``` powershell
<#
    To skip a AppX app while removing change "Remove" to "NoChange", the app will not be removed.
#>
$arrAppxApps = @()
$arrAppxApps += ,@('Remove','6.4|10.0','*3DBuilder*')                           # Uninstall 3D Builder
$arrAppxApps += ,@('Remove','6.4|10.0','*Appconnector*')                        # Uninstall 
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*bingfinance*')                 # Uninstall Money
$arrAppxApps += ,@('Remove','6.2|6.3','*BingFoodAndDrink*')                     #
$arrAppxApps += ,@('Remove','6.2|6.3','*BingHealthAndFitness*')                 #
$arrAppxApps += ,@('Remove','6.2|6.3','*BingMaps*')                             #
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*bingnews*')                    # Uninstall News
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*bingsports*')                  # Uninstall Sports
$arrAppxApps += ,@('Remove','6.2|6.3','*BingTravel*')                           #
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*bingweather*')                 # Uninstall Weather
$arrAppxApps += ,@('Remove','6.2|6.3','*Camera*')                               #
$arrAppxApps += ,@('Remove','6.2|6.3','*OneDrive*')                             #
$arrAppxApps += ,@('Remove','6.4|10.0','*getstarted*')                          # Uninstall Get Started
$arrAppxApps += ,@('Remove','6.2|6.3','*HelpAndTips*')                          #
$arrAppxApps += ,@('Remove','6.4|10.0','*officehub*')                           # Uninstall Get Office
$arrAppxApps += ,@('Remove','6.4|10.0','*solitairecollection*')                 # Uninstall Microsoft Solitaire Collection
$arrAppxApps += ,@('Remove','6.2|6.3','*Media.PlayReadyClient.2*')              # 2x
$arrAppxApps += ,@('Remove','6.2|6.3','*Media.PlayReadyClient.2*')              #
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*onenote*')                     # Uninstall OneNote
$arrAppxApps += ,@('Remove','6.4|10.0','*people*')                              # Uninstall People
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*skypeapp*')                    # Uninstall Get Skype
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*photos*')                      # Uninstall Photos
$arrAppxApps += ,@('Remove','6.2|6.3','*Reader*')                               #
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*windowsalarms*')               # Uninstall Alarms and Clock
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*windowscalculator*')           # Uninstall Calculator
$arrAppxApps += ,@('Remove','6.4|10.0','*windowscamera*')                       # Uninstall Camera
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*windowscommunicationsapps*')   # Uninstall Calendar and Mail
$arrAppxApps += ,@('Remove','6.4|10.0','*windowsmaps*')                         # Uninstall Maps
$arrAppxApps += ,@('Remove','6.4|10.0','*windowsphone*')                        # Uninstall Phone Companion
$arrAppxApps += ,@('Remove','6.2|6.3','*WindowsReadingList*')                   #
$arrAppxApps += ,@('Remove','6.4|10.0','*soundrecorder*')                       # Uninstall Voice Recorder
$arrAppxApps += ,@('Remove','6.2|6.3','*WindowsScan*')                          #
$arrAppxApps += ,@('Remove','6.4|10.0','*windowsstore*')                        # Uninstall Store
$arrAppxApps += ,@('Remove','6.4|10.0','*xboxapp*')                             # Uninstall Xbox
$arrAppxApps += ,@('Remove','6.2|6.3','*XboxLIVEGames*')                        #
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*zunemusic*')                   # Uninstall Groove Music
$arrAppxApps += ,@('Remove','6.2|6.3|6.4|10.0','*zunevideo*')                   # Uninstall Movies & TV

Write-Host -ForegroundColor White "Removing Appx Apps"
Write-Verbose ''    
foreach ($AppxApp in $arrAppxApps) {
    Write-Host -NoNewline -ForegroundColor Gray " -" $AppxApp[2]
    Switch ($AppxApp[0]) {
        "NoChange" {
            Write-Host -ForegroundColor Yellow " (skipped) No changes made"
        }
        "Remove" {
            if ($AppxApp[1] -Match ($varWinVer)) {
                Try {
                    Get-AppxPackage | Where-Object {$_.PackageFullName -like $AppxApp[2]} | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
                    Get-AppxPackage -allusers | Where-Object {$_.PackageFullName -like $AppxApp[2]} | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
                    Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like $AppxApp[2]} | Remove-ProvisionedAppxPackage -Online -ErrorAction SilentlyContinue | Out-Null
                } Catch {
                    Write-Host -ForegroundColor Red (" (error)")
                    $FailedItem = $_.Exception.ItemName
                    Write-Verbose ('Caught an error')
                    Write-Verbose ('ErrorMessage: ' + $ErrorMessage)
                    Write-Verbose ('FailedItem: ' + $FailedItem)
                    continue
                } Finally {
                    Write-Host -ForegroundColor Green (" (done)")
                }

            } Else { Write-Host -ForegroundColor Yellow " (skipped) not applicable to this OS" }
            
        }

    }
}
```

 
