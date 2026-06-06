---
title: "Citrix StoreFront Domain passthrough not working when base url is different from machine domain"
date: 2015-03-03T12:17:44Z
categories:
  - "Citrix"
  - "StoreFront 2.x"
  - "Uncategorized"
aliases:
  - "/2015/03/03/citrix-storefront-domain-passthrough-not-working-when-base-url-is-different-from-machine-domain/"
---

When using a different base url for storefront than your storefront is member of you might run into this one. When logging on to a machine configured for Domain Passthrough you need to enter the credentials again in Windows. To resolve this issue enter on your StoreFront server the following command:

``` batch
Setspn -L <SF HOSTNAME>
```

You might get this result

``` batch
C:>Setspn -L SRV-SF-01
Registered ServicePrincipalNames for CN=SRV-SF-01,OU=Storefront,OU=Citrix,OU=Ser
vers,DC=DOMAIN,DC=LOCAL:
        WSMAN/SRV-SF-01
        WSMAN/SRV-SF-01.Domain.Local
        TERMSRV/SRV-SF-01
        TERMSRV/SRV-SF-01.Domain.Local
        RestrictedKrbHost/SRV-SF-01
        HOST/SRV-SF-01
        RestrictedKrbHost/SRV-SF-01.Domain.Local
        HOST/SRV-SF-01.Domain.Local
```

You need to add the StoreFront Base URL to this list to make the magic happen.

``` batch
Setspn -A HOST/<SF HOST> <SF BASEURL>
```

Afterwards when you check again the Base  URL is in the list.

``` batch
C:>Setspn -A HOST/SRV-SF-01 storefront.domain.com      

C:>Setspn -L SRV-SF-01
Registered ServicePrincipalNames for CN=SRV-SF-01,OU=Storefront,OU=Citrix,OU=Ser
vers,DC=DOMAIN,DC=LOCAL:
        HOST/storefront.domain.com
        WSMAN/SRV-SF-01
        WSMAN/SRV-SF-01.Domain.Local
        TERMSRV/SRV-SF-01
        TERMSRV/SRV-SF-01.Domain.Local
        RestrictedKrbHost/SRV-SF-01
        HOST/SRV-SF-01
        RestrictedKrbHost/SRV-SF-01.Domain.Local
        HOST/SRV-SF-01.Domain.Local
```

Good luck!
