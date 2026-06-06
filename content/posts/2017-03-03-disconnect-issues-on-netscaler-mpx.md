---
title: "Disconnect issues on NetScaler MPX"
date: 2017-03-03T12:08:31Z
categories:
  - "Citrix"
  - "Netscaler"
  - "Uncategorized"
aliases:
  - "/2017/03/03/disconnect-issues-on-netscaler-mpx/"
---

Recently I upgraded a couple of MPX NetScalers to a recent 11.1 build at a customers location. During the following day the customer experienced a lot of disconnecting citrix sessions. I did not experience this issue on a VPX appliance. Turned out to be an issue with the "***TLS1.2-ECDHE-RSA-AES256-GCM-SHA384***" cypher. And because I want to strive for an A+ rating at ssllabs ([Scoring an A+ at SSLlabs.com with Citrix NetScaler – 2016 update](https://www.citrix.com/blogs/2016/06/09/scoring-an-a-at-ssllabs-com-with-citrix-netscaler-2016-update/)) this one is in the list. After removing this cypher from the cypher group the customer didn't experience any disconnects. So I thought to share this one as you may experience it for your self. Please also note this Citrix article: https://support.citrix.com/article/CTX220994
