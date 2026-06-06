---
title: "Exchange 2010 reconnect archive mailbox"
date: 2013-02-21T15:43:36Z
categories:
  - "Exchange 2010"
  - "Microsoft"
  - "Uncategorized"
aliases:
  - "/2013/02/21/exchange-2010-reconnect-archive-mailbox/"
---

Find (disconnected) mailbox: **Get-MailboxServer | Get-MailboxStatistics | where { $\_.DisconnectDate } | fl DisplayName, DisconnectDate** Recconnect mailbox: **Get-MailboxDatabase | Get-MailboxStatistics | Where-Object {$\_.DisconnectDate –and $\_.DisplayName –eq “Personal Archive - Tinnus Est”} | Connect-Mailbox –user T.Est –archive**
