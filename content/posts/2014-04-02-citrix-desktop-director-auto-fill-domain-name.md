---
title: "Citrix Desktop Director Auto Fill Domain Name"
date: 2014-04-02T12:11:30Z
categories:
  - "Citrix"
  - "Director"
  - "Uncategorized"
aliases:
  - "/2014/04/02/citrix-desktop-director-auto-fill-domain-name/"
  - "/2014/04/02/citrix-desktop-director-auto-fill-domain-name/feed/"
  - "/2014/04/02/citrix-desktop-director-auto-fill-domain-name/feed/index.html"
---

When logging on to the Citrix Director you have to enter the domain name along with the username and password. If you don't want to enter the domain name each time you logon you can have it filled in by default. Edit C:inetpubwwwrootDesktopDirectorLogOn.aspx (With admin rights)

``` asp
<asp:TextBox ID="Domain" runat="server" CssClass="text-box" ></asp:TextBox>
```

``` asp
<asp:TextBox ID="Domain" Text="DOMAIN.LOCAL" readonly="true" runat="server" CssClass="text-box"></asp:TextBox>
```

 
