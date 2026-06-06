---
title: "Firmware for individual components"
date: 2013-05-31T13:39:49Z
categories:
  - "HP"
  - "P4000"
  - "Uncategorized"
aliases:
  - "/2013/05/31/firmware-for-individual-components/"
---

- Before upgrading any individual components, check the latest compatibility matrix ( in attachment )
- Check if a SAN/iQ patch is available for your firmware. This method is always preferred.
- Download the Smart Update Firmware DVD 10.10
- If additional files need to be added to the Smart Firmware DVD, download the HP USB Key Utility for Windows to create a bootable USB stick instead.

<!-- -->

- Update de CMC ( eerste beschikbare update in de huidige CMC)
- Download all the upgrades from the CMC ( als dit te traag gaat kan u de volgende FTP gebruiken ftp://up_p4k_5:Extreme1@ftp.usa.hp.com/ )

Igv maintenance window had met complete downtime van de iSCSI sessies kan  er gewoon in normale modus de upgrade uit gevoerd worden. Worst case scenario, indien de update failed updaten in support mode. <a href="http://blog.j81.nl/?p=81" target="_blank">http://blog.j81.nl/?p=81</a> Bijkomende informatie + release notes vindt u op: <a href="https://h20392.www2.hp.com/portal/swdepot/displayProductInfo.do?productNumber=StoreVirtualSW%20" target="_blank">https://h20392.www2.hp.com/portal/swdepot/displayProductInfo.do?productNumber=StoreVirtualSW</a>
