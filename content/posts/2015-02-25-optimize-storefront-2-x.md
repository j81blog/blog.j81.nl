---
title: "Optimize StoreFront 2.x"
date: 2015-02-25T13:58:53Z
lastmod: 2020-05-23T21:44:57Z
categories:
  - "Citrix"
  - "StoreFront 2.x"
  - "Uncategorized"
aliases:
  - "/2015/02/25/optimize-storefront-2-x/"
  - "/2015/02/25/optimize-storefront-2-x/feed/"
  - "/2015/02/25/optimize-storefront-2-x/feed/index.html"
---

# Socket Pooling.

In StoreFront we need to configgure socket polling in the config files, while in Web Interface we could configure this in the console. Storefront maintaines a pool of sockets instead of creating a socket each time a new user connects, when enabled it will give a better performance for SSL traffic. To change this, edit C:inetpubwwwrootCitrix\<STORE\>web.config (as Administrator) and find:

``` default
pooledSockets="off"
```

Change "off" to "on". When finished, save and reset IIS.

``` batch
IISReset
```

> NOTE: Make sure you change this on the "primary" StoreFront Member and replicate changes.

<a href="http://support.citrix.com/proddocs/topic/dws-storefront-26/dws-configure-conf-socket.html" target="_blank" rel="noopener noreferrer">http://support.citrix.com/proddocs/topic/dws-storefront-26/dws-configure-conf-socket.html</a>

# Application Initialization

In IIS 8 and up (Windows Server 2012) there is a feature called "AlwaysRunning" on the application pools. When active an application pool is loaded after a restart, before it was loaded when the first user tried to login. This could take a long time. This option can be set in the IIS GUI, default application pool settings.. For IIS 7.5 (Server 2008 R2) is this setting also available (not in the GUI) but only after applying an update. You need to change the config files manually to enable the "AlwaysRunning" function. Before continuing make sure you have a backup copy of all the files edited in this article. Download and install the update from: <a href="http://www.iis.net/downloads/microsoft/application-initialization" target="_blank" rel="noopener noreferrer" title="Application-Initialization">http://www.iis.net/downloads/microsoft/application-initialization</a>. Make sure to reboot after installation to continue. open the file ***C:WindowsSystem32inetsrvconfigapplicationHost.config*** (as Administrator) Find the following location: **configuration / system.applicationHost / applicationPools** Add the following to each applicationpool:

``` default
startMode="AlwaysRunning"
```

- Citrix Delivery Services
- Citrix Delivery Services Authentication
- Citrix Delivery Services Resources
- Citrix Receiver for Web

Example:

``` default
<system.applicationHost>

  <applicationPools>
    <add name="DefaultAppPool" />
    <add name="Classic .NET AppPool" managedPipelineMode="Classic" />
    <add name="ASP.NET v4.0" managedRuntimeVersion="v4.0" />
    <add name="ASP.NET v4.0 Classic" managedRuntimeVersion="v4.0" managedPipelineMode="Classic" />
    <add name="Citrix Delivery Services Authentication" autoStart="true" managedRuntimeVersion="v4.0" managedPipelineMode="Integrated" startMode="AlwaysRunning">
      <processModel identityType="ApplicationPoolIdentity" idleTimeout="00:00:00" />
      <cpu limit="0" action="NoAction" resetInterval="00:00:00" />
    </add>
    <add name="Citrix Delivery Services Resources" autoStart="true" managedRuntimeVersion="v4.0" managedPipelineMode="Integrated" startMode="AlwaysRunning">
      <processModel identityType="ApplicationPoolIdentity" idleTimeout="00:00:00" />
      <cpu limit="0" action="NoAction" resetInterval="00:00:00" />
    </add>
    <add name="Citrix Receiver for Web" autoStart="true" managedRuntimeVersion="v4.0" managedPipelineMode="Integrated" startMode="AlwaysRunning">
      <processModel identityType="ApplicationPoolIdentity" idleTimeout="00:00:00" />
      <cpu limit="0" action="NoAction" resetInterval="00:00:00" />
      <recycling>
        <periodicRestart time="00:00:00">
          <schedule>
            <add value="02:00:00" />
          </schedule>
        </periodicRestart>
      </recycling>
    </add>
```

Now find the following location: **configuration / system.applicationHost / sites** Add the following to each site:

