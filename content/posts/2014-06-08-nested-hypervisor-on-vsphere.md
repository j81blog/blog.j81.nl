---
title: "Nested Hypervisor on vSphere"
date: 2014-06-08T08:43:14Z
categories:
  - "ESXi"
  - "Hyper-V"
  - "Microsoft"
  - "Uncategorized"
  - "VMware"
  - "vSphere"
aliases:
  - "/2014/06/08/nested-hypervisor-on-vsphere/"
---

VM Hardware version 9 or Higher VM Advanced settings add:

- vhv.enable = "true"
- hypervisor.cpuid.v0 = "FALSE" (Hyper-V)

And in vSphere Webclient enable "Expose hardware assisted virtualization to the guest OS" under CPU.
