---
title: "Exchange config for the NetScaler with AAA Authentication"
date: 2015-02-21T20:20:55Z
categories:
  - "Citrix"
  - "Exchange 2010"
  - "Exchange 2013"
  - "Microsoft"
  - "Netscaler"
  - "Uncategorized"
aliases:
  - "/2015/02/21/exchange-config-for-the-netscaler-with-aaa-authentication/"
  - "/2015/02/21/exchange-config-for-the-netscaler-with-aaa-authentication/feed/"
  - "/2015/02/21/exchange-config-for-the-netscaler-with-aaa-authentication/feed/index.html"
---

Below is the NetScaler configuration for an Exchange environment. You need an Enterprise licence to activate AAA.

``` default
#--- Replace the text below with the actual data---#

#Domain Controller hostname and IP
<DC01.DOMAIN.LOCAL>
<DC01IP>
<DC02.DOMAIN.LOCAL>
<DC01IP>
#Exchange server hostname and IP
<EXCH01.DOMAIN.LOCAL>
<EXCH01IP>
<EXCH02.DOMAIN.LOCAL>
<EXCH02IP>
#Active Directory data
<LDAPPATH>
<LDAPREAD@DOAMIN.LOCAL>
<LDAPREADPASSWD>
#Client subnet marked save for private profile
<CLIENTSUBNET>
#AD group for always use of the private profile
<ADEXCHPRIVATEGRP>
#AAA Server FQDN and IP
<AUTHVIPFQDN>
<AUTHVIPIP>
#Content Switch IP
<CSVIPIP>
#Domain FQDN
<DOMAIN.LOCAL>
#Certiicatename as installed in the NetScaler
<CERTIFICATE>
#Test user for the POP monitor
<POPTESTUSER>
<POPTESTPASSWD>

#--- NS Config below this line ---#

enable ns feature LB CS CMP SSL AAA REWRITE RESPONDER

set ns httpProfile nshttp_default_profile -dropInvalReqs ENABLED

add server Srv_<EXCH01.DOMAIN.LOCAL> <EXCH01IP>
add server Srv_<EXCH02.DOMAIN.LOCAL> <EXCH02IP>

add serviceGroup SvcGrp_exchange_owa SSL -CMP YES -comment "Outlook Web Access"
add serviceGroup SvcGrp_exchange_oa SSL -CMP YES -comment "Outlook Anywhere or RPC over HTTPS"
add serviceGroup SvcGrp_exchange_ews SSL -CMP YES -comment "Exchange Web Services"
add serviceGroup SvcGrp_exchange_eas SSL -CMP YES -comment "ActiveSync Service for Mobile Mail clients"
add serviceGroup SvcGrp_exchange_ecp SSL -CMP YES -comment "Exchange Control Panel"
add serviceGroup SvcGrp_exchange_oab SSL -CMP YES -comment "Offline Address Book"
add serviceGroup SvcGrp_exchange_autodiscover SSL -CMP YES -comment "Autodiscover Service"
add serviceGroup SvcGrp_exchange_pop3 TCP-cltTimeout 9000 -svrTimeout 9000
add serviceGroup SvcGrp_exchange_imap4 TCP -maxClient 0 -maxReq 0 -cip DISABLED -usip NO -useproxyport YES -cltTimeout 9000 -svrTimeout 9000

add authentication ldapAction AuthLdapSrv_<DC01.DOMAIN.LOCAL> -serverIP <DC01IP> -ldapBase "<LDAPPATH>" -ldapBindDn <LDAPREAD@DOAMIN.LOCAL> -ldapBindDnPassword <LDAPREADPASSWD> -ldapLoginName samAccountName -groupAttrName memberOf -subAttributeName CN
add authentication ldapAction AuthLdapSrv_<DC02.DOMAIN.LOCAL> -serverIP <DC02IP> -ldapBase "<LDAPPATH>" -ldapBindDn <LDAPREAD@DOAMIN.LOCAL> -ldapBindDnPassword <LDAPREADPASSWD> -ldapLoginName samAccountName -groupAttrName memberOf -subAttributeName CN

add tm formSSOAction AaaSsoPro_exchange_public -actionURL "/owa/auth.owa" -userField username -passwdField password -ssoSuccessRule "HTTP.RES.SET_COOKIE.COOKIE("cadata").VALUE("cadata").LENGTH.GT(70)" -nameValuePair "flags=0&trusted=0" -responsesize 60000 -submitMethod POST
add tm formSSOAction AaaSsoPro_exchange_private -actionURL "/owa/auth.owa" -userField username -passwdField password -ssoSuccessRule "HTTP.RES.SET_COOKIE.COOKIE("cadata").VALUE("cadata").LENGTH.GT(70)" -nameValuePair "flags=4&trusted=0" -responsesize 60000 -submitMethod POST

add tm trafficAction AaaTrafPro_exchange_public -appTimeout 1 -SSO ON -formSSOAction AaaSsoPro_exchange_public -persistentCookie OFF -InitiateLogout OFF -kcdAccount NONE
add tm trafficAction AaaTrafPro_exchange_private -appTimeout 1 -SSO ON -formSSOAction AaaSsoPro_exchange_private -persistentCookie OFF -InitiateLogout OFF -kcdAccount NONE
add tm trafficAction AaaTrafPro_exchange_logoff_global -appTimeout 1 -SSO ON -persistentCookie OFF -InitiateLogout ON -kcdAccount NONE

add authentication ldapPolicy AuthLdapPol_<DC01.DOMAIN.LOCAL> ns_true AuthLdapSrv_<DC01.DOMAIN.LOCAL>
add authentication ldapPolicy AuthLdapPol_<DC02.DOMAIN.LOCAL> ns_true AuthLdapSrv_<DC02.DOMAIN.LOCAL>

add tm trafficPolicy AaaTrafPol_exchange_public "HTTP.REQ.URL.CONTAINS("owa/auth/logon.aspx") && CLIENT.IP.SRC.IN_SUBNET(<CLIENTSUBNET>).NOT" AaaTrafPro_exchange_public
add tm trafficPolicy AaaTrafPol_exchange_private "HTTP.REQ.URL.CONTAINS("owa/auth/logon.aspx") && CLIENT.IP.SRC.IN_SUBNET(<CLIENTSUBNET>) ||  HTTP.REQ.USER.IS_MEMBER_OF("<ADEXCHPRIVATEGRP>")" AaaTrafPro_exchange_private
add tm trafficPolicy AaaTrafPol_exchange_logoff_global "HTTP.REQ.URL.CONTAINS("owa/logoff.owa")" AaaTrafPro_exchange_logoff_global

add lb vserver LbVip_exchange_owa SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -AuthenticationHost <AUTHVIPFQDN> -Authentication ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Outlook Web Access"
add lb vserver LbVip_exchange_ews SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -authn401 ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Exchange Web Service"
add lb vserver LbVip_exchange_autodiscover SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -authn401 ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Autodiscover Service"
add lb vserver LbVip_exchange_ecp SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -AuthenticationHost <AUTHVIPFQDN> -Authentication ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Exchange Control Panel"
add lb vserver LbVip_exchange_eas SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -authn401 ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "ActiveSync Service for Mobile Mail clients"
add lb vserver LbVip_exchange_oab SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -authn401 ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Offline Address Book"
add lb vserver LbVip_exchange_oa SSL 0.0.0.0 0 -persistenceType SSLSESSION -cltTimeout 180 -authn401 ON -authnVsName AaaVip_<AUTHVIPFQDN> -comment "Outlook Anywhere or RPC over HTTPS"

add lb vserver LbVip_exchange_imap4 SSL_TCP <CSVIPIP> 993 -persistenceType SSLSESSION -cltTimeout 9000
add lb vserver LbVip_exchange_pop3 SSL_TCP <CSVIPIP> 995 -persistenceType SSLSESSION -cltTimeout 9000

add authentication vserver AaaVip_<AUTHVIPFQDN> SSL <AUTHVIPIP> 443 -AuthenticationDomain <DOMAIN.LOCAL>
add cs vserver CswVip_https_<DOMAIN.LOCAL> SSL <CSVIPIP> 443 -cltTimeout 180 -caseSensitive OFF -httpProfileName nshttp_default_strict_validation
add cs vserver CswVip_http_<DOMAIN.LOCAL> HTTP <CSVIPIP> 80 -cltTimeout 180 -caseSensitive OFF -httpProfileName nshttp_default_strict_validation

add cs action CswAct_ews -targetLBVserver LbVip_exchange_ews
add cs action CswAct_owa -targetLBVserver LbVip_exchange_owa
add cs action CswAct_ecp -targetLBVserver LbVip_exchange_ecp
add cs action CswAct_eas -targetLBVserver LbVip_exchange_eas
add cs action CswAct_oab -targetLBVserver LbVip_exchange_oab
add cs action CswAct_oa -targetLBVserver LbVip_exchange_oa
add cs action CswAct_autodiscover -targetLBVserver LbVip_exchange_autodiscover

add cs policy CswPol_ews -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/ews")" -action CswAct_ews
add cs policy CswPol_owa -rule "HTTP.REQ.HEADER("User-Agent").SET_TEXT_MODE(IGNORECASE).CONTAINS("Mozilla")" -action CswAct_owa
add cs policy CswPol_ecp -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/ecp")" -action CswAct_ecp
add cs policy CswPol_eas -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/Microsoft-Server-ActiveSync")" -action CswAct_eas
add cs policy CswPol_oab -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/oab")" -action CswAct_oab
add cs policy CswPol_oa -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/rpc")" -action CswAct_oa
add cs policy CswPol_autodiscover -rule "HTTP.REQ.URL.SET_TEXT_MODE(IGNORECASE).CONTAINS("/AutoDiscover")" -action CswAct_autodiscover

add rewrite action RewAct_exchange_insert_pback_cookie_1 insert_http_header COOKIE ""PBack=0;""
add rewrite action RewAct_exchange_insert_pback_cookie_2 insert_after "HTTP.REQ.HEADER("COOKIE").INSTANCE(0).SUBSTR(":")" "" PBack=0;""

add rewrite policy RewPol_exchange_insert_pback_cookie_1 "HTTP.REQ.URL.CONTAINS("owa/auth/logon.aspx") && HTTP.REQ.COOKIE.COUNT.GT(2).NOT" RewAct_exchange_insert_pback_cookie_1
add rewrite policy RewPol_exchange_insert_pback_cookie_2 "HTTP.REQ.URL.CONTAINS("owa/auth/logon.aspx") && HTTP.REQ.COOKIE.COUNT.GT(2)" RewAct_exchange_insert_pback_cookie_2

bind rewrite global RewPol_exchange_insert_pback_cookie_2 100 END -type REQ_DEFAULT
bind rewrite global RewPol_exchange_insert_pback_cookie_1 110 END -type REQ_DEFAULT

add responder action ResAct_exchange_ToOwa redirect ""/owa""
add responder policy ResPol_exchange_ToOwa "HTTP.REQ.URL.STARTSWITH("/owa").NOT" ResAct_exchange_ToOwa

add responder action ResAct_ToHTTPS_301 respondwith q{"HTTP/1.1 301 Moved Permanentlyrn" + "Location: https://" + HTTP.REQ.HOSTNAME + HTTP.REQ.URL.PATH_AND_QUERY + "rnrn"} -bypassSafetyCheck YES
add responder policy ResPol_RedirToHTTPS true ResAct_ToHTTPS_301

add responder action ResAct_ToHTTPS_404 respondwith q{"HTTP/1.1 404 Not Foundrn"} -bypassSafetyCheck YES
add responder policy ResPol_RespondWith404 true ResAct_ToHTTPS_404

bind lb vserver LbVip_exchange_owa SvcGrp_exchange_owa
bind lb vserver LbVip_exchange_oa SvcGrp_exchange_oa
bind lb vserver LbVip_exchange_ews SvcGrp_exchange_ews
bind lb vserver LbVip_exchange_eas SvcGrp_exchange_eas
bind lb vserver LbVip_exchange_ecp SvcGrp_exchange_ecp
bind lb vserver LbVip_exchange_oab SvcGrp_exchange_oab
bind lb vserver LbVip_exchange_autodiscover SvcGrp_exchange_autodiscover
bind lb vserver LbVip_exchange_pop3 SvcGrp_exchange_pop3
bind lb vserver LbVip_exchange_imap4 SvcGrp_exchange_imap4

bind lb vserver LbVip_exchange_owa -policyName AaaTrafPol_exchange_private -priority 100 -gotoPriorityExpression END -type REQUEST
bind lb vserver LbVip_exchange_owa -policyName AaaTrafPol_exchange_public -priority 110 -gotoPriorityExpression END -type REQUEST
bind lb vserver LbVip_exchange_ecp -policyName AaaTrafPol_exchange_public -priority 100 -gotoPriorityExpression END -type REQUEST
bind lb vserver LbVip_exchange_ecp -policyName AaaTrafPol_exchange_private -priority 110 -gotoPriorityExpression END -type REQUEST

bind lb vserver LbVip_exchange_owa -policyName ResPol_exchange_ToOwa -priority 100 -gotoPriorityExpression END -type REQUEST
bind cs vserver CswVip_http_<DOMAIN.LOCAL> -policyName ResPol_RedirWebmailToHTTPS -priority 100 -gotoPriorityExpression END -type REQUEST
bind cs vserver CswVip_http_<DOMAIN.LOCAL> -policyName ResPol_RespondWith404 -priority 10000 -gotoPriorityExpression END -type REQUEST

bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_autodiscover -priority 100
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_eas -priority 110
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_ews -priority 120
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_oab -priority 130
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_oa -priority 140
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_ecp -priority 150
bind cs vserver CswVip_https_<DOMAIN.LOCAL> -policyName CswPol_owa -priority 160

set ns httpParam -dropInvalReqs ON

add lb monitor Mon_imap4 TCP-ECV -send "GET /" -recv "The Microsoft Exchange IMAP4 service is ready." -LRTM ENABLED -interval 30 -destPort 143
add lb monitor Mon_pop3 POP3 -scriptName nspop3.pl -dispatcherIP 127.0.0.1 -dispatcherPort 3013 -userName <POPTESTUSER> -password <POPTESTPASSWD> -LRTM ENABLED -interval 30

#Not needed for Exchange 2007-2010
add lb monitor Mon_owa TCP-ECV -send "GET /owa/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_ecp TCP-ECV -send "GET /ecp/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_ews TCP-ECV -send "GET /ews/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_eas TCP-ECV -send "GET /Microsoft-Server-ActiveSync/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_oab TCP-ECV -send "GET /oab/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_oa TCP-ECV -send "GET /rpc/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES
add lb monitor Mon_Autodiscover TCP-ECV -send "GET /Autodiscover/healthcheck.htm HTTP/1.1rnHost:<EXCHANGEWEBMAILURL>rnConnection:Closernrn" -recv 200 -LRTM ENABLED -retries 10 -secure YES

bind serviceGroup SvcGrp_exchange_owa Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_owa Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_owa -monitorName Mon_owa
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_owa -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_oa Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_oa Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_oa -monitorName Mon_oa
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_oa -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_ews Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_ews Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_ews -monitorName Mon_ews
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_ews -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_eas Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_eas Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_eas -monitorName Mon_eas
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_eas -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_ecp Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_ecp Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_ecp -monitorName Mon_ecp
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_ecp -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_oab Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_oab Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_oab -monitorName Mon_oab
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_oab -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_autodiscover Srv_<EXCH01.DOMAIN.LOCAL> 443 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_autodiscover Srv_<EXCH02.DOMAIN.LOCAL> 443 -CustomServerID ""None""
#Exchange 2013
bind serviceGroup SvcGrp_exchange_autodiscover -monitorName Mon_Autodiscover
#Exchange 2007-2010
#bind serviceGroup SvcGrp_exchange_autodiscover -monitorName https-ecv

bind serviceGroup SvcGrp_exchange_pop3 Srv_<EXCH01.DOMAIN.LOCAL> 110 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_pop3 Srv_<EXCH02.DOMAIN.LOCAL> 110 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_pop3 -monitorName Mon_pop3

bind serviceGroup SvcGrp_exchange_imap4 Srv_<EXCH01.DOMAIN.LOCAL> 143 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_imap4 Srv_<EXCH02.DOMAIN.LOCAL> 143 -CustomServerID ""None""
bind serviceGroup SvcGrp_exchange_imap4 -monitorName Mon_imap4

set ssl vserver LbVip_exchange_owa -ssl3 DISABLED
set ssl vserver LbVip_exchange_ews -ssl3 DISABLED
set ssl vserver LbVip_exchange_autodiscover -ssl3 DISABLED
set ssl vserver LbVip_exchange_ecp -ssl3 DISABLED
set ssl vserver LbVip_exchange_eas -ssl3 DISABLED
set ssl vserver LbVip_exchange_oab -ssl3 DISABLED
set ssl vserver LbVip_exchange_oa -ssl3 DISABLED
set ssl vserver LbVip_exchange_imap4 -ssl3 DISABLED
set ssl vserver LbVip_exchange_pop3 -ssl3 DISABLED
set ssl vserver AaaVip_<AUTHVIPFQDN> -ssl3 DISABLED
set ssl vserver CswVip_https_<DOMAIN.LOCAL> -ssl3 DISABLED

add tm sessionAction AaaSesPro_sso_exchange -sessTimeout 60 -defaultAuthorizationAction ALLOW -SSO ON -ssoCredential PRIMARY -ssoDomain Domain -httpOnlyCookie NO -persistentCookie ON -persistentCookieValidity 30
add tm sessionPolicy AaaSesPol_sso_exchange ns_true AaaSesPro_sso_exchange

bind tm global -policyName AaaTrafPol_exchange_logoff_global -priority 100

bind authentication vserver AaaVip_<AUTHVIPFQDN> -policy AuthLdapPol_<DC01.DOMAIN.LOCAL> -priority 100
bind authentication vserver AaaVip_<AUTHVIPFQDN> -policy AuthLdapPol_<DC02.DOMAIN.LOCAL> -priority 110
bind authentication vserver AaaVip_<AUTHVIPFQDN> -policy AaaSesPol_sso_exchange -priority 100

add ssl cipher HighSecurity
bind ssl cipher HighSecurity -cipherName TLS1-ECDHE-RSA-AES256-SHA
bind ssl cipher HighSecurity -cipherName TLS1-ECDHE-RSA-AES128-SHA
bind ssl cipher HighSecurity -cipherName TLS1-ECDHE-RSA-DES-CBC3-SHA
bind ssl cipher HighSecurity -cipherName TLS1-DHE-RSA-AES-256-CBC-SHA
bind ssl cipher HighSecurity -cipherName TLS1-DHE-DSS-AES-256-CBC-SHA
bind ssl cipher HighSecurity -cipherName TLS1-DHE-RSA-AES-128-CBC-SHA
bind ssl cipher HighSecurity -cipherName TLS1-DHE-DSS-AES-128-CBC-SHA
bind ssl cipher HighSecurity -cipherName TLS1-AES-256-CBC-SHA
bind ssl cipher HighSecurity -cipherName TLS1-AES-128-CBC-SHA
bind ssl cipher HighSecurity -cipherName SSL3-DES-CBC3-SHA

bind ssl vserver LbVip_exchange_owa -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_ews -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_autodiscover -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_ecp -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_eas -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_oab -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_oa -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_imap4 -certkeyName "<CERTIFICATE>"
bind ssl vserver LbVip_exchange_pop3 -certkeyName "<CERTIFICATE>"
bind ssl vserver AaaVip_<AUTHVIPFQDN> -certkeyName "<CERTIFICATE>"
bind ssl vserver CswVip_https_<DOMAIN.LOCAL> -certkeyName "<CERTIFICATE>"

unbind ssl vserver LbVip_exchange_owa -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_ews -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_autodiscover -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_ecp -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_eas -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_oab -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_oa -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_imap4 -cipherName DEFAULT
unbind ssl vserver LbVip_exchange_pop3 -cipherName DEFAULT
unbind ssl vserver AaaVip_<AUTHVIPFQDN> -cipherName DEFAULT
unbind ssl vserver CswVip_https_<DOMAIN.LOCAL> -cipherName DEFAULT

bind ssl vserver LbVip_exchange_owa -cipherName HighSecurity
bind ssl vserver LbVip_exchange_ews -cipherName HighSecurity
bind ssl vserver LbVip_exchange_autodiscover -cipherName HighSecurity
bind ssl vserver LbVip_exchange_ecp -cipherName HighSecurity
bind ssl vserver LbVip_exchange_eas -cipherName HighSecurity
bind ssl vserver LbVip_exchange_oab -cipherName HighSecurity
bind ssl vserver LbVip_exchange_oa -cipherName HighSecurity
bind ssl vserver LbVip_exchange_imap4 -cipherName HighSecurity
bind ssl vserver LbVip_exchange_pop3 -cipherName HighSecurity
bind ssl vserver AaaVip_<AUTHVIPFQDN> -cipherName HighSecurity
bind ssl vserver CswVip_https_<DOMAIN.LOCAL> -cipherName HighSecurity
```

 
