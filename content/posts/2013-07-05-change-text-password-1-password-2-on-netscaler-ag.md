---
title: "Change text password 1 & password 2 on netscaler AG"
date: 2013-07-05T05:50:42Z
categories:
  - "Netscaler"
  - "Uncategorized"
aliases:
  - "/2013/07/05/change-text-password-1-password-2-on-netscaler-ag/"
---

`add rewrite action AD_delete_rewrite_action delete_all "http.RES.BODY(120000).SET_TEXT_MODE(ignorecase)" -pattern "document.write(' 1');" -bypassSafetyCheck YES add rewrite action AD_replace_rewrite_action replace_all "http.RES.BODY(120000).SET_TEXT_MODE(ignorecase)" ""AD Password'"" -pattern ""Password"" -bypassSafetyCheck YES -refineSearch q/extend(50,50).REGEX_SELECT(re![ ]*'[ ]*+[ ]*_("Password")[ ]*!)/ add rewrite action RSA_replace_rewrite_action replace_all "http.RES.BODY(120000).SET_TEXT_MODE(ignorecase)" ""Secure token:'"" -pattern ""Password2"" -bypassSafetyCheck YES -refineSearch q/extend(50,50).REGEX_SELECT(re![ ]*'[ ]*+[ ]*_("Password2")[ ]*!)/ add rewrite policy AD_rewrite_pol "http.req.url.path.endswith("vpn/login.js")" AD_replace_rewrite_action add rewrite policy RSA_rewrite_pol "http.req.url.path.endswith("vpn/login.js")" RSA_replace_rewrite_action add rewrite policy AD_delete_pol "http.req.url.path.endswith("vpn/login.js")" AD_delete_rewrite_action bind rewrite global AD_rewrite_pol 100 NEXT -type RES_OVERRIDE bind rewrite global RSA_rewrite_pol 110 NEXT -type RES_OVERRIDE bind rewrite global AD_delete_pol 120 NEXT -type RES_OVERRIDE`
