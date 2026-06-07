---
title: "VSA change MAC vSphere 5.1"
date: 2013-11-03T16:03:22Z
categories:
  - "P4000"
  - "Uncategorized"
  - "VSA"
  - "vSphere"
aliases:
  - "/2013/11/03/vsa-change-mac-vsphere-5-1/"
  - "/2013/11/03/vsa-change-mac-vsphere-5-1/feed/"
  - "/2013/11/03/vsa-change-mac-vsphere-5-1/feed/index.html"
---

1.  edit the vmx file **/vmfs/volumes/50bf4d82-31b73571-5543-001e4f378eac/MAS \# vi MAS.vmx**
2.  ensure you are using generated MACs: **ethernet0.addressType = "generated"** **ethernet1.addressType = "generated"**
3.  edit these 3 lines to reflect the MAC you want. this  assumes you want to use one of the "VMWARE automagic (00:0c:29)" ones, notice the last 6 chars of the first two lines match the last 3 octets of your MAC **uuid.location = "56 4d 74 53 f4 52 bf 03-02 fb 39 13 6b 2b 6c fc"** **uuid.bios = "56 4d 74 53 f4 52 bf 03-02 fb 39 13 6b 2b 6c fc"** **ethernet0.generatedAddress = "00:0c:29:2b:6c:fc"**
4.  if you want ethernet1 to match something specific instead, you need to subtract 10 (0x0A) from the last octet of the ethernet0 MAC because of this line: **ethernet1.generatedAddressOffset = "10"**
5.  This will create ethernet1's MAC with a value of 10 more than ethernet0. I didn't play around with different values here, but presumably you could calculate & edit this number to get both MACs to match your needs.
6.  remove the VM from inventory, and re-import it (by browsing the datastore to the vmx file)
7.  When starting the VM, answer "I moved it" to the dialog box asking about what happened to your machine
