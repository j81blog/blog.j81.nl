---
title: "VCSA 6 CLI Install"
date: 2015-06-21T12:15:31Z
categories:
  - "No Category"
  - "Uncategorized"
aliases:
  - "/2015/06/21/vcsa-6-cli-install/"
---

1\. Make sure a DNS A and PTR record exists for the VC and the ESXi hosts. 2. Create a installation parameter file. E.g. "example_embedded.json" 3. Run "vcsa-deploy \<your_json_file_location_and_name\>" E.g. "vcsa-deploy c:/temp/example_embedded.json" 4. Wait (20 a 30min) fot the message " Login as: Administrator@vsphere.local" appears "example_embedded.json" file:

``` default
{
    "__comments":
    [
        "This is J81 personalized template. Make sure a DNS A and PTR record exists for the VC"
    ],
 
    "deployment":
    {
        "esx.hostname":"<ESX FQDN or IP>",
        "esx.datastore":"<Datastore Naem for VC>",
        "esx.username":"root",
        "esx.password":"<ESX root Password>",
        "deployment.option":"tiny",
        "deployment.network":"<Portgroup Name>",
        "appliance.name":"<VC Hostname>",
        "appliance.thin.disk.mode":true
    },
 
    "vcsa":
    {
        "system":
        {
            "root.password":"<VC root Password>",
            "ssh.enable":true
        },
 
        "sso":
        {
            "password":"<Administrator@vsphere.local Password>",
            "domain-name":"vsphere.local",
            "site-name":"<SiteName>"
        },
     
        "networking":
                {
             
            "ip.family":"ipv4",
            "mode":"static",
            "ip":"<VC-IP>",
            "prefix":"<MASK BITS>",
            "gateway":"<GATEWAY>",
            "dns.servers":"<DNS IPs>",
            "system.name":"<VC FQDN>"
        }
    }   
}
```

 