``` default
preloadEnabled="true"
```

- /AGServices (ony when NetScaler Gateway is configured)
- /Citrix/Authentication
- /Citrix/Roaming
- /Citrix/\<STORE\>
- /Citrix/\<STORE\>Web
- /Citrix/PNAgent

Example:

``` default
<sites>
  <site name="Default Web Site" id="1">
    <application path="/">
      <virtualDirectory path="/" physicalPath="%SystemDrive%inetpubwwwroot" />
    </application>
    <application path="/Citrix/Authentication" applicationPool="Citrix Delivery Services Authentication" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootCitrixAuthentication" />
    </application>
    <application path="/Citrix/Roaming" applicationPool="Citrix Delivery Services Resources" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootCitrixRoaming" />
    </application>
    <application path="/AGServices" applicationPool="Citrix Delivery Services Resources" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootAGServices" />
    </application>
    <application path="/Citrix/Store" applicationPool="Citrix Delivery Services Resources" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootCitrixStore" />
    </application>
    <application path="/Citrix/PNAgent" applicationPool="Citrix Delivery Services Resources" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootCitrixPNAgent" />
    </application>
    <application path="/Citrix/StoreWeb" applicationPool="Citrix Receiver for Web" preloadEnabled="true">
      <virtualDirectory path="/" physicalPath="C:inetpubwwwrootCitrixStoreWeb" />
      <virtualDirectory path="/clients" physicalPath="C:Program FilesCitrixReceiver StoreFrontReceiver Clients" />
    </application>
```

When finished, save and reset IIS, make sure the service is started and no errors are visible in the Windows Event Viewer.

``` batch
IISReset
```

>  NOTE: Make sure you change this on each StoreFront Member.

  ***Only edit the following on the primary StoreFront server!*** Now edit each of the following web.config-files:

- C:inetpubwwwrootAGServicesweb.config
- C:inetpubwwwrootCitrixAuthenticationweb.config
- C:inetpubwwwrootCitrixPNAgentweb.config
- C:inetpubwwwrootCitrixRoamingweb.config
- C:inetpubwwwrootCitrix\<STORE\>web.config

Add to the section: **/ configuration / system.webServer**

``` default
<applicationInitialization skipManagedModules="true">
  <add initializationPage="/endpoints/v1"/>
</applicationInitialization>
```

Edit each "StoreWeb" web.config-file

- C:inetpubwwwrootCitrix\<STORE\>Webweb.config

Add to the section: **/ configuration / system.webServer**

``` default
<applicationInitialization skipManagedModules="true">
  <add initializationPage="/Home/Index" />
</applicationInitialization>
```

When finished, test it before you propagate the changes to the other member(s).

> NOTE: Don't forget to propagate the changes when finished!

<a href="http://support.citrix.com/article/CTX137400" target="_blank" rel="noopener noreferrer" title="How to Configure IIS to Optimize Receiver for Web Initial Connection">http://support.citrix.com/article/CTX137400</a>

# Disable CRL Check

CRL checking can add an extra delay while loading StoreFront to disable this edit the following files: 32-bit & 64-bit:

- C:WindowsMicrosoft.NETFrameworkv2.0.50727Aspnet.config
- C:WindowsMicrosoft.NETFrameworkv4.0.30319Aspnet.config

64-bit only:

- C:WindowsMicrosoft.NETFramework64v2.0.50727\Aspnet.config
- C:WindowsMicrosoft.NETFrameworkv4.0.30319Aspnet.config

Add to the section: **/ configuration / runtime**

``` default
<generatePublisherEvidence enabled="false"/>
```

Example:

``` default
<?xml version="1.0" encoding="UTF-8" ?>
<configuration>
    <runtime>
        <legacyUnhandledExceptionPolicy enabled="false" />
        <legacyImpersonationPolicy enabled="true"/>
        <alwaysFlowImpersonationPolicy enabled="false"/>
        <SymbolReadingPolicy enabled="1" />
        <generatePublisherEvidence enabled="false"/>
    </runtime>
</configuration>
```

When finished, save and reset IIS.

``` batch
IISReset
```

> NOTE: Make sure you change this on each StoreFront Member.

<a href="http://support.citrix.com/article/CTX139486" target="_blank" rel="noopener noreferrer">http://support.citrix.com/article/CTX139486</a>   Good luck!
