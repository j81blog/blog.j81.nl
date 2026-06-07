---
title: "Citrix Access Gateway Enterprise Port Configuration"
date: 2014-03-30T19:08:51Z
categories:
  - "Citrix"
  - "Netscaler"
  - "Uncategorized"
aliases:
  - "/2014/03/30/citrix-access-gateway-enterprise-port-configuration/"
  - "/2014/03/30/citrix-access-gateway-enterprise-port-configuration/feed/"
  - "/2014/03/30/citrix-access-gateway-enterprise-port-configuration/feed/index.html"
---

I have put together this blog post about Citrix Access Gateway Enterprise Port Configuration to assist people in setting up their firewalls for implementing Access Gateway in one-arm mode. I have found that almost all of Citrix’s documentation covers the Access Gateway / NetScaler straddling the DMZ and the Internal LAN E.G the VIP sits in the DMZ and the SNIP sits in the internal LAN. In Enterprise deployments firewalls are firewalls and NetScalers are NetScalers and security do not like NetScalers trying to be firewalls; although I’m sure they do perfectly fine job of it. So the below article describes what firewall rules you will need to have in place to get a NetScaler working when all its interfaces reside in the DMZ (one-arm single subnet). You should find the diagram useful even if you are not using the model described above. This is a diagram I like to use to explain NetScalers in an HA pair. It shows all the possible routes that traffic could take, not the way traffic flows during normal operation. The VIP and SNIP “float” between the two devices, in reality they exist on both devices but at any given time are only active on whichever node is the primary in the HA pair. ![](//www.shaunritchie.co.uk/wp-content/uploads/2012/03/Final-AGEE2.jpg)

<table data-border="1" data-cellspacing="0" data-cellpadding="0">
<tbody>
<tr>
<td data-valign="top" width="113"><p><strong>Source IP</strong></p></td>
<td data-valign="top" width="113"><p><strong>Destination IP</strong></p></td>
<td data-valign="top" width="105"><p><strong>Protocol</strong></p></td>
<td data-valign="top" width="101"><p><strong>Port</strong></p></td>
<td data-valign="top" width="171"><p><strong>Function</strong></p></td>
</tr>
<tr>
<td data-valign="top" width="113">Client IPs</td>
<td data-valign="top" width="113">Access Gateway VIP</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">443</td>
<td data-valign="top" width="171">Secure traffic from internet clients to AGEE VIP</td>
</tr>
<tr>
<td data-valign="top" width="113">NetScaler NSIP</td>
<td data-valign="top" width="113">LDAP Servers <sup>1</sup></td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">389</td>
<td data-valign="top" width="171">LDAP authentication traffic from NetScaler IP to LDAP servers.</td>
</tr>
<tr>
<td data-valign="top" width="113">NetScaler NSIP</td>
<td data-valign="top" width="113">RADIUS servers</td>
<td data-valign="top" width="105">TCP/UDP</td>
<td data-valign="top" width="101">1812</td>
<td data-valign="top" width="171">RADIUS traffic from Access Gateway to RADIUS server (for RSA dual factor authentication)</td>
</tr>
<tr>
<td data-valign="top" width="113">NetScaler VIP<sup>2</sup></td>
<td data-valign="top" width="113">DNS Servers</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">53</td>
<td data-valign="top" width="171">DNS traffic from VIP to DNS servers</td>
</tr>
<tr>
<td data-valign="top" width="113">NetScaler SNIP</td>
<td data-valign="top" width="113">Web Interface Servers</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">80/443<sup>3</sup></td>
<td data-valign="top" width="171">Traffic from Access Gateway to Web Interface servers</td>
</tr>
<tr>
<td data-valign="top" width="113">Web Interface Servers</td>
<td data-valign="top" width="113">Access Gateway VIP</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">443</td>
<td data-valign="top" width="171">Web Interface call back traffic to Access Gateway VIP<sup>4</sup></td>
</tr>
<tr>
<td data-valign="top" width="113">NetScaler SNIP</td>
<td data-valign="top" width="113">All XenApp session host servers and all XenDesktop Desktops (virtual, physical etc)</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">1494 &amp; 2598<sup>6</sup></td>
<td data-valign="top" width="171">ICA traffic from the Access Gateway to all Citrix XenApp or XenDesktop endpoints</td>
</tr>
<tr>
<td data-valign="top" width="113">Management Server</td>
<td data-valign="top" width="113">NetScaler SNIP</td>
<td data-valign="top" width="105">TCP</td>
<td data-valign="top" width="101">80/3010</td>
<td data-valign="top" width="171">Console and Java Applet traffic to NetScaler (for management</td>
</tr>
</tbody>
</table>

    1.       In most cases these will be your Active Directory domain controllers – always use more than one. 2.       Normally this comes from the NSIP but due to the fact that ICMP is used to verify if the DNS servers are available the DNS servers will show as down unless your security team allow ICMP through the firewall which is very unlikely. Therefore, setup an internal DNS load balancer with a DNS lookup monitor and point your NetScalers at the internal load balancer. 3.       Normally port 80. Port 443 if you secure your Web Interface servers with a certificate 4.       Ensure that from a browser on your Web Interface server you can type the FQDN of the AGEE and get the logon page with **NO** errors 5.       Normally port 80. Port 443 if you secure your Web Interface servers with a certificate. 6.        Port 2598 is for session reliability Remember that if you have your NetScalers configured in an HA pair traffic originating from the NSIP can come from either NetScaler depending on which one is hosting the AGEE VIP at the time. For anything that comes from the NSIP you can load balance it using a VIP if you want the traffic to originate from one IP. [Source](http://www.shaunritchie.co.uk/citrix-access-gateway-enterprise-port-configuration)
