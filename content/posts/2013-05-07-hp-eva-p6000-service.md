---
title: "HP EVA P6000 Service"
date: 2013-05-07T07:55:43Z
categories:
  - "HP"
  - "P6000"
  - "Uncategorized"
aliases:
  - "/2013/05/07/hp-eva-p6000-service/"
---

Bij CVE ga naar de fieldservice page: -\> https://localhost:2372/fieldservice en log in. Kies de juiste EVA. Klik op: Open Command line interface Kies uit de dropdown box : FCS show config. En klik on execute. Op de management server staat in: C:program files(x86)hewlett packardsanworkselement manager for storageworks hsvcacheWWWN van EVAfcs_show_config.txt \<- hierin staal alle serienummers van de disken Maar ook met SSSU is met show disk full alle serienummers op te vragen. En in CVE staan ook de juiste. (Dit was vroeger niet zo, maar met de laatste versie CVE en XCS wel)
