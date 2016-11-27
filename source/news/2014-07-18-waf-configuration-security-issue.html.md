---
layout: post
title: "設備不良設定帶來的安全風險：以 WAF 為例"
description: "有了 WAF 設備就是萬靈丹了嗎？若沒有資安人員妥善的針對需求設定、調整架構，很可能反而因為資安設備而帶來風險。本文將以 WAF 為例，探討不良設定的設備帶來的危害。"
category: "技術專欄"
tags: ["WAF", "Proxy", "HTTP Header", "Defense"]
author: "ding"
keywords: "WAF, Proxy, IP"
og_image: ""
---


![Firewall](https://farm7.staticflickr.com/6155/6183500441_5de4a999eb_z.jpg)
<!-- Credit: https://www.flickr.com/photos/briannabites/6183500441/ -->

過去談到網站安全，通常會使用防火牆或 IDS 進行防護。但近年來網站安全議題都是以網頁應用程式的漏洞居多，無法單靠防火牆阻擋。以 OWASP Top 10 2013 的第一名 Injection 而言，多半是程式撰寫方法不嚴謹所造成，因此才有了網頁應用程式防火牆 (Web Application Firewall, WAF) 的出現。

有了 WAF 就是萬靈丹了嗎？就算有各種資安設備，但缺乏安全的設定，有的時候反而會讓系統陷入安全風險中。我們就以 Reverse Proxy 或 WAF 設備來探討不佳設定帶來的安全風險。

READMORE

### WAF 搭配不佳的設定會帶來什麼危害？

以常見的 mod_proxy 搭配 mod_security 的方案來看，通常使用 Reverse Proxy 或 Transparent Proxy 為其架構，透過 Proxy 的方式在 Client 與 Web Server 之間，對 HTTP Request / Response 進行過濾；以 HTTP Request 為例，當 WAF 偵測到 Client 端的請求中有 SQL Injection 語法時候，將會阻斷這個連線防止駭客攻擊。

在這種架構下的 WAF 看似對後端的伺服器多了一份保障，但也並非完美。其問題是後端的 Web Server 在透過 WAF 存取的情況下，無法得知來自 Client 端的來源 IP，相反的 Web Server 能看到的 IP 都將是 WAF 的 IP (REMOTE ADDR)，在這種情況下可能造成 Client 端可以存取受 IP 來源限制的系統。延伸閱讀：[如何正確的取得使用者 IP？](http://devco.re/blog/2014/06/19/client-ip-detection/)。

以下圖為例，網站本身只允許 192.168.x.x 的網段連線，如果今天 Client IP 是 1.1.1.1，將無法存取該網站。

[![限制 IP 存取](https://lh5.googleusercontent.com/-83jVqsSvAXA/U8jvgKw26VI/AAAAAAAAAjU/J_ss99PvApw/w566-h150-no/2014-07-11-waf-configuration-security-issue-01.png "限制 IP 存取")](https://lh5.googleusercontent.com/-83jVqsSvAXA/U8jvgKw26VI/AAAAAAAAAjU/J_ss99PvApw/s2560/2014-07-11-waf-configuration-security-issue-01.png)

但在有建置 WAF 的架構之下，Client 透過 WAF 存取網站，網站得到的 IP 會是 WAF 的 IP：192.168.1.10，因此允許連線，Client 因而取得原本需在內網才能存取的資料。

[![因為 WAF 而繞過 IP 限制](https://lh3.googleusercontent.com/-hlQZaYZcEZE/U8jvhb5DHoI/AAAAAAAAAjw/jb2tUe10cl8/w784-h233-no/2014-07-11-waf-configuration-security-issue-02.png "因為 WAF 而繞過 IP 限制")](https://lh3.googleusercontent.com/-hlQZaYZcEZE/U8jvhb5DHoI/AAAAAAAAAjw/jb2tUe10cl8/s2560/2014-07-11-waf-configuration-security-issue-02.png)

### 實際案例

我們以常見的 Web Server 整合包 XAMPP 為例，在預設的 http-xampp.conf 設定檔中限制了一些管理頁面只能由 Private IP 存取，如 /security 、 /webalizer 、 /phpmyadmin 、 /server-status 、 /server-info 等，此時 WAF 的 IP 若為 Private IP，依 XAMPP 預設設定，WAF 將可以存取這些受 IP 限制的資源，當 WAF 存取完資源後又將內容回傳給 Client 端。

http-xampp.conf 預設設定

{% highlight apache %}
<LocationMatch "^/(?i:(?:xampp|security|licenses|phpmyadmin|webalizer|server-status|server-info))">
        Order deny,allow
        Deny from all
        Allow from ::1 127.0.0.0/8 \
                fc00::/7 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 \
                fe80::/10 169.254.0.0/16
         ErrorDocument 403 /error/XAMPP_FORBIDDEN.html.var
</LocationMatch>
{% endhighlight %}

如果照著預設的設定，以現成的案例來看，能夠存取 Apache Server 的系統狀態，其中可以看到網站所有連線以及 URI 等資料。

[![預設開放 Apache 伺服器狀態](https://lh5.googleusercontent.com/-EO9Rkiws9UI/U8jvhN47OoI/AAAAAAAAAj0/huRQZAHBaWM/w827-h678-no/2014-07-11-waf-configuration-security-issue-05.png "預設開放 Apache 伺服器狀態")](https://lh5.googleusercontent.com/-EO9Rkiws9UI/U8jvhN47OoI/AAAAAAAAAj0/huRQZAHBaWM/s2560/2014-07-11-waf-configuration-security-issue-05.png)

並且可以直接讀取 phpMyAdmin 介面，並且至資料庫中新增、修改、刪除資料，甚至直接上傳 webshell 進入主機。

[![直接進入 phpMyAdmin 管理介面](https://lh4.googleusercontent.com/-qLCILB4qbsI/U8jvhvJxMHI/AAAAAAAAAkQ/JrGBK7N2SgQ/w860-h678-no/2014-07-11-waf-configuration-security-issue-06.png "直接進入 phpMyAdmin 管理介面")](https://lh4.googleusercontent.com/-qLCILB4qbsI/U8jvhvJxMHI/AAAAAAAAAkQ/JrGBK7N2SgQ/s2560/2014-07-11-waf-configuration-security-issue-06.png)

XAMPP 也內建了網站記錄分析工具 webalizer，透過這個介面可以知道網站所有進入點的流量、統計數據等。

[![網站記錄分析工具 webalizer](https://lh6.googleusercontent.com/-22UDz3CWOzw/U8jvig8XCfI/AAAAAAAAAkM/JlDEr1YQXL4/w860-h678-no/2014-07-11-waf-configuration-security-issue-09.png "網站記錄分析工具 webalizer")](https://lh6.googleusercontent.com/-22UDz3CWOzw/U8jvig8XCfI/AAAAAAAAAkM/JlDEr1YQXL4/s2560/2014-07-11-waf-configuration-security-issue-09.png)

### 小結

如果建置了 WAF，有關 IP 的設定必須要從 WAF 支援的 HTTP Header 中取出使用者的 IP (REMOTE_ADDR)，才能讓原本網站的 IP 限制生效。在這種設定錯誤或是對 WAF 架構不瞭解的情況下，WAF 反而成為駭客繞過 Private IP 限制的跳板，就如同為駭客開了一個後門。因此在使用資安設備時，必須瞭解其架構。別讓資安設備、安全機制，反而使得伺服器更不安全。
