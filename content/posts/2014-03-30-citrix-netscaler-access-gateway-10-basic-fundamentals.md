---
title: "Citrix NetScaler Access Gateway 10 - Basic Fundamentals"
date: 2014-03-30T18:43:54Z
categories:
  - "Citrix"
  - "Netscaler"
  - "Uncategorized"
aliases:
  - "/2014/03/30/citrix-netscaler-access-gateway-10-basic-fundamentals/"
  - "/2014/03/30/citrix-netscaler-access-gateway-10-basic-fundamentals/feed/"
  - "/2014/03/30/citrix-netscaler-access-gateway-10-basic-fundamentals/feed/index.html"
---

## NetScaler Network Connections.

At a very high level, considering the actual NetScaler connections to the network, and because of the way that NetScaler functions and can be configured, the NetScaler should be considered a switch, and not a router/firewall. With a switch, you can configure the management IP address on an individual port, responding to just devices reachable through that port, or it can be configured to respond on all ports to devices reachable from every port. With the NetScaler, either in single arm or multi arm deployment scenarios, there is no need to tell the NetScaler that network X is on interface 1/1 and network Y is on interface 1/2 (you can if you wish to, or instructed to by the network security team, by tagging IP addresses to a defined NetScaler VLANs which have specific interfaces assigned), but generally, it will happily use the IP addresses it is configured with on the relevant interfaces. When the NetScaler receives a packet destined for one of its IP addresses, it knows that the network which defines that address is available through the interface on which the request was received. Please Note: I don't claim to be a NetScaler Guru, or to have the knowledge to make all the bells and whistles of the NetScaler sound into a polyphony, there are others on the Internet who can better provide you with that information. The information here is from my own observations during a standard two arm deployment of Virtual and Physical NetScaler 10 Access Gateways.

## NetScaler IP Address type definitions

There are a number of types of IP addresses which can be defined on the NetScaler, all of which have specific usages.

### NSIP - NetScaler IP Address

- The NetScaler IP (NSIP) address is the IP address at which you access the NetScaler for management purposes.
  - You must add this IP address when you configure the NetScaler for the first time.
  - You cannot remove the NSIP address.
- The NetScaler can have only one NSIP.
- The NSIP is also called the Management IP address.
- If you modify this address, you must reboot the NetScaler.

SNIP - NetScaler Subnet IP Address

- A subnet IP (SNIP) is similar in functionality to a MIP (defined later)
- A subnet IP (SNIP) address is used in connection management and server monitoring.
- It is not mandatory to specify a SNIP when you initially configure the NetScaler appliance.
- In a **multiple-subnet scenario**, the NetScaler IP (NSIP) address, the mapped IP (MIP) address, and the IP address of a server **CAN** exist on different subnets.
- To eliminate the need to configure additional routes on devices such as servers, you can configure subnet IP addresses (SNIPs) on the NetScaler
- With Use SNIP (USNIP) mode enabled, a SNIP is the source IP address of a packet sent from the NetScaler to the server, and the SNIP is the IP address that the server uses to access the NetScaler. This mode is enabled by default.
- When you add a SNIP, a route corresponding to the SNIP is added to the routing table. The NetScaler determines the next hop for a service from the routing table, and if the IP address of the hop is within the range of a SNIP, the NetScaler uses the SNIP to source traffic to the service.
- When multiple SNIPs cover the IP addresses of the next hops, the SNIPs are used in round robin manner.

### MIP - Mapped IP Address

- A Mapped IP address is similar in functionality to a MIP (defined above)
- Mapped IP addresses (MIP) are used for server-side connections.
- A MIP can be considered a default subnet IP (SNIP) address, because MIPs are used when a SNIP is not available or Use SNIP (USNIP) mode is disabled.
- If the mapped IP address is the first in the subnet, the NetScaler appliance adds a route entry, with this IP address as the gateway to reach the subnet
- You can create or delete a MIP during run time without rebooting the appliance.
- As an alternative to creating MIPs one at a time, you can specify a consecutive range of MIPs.

### VIP - Virtual IP Address

- The Virtual IP address is where the external users will be authenticated.
- A VIP is an IP address assigned to multiple domain names, servers or applications residing on a single server instead of connected to a specific server or network interface card (NIC) on a server
- Incoming data packets are sent to the VIP address which are routed to actual network interfaces.
- A server IP address depends on the Media Access Control (MAC) address of the attached NIC, and only one logical IP address may be assigned per card. However, VIP addressing enables hosting for several different applications and virtual appliances on a server with only one logical IP address.
- VIP have several variations and implementation scenarios, including Common Address Redundancy Protocol (CARP) and Proxy Address Resolution Protocol (Proxy ARP).
- VIPs are mostly used to consolidate resources through the allocation of one network interface per hosted application.
- It is also used for connection redundancy by providing alternative fail-over options on one machine; A VIP address may still be available if a computer or NIC fails, because an alternative computer or NIC replies to connections.
- A VIP is the only IP address which can be disabled, causing any attached devices or services to go down.

## NetScaler IP Address communication Usage

With the NetScaler, certain traffic will be sent using a specific type of IP address as the source address. Ensure that when you are deploying a NetScaler between firewall(s) that the correct traffic is permitted to run from the correct IP address.

