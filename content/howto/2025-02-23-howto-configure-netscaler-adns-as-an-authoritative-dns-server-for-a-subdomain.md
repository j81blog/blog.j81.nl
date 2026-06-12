---
group: "NetScaler"
title: "HowTo - Configure NetScaler ADNS as an Authoritative DNS Server for a Subdomain"
date: 2025-02-23T19:24:49Z
lastmod: 2025-02-23T19:24:52Z
categories:
  - "ADC"
  - "Citrix"
  - "DNS"
  - "Netscaler"
  - "PowerShell"
tags:
  - "ADC"
  - "Citrix"
  - "Citrix ADC"
  - "DNS"
  - "HowTo"
  - "NetScaler"
aliases:
  - "/howto-configure-netscaler-adns-as-an-authoritative-dns-server-for-a-subdomain/"
---

In this HowTo article, we’ll walk through the complete process of configuring a Citrix NetScaler HA pair to serve as an authoritative DNS server for a subdomain. This step-by-step guide covers everything from setting up the Authoritative DNS (ADNS) service on the NetScaler to delegating the subdomain in the parent domain’s DNS management panel. Whether you’re looking to improve DNS resolution performance, gain more control over DNS records, or support advanced NetScaler features, this guide will help you get it done efficiently and securely.

## What is Authoritative DNS?

The authoritative DNS server plays a crucial role in the process of translating a domain name into an IP address—the unique identifier that computers use to communicate over the internet. Think of it as the ultimate source of truth for the domain you’re trying to reach.

When you type a domain name (like example.com) into your browser, your device sends a DNS query to your internet service provider (ISP). The ISP typically operates a recursive DNS server, which is like a middleman. This recursive server checks if it already knows the answer—maybe it has the IP address cached from a previous request. If it doesn’t, or the cached data is outdated, it needs to track down the correct answer.

The recursive server then starts a journey across the DNS hierarchy, asking other servers for the answer. It may query root servers, top-level domain (TLD) servers (like .com or .net), and eventually, if it hasn’t found the answer yet, it ends up at the authoritative DNS server.

This is where the authoritative DNS server comes in. Unlike recursive servers, authoritative DNS servers don’t go looking for answers elsewhere. Instead, they provide definitive responses based on the zone records they store. These records—such as **A (Address)**, **AAAA (IPv6 Address)**, **CNAME (Canonical Name)**, **NS (Name Server)**, and **SOA (Start of Authority), etc.** — have been configured by the domain administrator and represent the original source of truth for that domain.

Because authoritative servers only answer queries about the specific zones they manage and don’t perform recursion, they’re highly efficient and fast. They either provide the complete answer directly or, if another server is responsible for a part of the zone, they refer the resolver to that server.

In simpler terms, if the DNS system were a kingdom, the authoritative DNS server would be the ruler who has the final say—issuing the definitive address when asked where a particular "house" (domain) is located. The recursive servers are like messengers running around the kingdom gathering information, but ultimately, it’s the authoritative server that confirms the right answer.

Understanding this process is key when configuring your own DNS infrastructure, ensuring users can reliably and quickly access your services online.

## How does it work?

<figure class="wp-block-image aligncenter">
<img src="/wp-content/uploads/2025/02/Authoritative-DNS-1.jpg" class="wp-image-1369" />
</figure>

- **Local DNS Server Check:**\
  The process begins when the client asks its locally configured DNS server (1) for the IP address of a.adns.it-framework.nl. If the local server has this information cached, it will return the IP address immediately. However, if it doesn’t, it will forward the request to a root server (2).
- **Root Server Response:**\
  The root server doesn’t know the complete path to a.adns.it-framework.nl, but it does know where to find the top-level domain (TLD) .com. Therefore, it responds with the location of the .com DNS servers (3).
- **TLD DNS Server Query:**\
  The local DNS server now sends the request to one of the .com DNS servers (4). This server doesn’t have the full answer either but knows which name server manages it-framework.nl. It returns the IP address of the authoritative name server responsible for it-framework.nl (5).
- **Domain DNS Server Query:**\
  Next, the request is forwarded to the DNS server at the hosting provider where it-framework.nl is managed (6). Typically, this server would respond with the IP address for a.adns.it-framework.nl.\
  However, in this case, because we’re configuring a NetScaler to be authoritative for the adns.it-framework.nl subdomain, the hosting provider’s DNS server will instead respond with the IP address of the NetScaler instance responsible for that zone.
