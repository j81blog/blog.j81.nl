---
title: "reboot management brocade fc switch"
date: 2013-06-26T11:10:01Z
categories:
  - "Brocade"
  - "Uncategorized"
aliases:
  - "/2013/06/26/reboot-management-brocade-fc-switch/"
---

1\. Log into the switch as root (not admin) and execute /fabos/libexec/webdconfigure and answer 'yes' to the HTTP Restart question. Example:  (note: answer yes to http atributes and HTTP Restart, then take defaults for the rest of the prompts) fabbd70:root\> /fabos/libexec/webdconfigure http attributes (yes, y, no, n): \[no\] yes HTTP Restart (yes, y, no, n): \[no\] yes HTTP enabled (yes, y, no, n): \[yes\] ErrorLog Enabled (yes, y, no, n): \[no\] AccessLog Enabled (yes, y, no, n): \[no\] SSLLog Enabled (yes, y, no, n): \[no\] HTTP Port: (1..60000) \[80\] Secure HTTP Port: (1..60000) \[443\] HTTP IsAlive Check Enabled (yes, y, no, n): \[yes\] HTTP Max HeapSize: (256..1024) \[512\] webtools attributes (yes, y, no, n): \[no\] cal attributes (yes, y, no, n): \[no\] Now wait a minute or two and do the following command to see if the HTTP processes are restarted: fabbd70:root\> ps -ef | grep http root     23369     1  0 10:08 ?        00:00:00 /usr/apache/bin/httpd.0 -f /fabos/webtools/bin/httpd.conf.0 nobody   23370 23369  0 10:08 ?        00:00:00 /usr/apache/bin/fcgi-pm -f /fabos/webtools/bin/httpd.conf.0 nobody   23938 23369  0 10:53 ?        00:00:00 /usr/apache/bin/httpd.0 -f /fabos/webtools/bin/httpd.conf.0 nobody   23949 23369  0 10:54 ?        00:00:00 /usr/apache/bin/httpd.0 -f /fabos/webtools/bin/httpd.conf.0 nobody   23960 23369  0 10:55 ?        00:00:00 /usr/apache/bin/httpd.0 -f /fabos/webtools/bin/httpd.conf.0 root     24060 23978  0 10:55 pts/0    00:00:00 grep http
