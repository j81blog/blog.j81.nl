---
title: "Basic PowerShell start"
date: 2015-08-28T12:09:17Z
categories:
  - "PowerShell"
  - "Uncategorized"
aliases:
  - "/2015/08/28/basic-powershell-start/"
  - "/2015/08/28/basic-powershell-start/feed/"
  - "/2015/08/28/basic-powershell-start/feed/index.html"
---

``` powershell
<#
.SYNOPSIS  
    A summary
.DESCRIPTION  
    A more in depth description
.NOTES  
    Additional Notes
    File Name  : xx.ps1
    Author     : First Last - e@mail.com
    Requires   : ...
.LINK
    A hyper link
.EXAMPLE
    The first example
.EXAMPLE
    The second example
.PARAMETER xxx
    text
#>

[CmdletBinding()]
param (  
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)][int64] $xxx=42  
)  
  
#Script
```

 