- **NetScaler Query for Final Record:**\
  The local DNS server now sends a query directly to the NetScaler (7), asking for the IP address of a.adns.it-framework.nl. Since the NetScaler is configured as authoritative for adns.it-framework.nl and the A record for a exists, it provides the final IP address in response (8).
- **Final Response to the Client:**\
  The local DNS server relays this final IP address back to the client, completing the resolution process.

## How to configure it?

### NetScaler configuration

In the next steps we will explain how to configure the NetScaler to be authoritative for a certain zone. We'll start with logging in on the NetScaler, and add a SubNet IP address (SNIP) that we will use as the DNS entrypoint.

In the relevant steps we'll add the NetScaler Command line wit the same action.

Go to **System** / **Network** / **IPs** and click **Add**.

<figure class="wp-block-image aligncenter">
<img src="/wp-content/uploads/2025/02/ADNS001.png" class="wp-image-1371" alt="Add IP" />
</figure>

Add the IP Address you want to use for your DNS entry point. Set the Type as **Subnet IP**.

- **IP Address**: 10.254.0.10 *(configure your Subnet IP here)*
- **Netmask**: 255.255.255.0 *(the Subnet Mask belonging to the configured IP address)*
- **IP Type**: Subnet IP

<figure class="wp-block-image aligncenter">
<img src="/wp-content/uploads/2025/02/ADNS002.png" class="wp-image-1372" alt="Add SNIP" />
</figure>

``` text
# NetScaler CLI:
add ns ip 10.254.0.10 255.255.255.0 -type SNIP
```

Next go to **Traffic Management** / **Load Balancing** / **Servers** click on the **Add** button to add a server object.

- **Name**: srv_adns *(or a different name depending on your naming convention)*
- **IP Address**: 10.254.0.10 *(use the same address as setup for the SNIP)*
- **Enable after Creating**: Enabled *(default)*
- **Comments**: SNIP used for ADNS *(this step is optional)*

<figure class="wp-block-image aligncenter">
<img src="/wp-content/uploads/2025/02/ADNS003.png" class="wp-image-1374" alt="Add server" />
</figure>

``` text
# NetScaler CLI:
add server srv_adns 10.254.0.10 -comment "SNIP used for ADNS"
```

When the server is added, go to **Traffic Management** / **Load Balancing** / **Services** and click **Add**.

- **Service Name**: svc_adns *(or a different name depending on your naming convention)*
- **Existing Server**: Selected
- **Server**: srv_adns *(select your earlier created server)*
- **Protocol**: ADNS
- **Port**: 53

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS004.png" class="wp-image-1375" alt="Add service" />
</figure>

``` text
# NetScaler CLI:
add service svc_adns srv_adns ADNS 53
```

When you are at this step you have created the ADNS listner, the NetScaler is now listing at port 53 on your configured IP address. When you go back to **System** / **Network** / **IPs**, you will see that an extra type **ADNS svc IP** was added next to **Subnet IP**.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS005.png" class="wp-image-1376" alt="ADNS Check" />
</figure>

Next we will create the Authoritative Zone on the NetScaler.

Go to **Traffic Management** / **DNS** / **Zones** and click on the **Add** button.

- **DNS Zone**: adns.it-framework.nl\
  The Zone name you want the NetScaler to be Authoritative for.
- **Proxy Mode**: Enabled\
  This is default enabled.

Click **Create**.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS006.png" class="wp-image-1377" alt="Create Zone" />
</figure>

``` text
# NetScaler CLI:
add dns zone adns.it-framework.nl -proxyMode YES
```

Now we must add a SOA record.

The DNS ‘start of authority’ (SOA) record stores important information about a domain or zone such as the email address of the administrator, when the domain was last updated, and how long the server should wait between refreshes. All DNS zones need an SOA record in order to conform to IETF standards.

Go to **Traffic Management** / **DNS** / **Records** / **SOA** **Records**, and click on the **Add** button. Next add the details:

- **Domain Name**: adns.it-framework.nl\
  Domain name for which to add the SOA record.
- **Origin Server**: it-framework.nl\
  Domain name of the name server that responds authoritatively for the domain.
- **Contact**: domainadmin.it-framework.nl\
  Email address of the contact to whom domain issues can be addressed. In the email address, replace the @ sign with a period (.). In my case domainadmin@it-framework.nl =\> domainadmin.it-framework.nl

The rest I will leave default, but if you want you can adjust it to your needs.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS007.png" class="wp-image-1378" alt="Create SOA record" />
</figure>

``` text
# NetScaler CLI:
add dns soaRec adns.it-framework.nl -originServer it-framework.nl -contact domainadmin.it-framework.nl
```

