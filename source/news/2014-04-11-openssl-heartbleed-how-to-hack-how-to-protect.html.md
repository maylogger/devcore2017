---

title: "OpenSSL Heartbleed 全球駭客的殺戮祭典，你參與了嗎？"
description: "OpenSSL CVE-2014-0160 Heartbleed 漏洞你聽過嗎？你知道攻擊是怎麼發生的嗎？我們整理了一些大眾向我們詢問的問題，像是攻擊方式、防禦方式等。號稱本年度最嚴重的漏洞，已經不容你再度錯過。"
category: "技術專欄"
tags: [OpenSSL, Vulnerability, CVE]
author: "allenown"
keywords: "OpenSSL, Vulnerability, 攻擊程式, Heartbleed, Exploit, CVE-2014-0160"
---


你跟上了 OpenSSL Heartbleed 的祭典了嗎？如果還沒有，別忘記詳細閱讀一下我們的前文「[OpenSSL CVE-2014-0160 Heartbleed 嚴重漏洞](http://devco.re/blog/2014/04/09/openssl-heartbleed-CVE-2014-0160/)」。

這幾天不少企業、民眾都不斷來詢問我們相對應的解決方案：

* Heartbleed 跟我有關嗎？我該怎麼知道？
* 我該怎麼更新 OpenSSL？
* 我如果不能更新，要怎麼防止攻擊？
* Heartbleed 漏洞攻擊者會怎麼利用？
* 目前受害的狀況如何？
* 我只是一般民眾，該如何應對？

我相信不少人都有類似的疑問，我們以這篇專文補遺上次沒提到的資訊。

READMORE

### 攻擊手法示範

大家都說 OpenSSL Heartbleed 漏洞可望為本年度最嚴重的漏洞，到底有多嚴重呢？我相信沒有看到攻擊的範例是沒有感覺的。大家可以先看看以下的影片，利用最先釋出的兩個簡單的 PoC exploit （弱點利用程式）「ssltest.py」以及「check-ssl-heartbleed.pl」，來檢測伺服器是否有 Heartbleed 問題。檢測的同時可以獲取伺服器記憶體中的資訊，其中就可能包含了機敏資訊。

讓我們來看看吧！

{% youtube kFGzu0-cIxE %}
  
  
首先利用 [ssltest.py](http://pastebin.com/WmxzjkXJ) 來測試，來看伺服器是否有被 heartbleed 漏洞影響，fbi.gov 在第三天已經修復這個問題。

[![利用 ssltest.py 來測試伺服器是否有 Heartbleed 漏洞。](https://lh3.googleusercontent.com/-EeW6B_aOR7s/U0kWbYnPIPI/AAAAAAAAAQ8/o-WQ5rGGpOs/w896-h678-no/2014-04-11-openssl-heartbleed-detail-01-ssltest.py.png "利用 ssltest.py 來測試伺服器是否有 Heartbleed 漏洞。")](https://lh3.googleusercontent.com/-EeW6B_aOR7s/U0kWbYnPIPI/AAAAAAAAAQ8/o-WQ5rGGpOs/s2560/2014-04-11-openssl-heartbleed-detail-01-ssltest.py.png)

如果是檢測一個有漏洞的網站，這個工具會直接把記憶體的內容顯示出來，其中可能包括 http 傳輸的資料、帳號密碼、私密金鑰等。在這個例子中，攻擊程式讀取到使用者送出的 form，若其中包含個資將會被一覽無遺，非常危險。

[![利用 ssltest.py 抓出記憶體中的資料，其中包括 HTTP 傳輸內容。](https://lh4.googleusercontent.com/-csGMcT5ue6k/U0kWbdd0BTI/AAAAAAAAARI/_eJXbANavDw/w896-h678-no/2014-04-11-openssl-heartbleed-detail-02-ssltest.py-data.png "利用 ssltest.py 抓出記憶體中的資料，其中包括 HTTP 傳輸內容。")
](https://lh4.googleusercontent.com/-csGMcT5ue6k/U0kWbdd0BTI/AAAAAAAAARI/_eJXbANavDw/s2560/2014-04-11-openssl-heartbleed-detail-02-ssltest.py-data.png)

另一個工具 [check-ssl-heartbleed.pl](https://github.com/noxxi/p5-scripts/blob/master/check-ssl-heartbleed.pl) 可以使用 -R 參數做更有效的利用。直接執行指令可以快速顯示伺服器有無問題。

[![利用 check-ssl-heartbleed.pl 來檢查伺服器是否有 heartbleed 問題。](https://lh6.googleusercontent.com/-899EwdZRGgc/U0kWbbuSqLI/AAAAAAAAARE/1MUSueVzmV8/w896-h678-no/2014-04-11-openssl-heartbleed-detail-03-check-ssl-heartbleed.pl.png "利用 check-ssl-heartbleed.pl 來檢查伺服器是否有 heartbleed 問題。")](https://lh6.googleusercontent.com/-899EwdZRGgc/U0kWbbuSqLI/AAAAAAAAARE/1MUSueVzmV8/s2560/2014-04-11-openssl-heartbleed-detail-03-check-ssl-heartbleed.pl.png)

如果使用「-R」參數並且指定特定的正規表示式，可以抓出想要獲取的資料。例如 Cookie、帳號密碼等。以此例，我們知道這個網站提供 [phpMyAdmin](http://www.phpmyadmin.net) 套件，因此直接鎖定「pmaPass」資料來抓取，沒想到第一次就抓到了。

[![利用 check-ssl-heartbleed.pl 抓出特定機敏資料。](https://lh3.googleusercontent.com/-r_BgZxi8iAY/U0kWcfBjHtI/AAAAAAAAARM/UJ2o6sOlgx8/w896-h678-no/2014-04-11-openssl-heartbleed-detail-04-check-ssl-heartbleed.pl-data.png "利用 check-ssl-heartbleed.pl 抓出特定機敏資料。")](https://lh3.googleusercontent.com/-r_BgZxi8iAY/U0kWcfBjHtI/AAAAAAAAARM/UJ2o6sOlgx8/s2560/2014-04-11-openssl-heartbleed-detail-04-check-ssl-heartbleed.pl-data.png)

接著攻擊者只要把這個獲取到的 Cookie 存入自己的瀏覽器中，就可以如影片中盜用這個帳號。是否很危險呢？

除了這種利用方法之外，還有更多情況是直接把使用者登入的帳號密碼直接顯示出來的，因此如果伺服器沒有做好防禦或更新，整個網站的使用者資料都可以因此外洩。這也是為什麼我們一直強調伺服器管理者必須要更新金鑰、全站使用者帳號密碼等，以防有心人士借此撈取資料。

### 誰在利用 Heartbleed 漏洞竊取資料呢？

由 github 上面的 [commit 記錄](https://github.com/openssl/openssl/commit/4817504d069b4c5082161b02a22116ad75f822b1)，出問題的那行程式碼是在 2011-12-31 22:59:57 commit 的，不知道是開發者太累還是 NSA 的陰謀。根據 Bloomberg 的[報導](http://www.bloomberg.com/news/2014-04-11/nsa-said-to-have-used-heartbleed-bug-exposing-consumers.html)指出，知情人士表示 NSA 早在**兩年前**就已經知道此漏洞，並且**利用這個漏洞竊取許多網站的機敏資料**。這代表 NSA 在一開始就知道這個漏洞，令人不禁有其他聯想。


> The U.S. National Security Agency knew for at least two years about a flaw in the way that many websites send sensitive information, now dubbed the Heartbleed bug, and regularly used it to gather critical intelligence, two people familiar with the matter said.


在之前[台灣駭客年會 (HITCON)](http://hitcon.org) 2013 的講師 Rahul Sasi (Garage4Hackers) 公布了[大量掃描 Heartbleed 漏洞的程式](https://bitbucket.org/fb1h2s/cve-2014-0160/src/bba16b3eedef0e92bd91fea496b00c92eb515e29/Heartbeat_scanner.py?at=master)，也可以供研究人員自行研究，或者是尋找自己管理的主機中有多少包含這個風險的。


### 常見問題

### OpenSSL 是什麼？IIS 會受 Heartbleed 漏洞影響嗎？

[OpenSSL](https://www.openssl.org) 是一個函式庫（Library），在 UNIX 系列的服務若有使用 SSL，通常都會使用 OpenSSL。因此這次的漏洞並未影響微軟 IIS。

### 我使用 OpenSSL 0.9.8，太好了我用舊版我好安全！

你聽過 [BEAST](http://en.wikipedia.org/wiki/Transport_Layer_Security#BEAST_attack), [BREACH](http://en.wikipedia.org/wiki/BREACH_%28security_exploit%29), [CRIME](http://en.wikipedia.org/wiki/CRIME_%28security_exploit%29), [Lucky 13](http://www.isg.rhul.ac.uk/tls/Lucky13.html) 嗎？

### 我沒有使用 HTTPS，所以我很安全！

。。。

### 只有網頁伺服器（HTTP Server）會受影響嗎？

不只！只要使用 OpenSSL 支援 STARTTLS 的服務都在影響範圍，包括 HTTPS、IMAPS、POPS、SMTPS 等伺服器。

### 只有自己架設的伺服器會受影響嗎？

當然不只！目前已經出現各大設備廠商都遭遇到這樣的問題。各大設備廠商、作業系統等影響狀況，可以參閱以下文章。

CERT: OpenSSL heartbeat extension read overflow discloses sensitive information
[http://www.kb.cert.org/vuls/byvendor?searchview&Query=FIELD+Reference=720951&SearchOrder=4](http://www.kb.cert.org/vuls/byvendor?searchview&Query=FIELD+Reference=720951&SearchOrder=4)

廠商的設備目前狀況特別嚴重，因為所有同個版本的設備都會受影響，而在廠商釋出更新之前，只能被動的等待更新。若沒有繼續簽訂維護約的設備，也只能繼續跟廠商簽約更新，或者是看廠商是否可以直接提供更新檔。如果有 VPN Server 等服務更要注意，如果被攻擊者取得帳號密碼，等於如入無人之境，直接使用你的帳號登入到企業內網，不可不慎。

### 各家系統更新的速度？

引述自好朋友 Ant 的[文章](http://blog.gcos.me/2014-04-10_openssl-cve-2014-0160-security-issue.html)，各家作業系統、網站的更新速度，代表著企業重視資安的程度以及針對資安事件緊急應變的效率，也可以作為我們挑選系統、網站、廠商的依據。

> 二、作業系統的更新進度
> 
> 從資安事件的處理可以推敲出各作業系統商對於緊急事件的反應速度。
> 時間軸，按照修復的先後排列：
> 
> 1. OpenSSL (資安弱點的主角) 第一次公開揭露的時間約在 2014年4月6日 0時。
> 2. RedHat 在 2014年4月7日 07:47:00 正式修復。
> 3. OpenSSL 正式確認並修復的時間約在 2014年4月7日16時。
> 4. OpenBSD 約在 2014年4月7日 20:17 正式修復。
> 5. Arch Linux 約在 2014年4月7日 20:36 正式修復。
> 6. Debian 約在 2014年4月7日 21:45 正式修復。
> 7. FreeBSD 約在 2014年4月7日 21:46 正式修復。
> 8. Ubuntu 約在 2014年4月7日 21:48 正式修復。
> (2014年4月8日分隔區)
> 9. Fedora 約在 2014年4月8日 00:33 正式修復。
> 10. CentOS 約在 2014年4月8日 02:49 正式修復。
> 11. OpenSUSE 約在 2014年4月8日 05:32 正式修復。
> 12. Scentific 約在 2014年4月8日 08:27 正式修復。
> 13. Gentoo 約在 2014年4月8日 09:36 正式修復。
> 
> 重點整理：
> 1. RedHat 修復的速度比 OpenSSL 官方還快。
> 2. RedHat 派系的修復時間，除了 RedHat 外都算慢，如 Fedora 及 CentOS、Scentific，他們都比 RedHat 慢 16 小時以上。
> 3. Debian 派系的修復時間，如 Debian 及 Ubuntu，都比 RedHat 慢上至少 12 小時以上。
> 4. Gentoo 是列表中修復最慢的。
> 5. 若以資安黃金 6 小時來說，Fedora、CentOS、OpenSUSE、Scentific 及 Gentoo 都不及格。
> 
> 三、大公司更新的速度
> 
> 同樣地，從資安事件的處理可以推敲出各公司對於緊急事件的反應速度。
> 
> 雲端相關公司
> * Cloudflare 約在 2014年4月7日 11時修復。
> * DigitalOcean 約在 2014年4月8日 12時修復。
> * AWS 約在 2014年4月8日 12時修復。
> * Linode 約在 2014年4月8日 14時修復。
> * Heroku 約在 2014年4月8日 16時修復。
> 
> 有些公司直到 2014年4月8日 16時都還沒修復。此時已離官方正式修復整整一天，也比上述機器數很多的雲端相關公司還慢。這些公司為，
> * Yahoo.com / Flickr.com
> * Kaspersky.com (資安公司)
> * stackoverflow.com
> * stackexchange .com
> * php.net

感謝 StackNG 的補充：Cloudflare 於 2014 年 4 月 7 日 11 時公告，但在漏洞公告之前已經修復。

### 目前還有哪些伺服器有問題呢？

根據 [ZMap](https://zmap.io/) 的[研究報告](https://zmap.io/heartbleed/)指出，他們針對 [Alexa 前一百萬個網站](http://s3.amazonaws.com/alexa-static/top-1m.csv.zip)進行檢測，大約有 36% 的伺服器支援 TLS、7.6% 的伺服器含有此漏洞。ZMap 並提供了一個[完整的清單](https://zmap.io/heartbleed/vulnerable.html)列出在 2014/4/11 17:00 尚未修復漏洞的網站。

[![ZMap.io Heartbleed vulnerable domains](https://lh3.googleusercontent.com/-5iuzr3g9s3U/U0lID8GrS4I/AAAAAAAAARw/Mi673wz-Jhc/w979-h586-no/2014-04-11-openssl-heartbleed-detail-06.png "ZMap.io Heartbleed vulnerable domains")](https://lh3.googleusercontent.com/-5iuzr3g9s3U/U0lID8GrS4I/AAAAAAAAARw/Mi673wz-Jhc/s2560/2014-04-11-openssl-heartbleed-detail-06.png)

### 有什麼值得測試的網站呢？

[![OpenSSL Heartbleed with a beer!](https://lh4.googleusercontent.com/-CiDaDbmxMK0/U0lGuQ6J1iI/AAAAAAAAARg/cZQSD4k7F40/w687-h422-no/2014-04-11-openssl-heartbleed-detail-05.jpg "OpenSSL Heartbleed with a beer!")](https://lh4.googleusercontent.com/-CiDaDbmxMK0/U0lGuQ6J1iI/AAAAAAAAARg/cZQSD4k7F40/s2560/2014-04-11-openssl-heartbleed-detail-05.jpg)

via [Facebook](https://www.facebook.com/photo.php?fbid=10201756684385494)

### 我要怎麼更新 OpenSSL 呢？

根據不同的 Linux Distribution 有不同的更新方式，若有自己客製化一些程式設定，可能就需要自行更新。以下我們簡單介紹更新步驟：

RedHat / CentOS / Fedora 系列更新套件：

    yum update
    yum update openssl #只更新 OpenSSL

Debian / Ubuntu 系列更新套件：

    sudo apt-get update
    sudo apt-get dist-upgrade

若只要更新 OpenSSL 則可以執行以下指令

    sudo apt-get install --only-upgrade openssl
    sudo apt-get install --only-upgrade libssl1.0.0

注意 OpenSSL 是否已經更新為修復的版本：

    rpm -q -a | grep "openssl"  # RedHat
    dpkg -l | grep "openssl"    # Debian

接著請記得撤銷原本的簽章金鑰，重新簽署，並記得提交 CSR (Certificate Signing Request) 給 CA (Certification Authority)。

    openssl req -new -newkey rsa:2048 -nodes -keyout hostname.key -out hostname.csr

結束後記得重新啟動相關服務

    sudo service httpd restart      # RedHat
    sudo service apache2 restart    # Debian

最後再使用檢測工具看自己的網頁伺服器或其他相關服務是否已經不在漏洞受害範圍。

### 我無法更新我的伺服器，我該怎麼在 IDS 偵測攻擊呢？

若你使用 Snort IDS，官方已經釋出 SID 30510 到 30517 來偵測，並且在 Community Rules 中也有包含。
[http://www.snort.org/snort-rules/#community](http://www.snort.org/snort-rules/#community)

{% highlight console %}
# SIDs 30510 through 30517 address detection of the heartbleed attack 

alert tcp $EXTERNAL_NET any -> $HOME_NET 443 (msg:"SERVER-OTHER OpenSSL SSLv3 
heartbeat read overrun attempt"; flow:to_server,established; content:"|18 03 00|"; 
depth:3; dsize:>40; detection_filter:track by_src, count 3, seconds 1; 
metadata:policy balanced-ips drop, policy security-ips drop, service ssl;  
reference:cve,2014-0160; classtype:attempted-recon; sid:30510; rev:2;) 
 
alert tcp $EXTERNAL_NET any -> $HOME_NET 443 (msg:"SERVER-OTHER OpenSSL TLSv1 
heartbeat read overrun attempt"; flow:to_server,established; content:"|18 03 01|"; 
depth:3; dsize:>40; detection_filter:track by_src, count 3, seconds 1; 
metadata:policy balanced-ips drop, policy security-ips drop, service ssl; 
reference:cve,2014-0160; classtype:attempted-recon; sid:30511; rev:2;) 
 
alert tcp $EXTERNAL_NET any -> $HOME_NET 443 (msg:"SERVER-OTHER OpenSSL TLSv1.1 
heartbeat read overrun attempt"; flow:to_server,established; content:"|18 03 02|"; 
depth:3; dsize:>40; detection_filter:track by_src, count 3, seconds 1; 
metadata:policy balanced-ips drop, policy security-ips drop, service ssl; 
reference:cve,2014-0160; classtype:attempted-recon; sid:30512; rev:2;) 
 
alert tcp $EXTERNAL_NET any -> $HOME_NET 443 (msg:"SERVER-OTHER OpenSSL TLSv1.2 
heartbeat read overrun attempt"; flow:to_server,established; content:"|18 03 03|"; 
depth:3; dsize:>40; detection_filter:track by_src, count 3, seconds 1; 
metadata:policy balanced-ips drop, policy security-ips drop, service ssl; 
reference:cve,2014-0160; classtype:attempted-recon; sid:30513; rev:2;) 
 
alert tcp $HOME_NET 443 -> $EXTERNAL_NET any (msg:"SERVER-OTHER SSLv3 large 
heartbeat response - possible ssl heartbleed attempt"; flow:to_client,established; 
content:"|18 03 00|"; depth:3; byte_test:2,>,128,0,relative; detection_filter:track 
by_dst, count 5, seconds 60; metadata:policy balanced-ips drop, policy security-ips 
drop, service ssl; reference:cve,2014-0160; classtype:attempted-recon; sid:30514; 
rev:3;) 
 
alert tcp $HOME_NET 443 -> $EXTERNAL_NET any (msg:"SERVER-OTHER TLSv1 large 
heartbeat response - possible ssl heartbleed attempt"; flow:to_client,established; 
content:"|18 03 01|"; depth:3; byte_test:2,>,128,0,relative; detection_filter:track 
by_dst, count 5, seconds 60; metadata:policy balanced-ips drop, policy security-ips 
drop, service ssl; reference:cve,2014-0160; classtype:attempted-recon; sid:30515; 
rev:3;) 
 
alert tcp $HOME_NET 443 -> $EXTERNAL_NET any (msg:"SERVER-OTHER TLSv1.1 large 
heartbeat response - possible ssl heartbleed attempt"; flow:to_client,established; 
content:"|18 03 02|"; depth:3; byte_test:2,>,128,0,relative; detection_filter:track 
by_dst, count 5, seconds 60; metadata:policy balanced-ips drop, policy security-ips 
drop, service ssl; reference:cve,2014-0160; classtype:attempted-recon; sid:30516; 
rev:3;) 
 
alert tcp $HOME_NET 443 -> $EXTERNAL_NET any (msg:"SERVER-OTHER TLSv1.2 large 
heartbeat response - possible ssl heartbleed attempt"; flow:to_client,established; 
content:"|18 03 03|"; depth:3; byte_test:2,>,128,0,relative; detection_filter:track 
by_dst, count 5, seconds 60; metadata:policy balanced-ips drop, policy security-ips 
drop, service ssl; reference:cve,2014-0160; classtype:attempted-recon; sid:30517; 
rev:3;) 

{% endhighlight %}


### 民眾與管理者應對措施

不少朋友來信、留言洽詢，到底自己該怎麼針對這次的漏洞應變？我們簡單就一般民眾以及系統管理者說明。

### 一般民眾應對措施

* 注意常用的重要網站服務，是否有針對 Heartbleed 漏洞的更新措施。不少大公司都有發出公告、公告信等。
* 若常用網站服務有遭遇此風險，記得更換帳號密碼。
* 若這段時間有網站通知更換密碼，也請注意是否為釣魚信件。
* 注意自己的帳號是否有異常活動。
* 若使用的網站服務就是不更新，**一天一信友善提醒管理者**。

### 系統管理者應對措施

* 更新 OpenSSL 至 1.0.1g 或 1.0.2-beta2，並密切注意有無後續更新。
* 重新產生金鑰（Private Key 可能外洩）、Session（Session ID 可能外洩）、密碼（密碼也可能外洩），並且撤銷原本的金鑰。
* 若無法更新，重新編譯 OpenSSL 以關閉 heartbeat 功能。
* 使用 [Perfect Forward Secrecy (PFS)](http://en.wikipedia.org/wiki/Forward_secrecy)，在未來類似風險發生時減低傷害。

許多業者抱持著僥倖的心態，想說外洩的目標不會輪到自己。如果大家看到這幾天**全世界資安人員 / 駭客不眠不休的撈取資料**，應該會徹底消滅僥倖的想法乖乖做好防護。在漏洞揭露的頭幾天，就已經陸續看到不少駭客進入 Google、Facebook、Yahoo! 等伺服器，並且撰寫大規模掃描工具大量攻擊。除非你有把握自己的伺服器沒有任何連線，不然還是請乖乖更新吧。

### 大事件，大啟示

還記得之前我們提到的「[使用第三方套件所要擔負的資安風險](http://devco.re/blog/2014/03/14/3rd-party-software-security-issues/)」？這次的事件就是一個血淋淋的案例。不管是廠商、社群、個人開發者的粗心失誤，或者是國家機器 NSA 的強力滲透，使用各種第三方的套件都需要承擔極大的風險。但可悲的是，我們卻無法不使用。從這次的事件我們可以學到幾件事情：

1. 不管哪種攻擊手法、多老舊的攻擊手法，在未來都可能會再度發生。
2. 程式碼的 review 非常重要，一定要在開發過程中導入程式碼 review 機制，以免開發者寫出含有安全疑慮的程式碼。
3. 加密、Session 控管、金鑰控管等議題，是永遠的課題。一天沒處理好，在未來的風險中會再度受害。
4. 風險永遠會發生在你猜不到的地方，可能是程式、可能是函式庫、[可能是加密協定](http://technews.tw/2013/09/06/most-common-encryption-protocols-are-useless-against-nsa-surveillance/)、更可能是[亂數產生器](http://ckhung0.blogspot.tw/2014/03/dual-ec-drbg.html)。

不斷的增強資安意識、不停的分享新知、廠商做好資安控管及[安全檢測](http://devco.re/services/penetration-test)、民眾對企業和政府要求資訊安全，集合大家的力量，是改善資安大環境的不二法門。

你以為自己逃過一劫了嗎？也許你的身體已經血流如柱，而嗜血的鯊魚正游向你。