- LDAP, RADIUS, and other authentication traffic will use the NetScaler IP (NSIP).
- DNS / WINS traffic will use the mapped IP (MIP) or Subnet IP (SNIP), depending on the route to the destination host.
- VPN Traffic (from the Access Gateway Enterprise Edition to internal resources) uses the MIP, SNIP, or Intranet IP depending on which configuration you have chosen.
- File System Portal, which is the “File Transfer” button on Access Gateway Enterprise Edition, uses the NSIP.
- If ICA PROXY is switched ON, the MIP or SNIP is used, depending on the route to the destination host.

### Example Firewall Rules

<table data-align="left">
<tbody>
<tr>
<td>Usage</td>
<td>Source</td>
<td>Target</td>
<td>Port Numbers</td>
</tr>
<tr>
<td>Management</td>
<td>Internal Network</td>
<td>NSIP Address</td>
<td>TCP 443 (HTTPS)TCP 80 (HTTP) TCP 22 (SSH) TCP 3008 (JAVA) TCP 3010 (JAVA)</td>
</tr>
<tr>
<td>External User Access</td>
<td>Client Machine / Internet</td>
<td>VIP Address</td>
<td>TCP 443 (HTTPS)</td>
</tr>
<tr>
<td>DNS Lookup</td>
<td>MIP / SNIP</td>
<td>DNS Server</td>
<td>TCP 53 (DNS)ICMP Echo (PING)</td>
</tr>
<tr>
<td colspan="4">DNS Servers MUST be PING-able to be reported as UP and for the NetScaler to use them.</td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td>Authentication -Active Directory / LDAP</td>
<td>NSIP</td>
<td>Domain Controller(s) / LDAP Server(s)</td>
<td>TCP 389 (LDAP) and/orTCP 636 (LDAPS)</td>
</tr>
<tr>
<td>Authentication -RADIUS</td>
<td>MIP / SNIP</td>
<td>RADIUS Server(s)</td>
<td>TCP 1812 (RADIUS)</td>
</tr>
<tr>
<td>NTP Time Sync</td>
<td>NSIP</td>
<td>Time Server</td>
<td>UDP 123 (NTP)</td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td>Citrix Edgesight Monitoring In</td>
<td>Internal Network / Edgesight Server</td>
<td>NSIP</td>
<td>TCP 9307 (Edgesight Agent)</td>
</tr>
<tr>
<td>Citrix Edgesight Monitoring Out</td>
<td>NSIP</td>
<td>Internal Network / Edgesight Server</td>
<td>TCP 9307 (Edgesight Agent)</td>
</tr>
<tr>
<td>SCOM Monitoring In</td>
<td>Internal Network / Management Server</td>
<td>NSIP</td>
<td>TCP 5723 (SCOM Agent)</td>
</tr>
<tr>
<td>SCOM Monitoring Out</td>
<td>NSIP</td>
<td>Internal Network / Management Server</td>
<td>TCP 5723 (SCOM Agent)</td>
</tr>
<tr>
<td colspan="4"></td>
</tr>
<tr>
<td>Web Interface Access</td>
<td>MIP / SNIP</td>
<td>Web Interface Server</td>
<td>TCP 443 (HTTPS)</td>
</tr>
<tr>
<td>Web Interface SSO Call Back</td>
<td>Web Interface Server</td>
<td>VIP</td>
<td>TCP 443 (HTTPS)</td>
</tr>
<tr>
<td>ICA / XenApp Access</td>
<td>MIP / SNIP</td>
<td>XenApp Servers</td>
<td>TCP 443 (HTTPS)TCP 1494 (Citrix ICA) TCP 2598 (Citrix ICA with session reliability)</td>
</tr>
<tr>
<td>Licence Server Access (If Needed)</td>
<td>NSIP</td>
<td>Licence Server</td>
<td>TCP 27001 (Citrix Licence)</td>
</tr>
</tbody>
</table>

## BackEnd Communications (MIP or SNIP)

The following are the different scenarios where a NetScaler appliance selects the IP address to initiate the backend server connections using a MIP or a SNIP (depending on which you are configured for).

### MIP and SNIP Address Available and USNIP Disabled

- A NetScaler appliance uses MIP address to open a backend server connections and SNIP addresses are not used.

### MIP and SNIP Address Available, USNIP Disabled, and SNIP is Bound to VLAN and L3 Interface

- A NetScaler appliance uses MIP address to open backend server connections and SNIP addresses are not used. SNIP address is used only for L3 connectivity.

### MIP and SNIP Address Available and USNIP Enabled

- A NetScaler appliance uses SNIP address to open backend server connections and MIP addresses are not used. If the MIP address is configured in the same subnet as that of SNIP address, then MIP address is also used.
- When you enable USNIP the NetScaler appliance selects the IP address. The appliance looks up for a route or subnet for the destination IP address and selects the IP address regardless of whether it is SNIP or MIP address.

### MIP and SNIP Address Available, USNIP Enabled, and SNIP is Bound to VLAN and L3 Interface

- A NetScaler appliance uses SNIP address to open backend server connections and MIP address is not used. The SNIP address is also used for L3 connectivity. If you configure the MIP address in the same subnet as that of SNIP address, then MIP address is also used.
- When you enable USNIP the NetScaler appliance selects the IP address. The appliance looks up for a route or subnet for the destination IP address and selects the IP address regardless of whether it is SNIP or MIP address.
- VLAN binding does not affect the source IP address selection.

[Source](http://www.hensby-peck.co.uk/blogs/40-citrix/netscaler/31-citrix-netscaler-10-basic-fundamentals.html?showall=1&limitstart=)