Basically the NetScaler portion of the config is ready. We still need to add records to the zone for now we add one, a test record so we can validate our setup later on if the rest is also configured.

Go to **Traffic Management** / **DNS** / **Records** / **TXT Records** and click the **Add** button.

- **Domain**: test.adns.it-framework.nl\
  The name of the record you want to add to the zone
- **Text**: "Test succeeded"\
  You can add here what you want, just something so we can test it later on.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS009.png" class="wp-image-1379" alt="Add TXT record" />
</figure>

``` text
# NetScaler CLI:
add dns txtRec test.dns.it-framework.nl "Test succeeded" -TTL 5
```

To verify, check the zone—it should now contain two records: an SOA record and a TXT record.

Go to Traffic **Management** / **DNS** / **Zones** and click on the Zone you created earlier and validate the records.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS011.png" class="wp-image-1382" alt="Verify zone" />
</figure>

Now it's a good time to hit the save button to make sure everything is saved and will not be lost when a reboot  or shutdown happens.

``` text
# NetScaler CLI:
save ns config
```

### Firewall configuration

To enable the NetScaler to respond to requests from the internet, you need to configure Port Forwarding (NAT) to make port 53 (TCP/UDP) accessible externally.

<table style="border-collapse: collapse; width: 100%; height: 120px;">
<tbody>
<tr style="height: 40px;">
<td style="text-align: center; width: 5.11908%; height: 40px;"><strong>Type</strong></td>
<td style="width: 13.6905%; height: 40px"><strong>Source</strong></td>
<td style="width: 12.9762%; height: 40px"><strong>Destination</strong></td>
<td style="text-align: center; width: 5.83338%; height: 40px;"><strong>Port</strong></td>
<td style="text-align: center; width: 10.9524%; height: 40px;"><strong>Protocol</strong></td>
<td style="width: 51.4286%; height: 40px"><strong>Description</strong></td>
</tr>
<tr style="height: 40px;">
<td style="text-align: center; width: 5.11908%; height: 40px;">NAT</td>
<td style="width: 13.6905%; height: 40px">SNIP (ADNS)</td>
<td style="width: 12.9762%; height: 40px">Internet/WAN</td>
<td style="text-align: center; width: 5.83338%; height: 40px;">53</td>
<td style="text-align: center; width: 10.9524%; height: 40px;">TCP/UDP</td>
<td style="width: 51.4286%; height: 40px">Forwarding port 53 to Internet</td>
</tr>
<tr style="height: 40px;">
<td style="text-align: center; width: 5.11908%; height: 40px;">ACL</td>
<td style="width: 13.6905%; height: 40px">Internet/WAN</td>
<td style="width: 12.9762%; height: 40px">Your Public IP</td>
<td style="text-align: center; width: 5.83338%; height: 40px;">53</td>
<td style="text-align: center; width: 10.9524%; height: 40px;">TCP/UDP</td>
<td style="width: 51.4286%; height: 40px">Make sure port 53 is accessible from the internet</td>
</tr>
</tbody>
</table>

### DNS configuration

The exact steps may vary depending on your DNS hosting provider. Since not all providers use the same interface or configuration options, you’ll need to determine how this example applies to your specific setup.

We will add two records, one A and one NS record.

***A-Record***:

- **Name**: ns1 *(a name we used, you may choose a different one if you want)*
- **Type**: A
- **Content**: 3.3.3.3 *(in your case, the public IP address where the DNS listener is configured.) *
- **TTL**: Time To Live, we leave this default

***NS-Record***:

- **Name**: adns *(the zone we created on the NetScaler)*
- **Type**: NS (Name Server)
- **Content**: ns1.it-framework.nl *(or a different name, depending what A-record you created)*
- **TTL**: Time To Live, we leave this default

Make sure to save everything when ready.

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS010.png" class="wp-image-1381" alt="Configure DNS" />
</figure>

### Testing!

Now it's time to test everything to see if it's working as expected. We can easily use PowerShell for this task. We will try to resolve out TXT record, this must return our configured value (if all goes as planned).

``` text
# PowerShell
Resolve-DnsName -Name test.adns.it-framework.nl -Type TXT
```

<figure class="wp-block-image aligncenter size-full">
<img src="/wp-content/uploads/2025/02/ADNS012.png" class="wp-image-1383" alt="Verify via PowerShell" />
</figure>

As you can see, our setup returns the expected value.

Hopefully this HowTo guide was helpful. Please let me know if you have any questions.
