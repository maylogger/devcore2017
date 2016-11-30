---

title: "HTTP Session 攻擊與防護"
description: "Session 保護是網站防止使用者帳號被竊的決定要素之一。如果能做好防護，將能防止帳號遭竊，或是在第一時間強制登出網站保護帳號。本文將介紹 Session 攻擊的手法以及防禦的方式，提供給管理者、開發者參考。"
category: "技術專欄"
tags: [PHP, Hijack, Session, Cookie, Defense, XSS]
author: "allenown"
keywords: "Session, Cookie"
og_image: ""
---


### 前言

大家還記得四月份的 [OpenSSL Heartbleed](http://devco.re/blog/2014/04/09/openssl-heartbleed-CVE-2014-0160/) 事件嗎？當時除了網站本身以外，受害最嚴重的就屬 VPN Server 了。國內外不少駭客不眠不休利用 Heartbleed 漏洞竊取 VPN Server 的管理者 Session Cookie，運氣好的話就可以直接登入大企業的內網。

但是，其實這樣的風險是可以避免的，今天我們以開發者的角度來談談 Session 的攻擊與防護。

READMORE

### 什麼是 Session？什麼是 Cookie？

在談 Session 之前，我們要先瞭解 Cookie。你知道網站是如何辨識我們的身份嗎？為什麼我們輸入完帳號密碼之後，網站就知道我們是誰呢？就是利用 Cookie。Cookie 是網站在瀏覽器中存放的資料，內容包括使用者在網站上的偏好設定、或者是登入的 Session ID。網站利用 Session ID 來辨認訪客的身份。

Cookie 既然存放在 Client 端，那就有被竊取的風險。例如透過 [Cross-Site Scripting（跨站腳本攻擊，又稱 XSS）](https://www.owasp.org/index.php/Cross-site_Scripting_%28XSS%29)，攻擊者可以輕易竊取受害者的 Cookie。如果 Cookie 被偷走了，你的身份就被竊取了。

我們可以用一個譬喻來表示：你加入了一個秘密俱樂部，填寫完會員資料後，得到了一張會員卡。之後只要憑這張會員卡，就可以進入這個俱樂部。但是隔天，你的會員卡掉了。撿走你會員卡的人，就可以用你的會員卡進入這個秘密俱樂部，因為會員卡上沒有你的照片或是其他足以辨識身分的資訊。這就像是一個會員網站，我們申請了一個帳號（填寫會員資料加入俱樂部），輸入帳號密碼登入之後，得到一組 Cookie，其中有 Session ID 來辨識你的身分（透過會員卡來辨識身分）。今天如果 Cookie 被偷走了（會員卡被撿走了），別人就可以用你的帳號來登入網站（別人用你的會員卡進入俱樂部）。

Session 攻擊手法有三種：

1. 猜測 Session ID (Session Prediction)
2. 竊取 Session ID (Session Hijacking)
3. 固定 Session ID (Session Fixation)

我們以下一一介紹。


#### Session Prediction (猜測 Session ID)

Session ID 如同我們前面所說的，就如同是會員卡的編號。只要知道 Session ID，就可以成為這個使用者。如果 Session ID 的長度、複雜度、雜亂度不夠，就能夠被攻擊者猜測。攻擊者只要寫程式不斷暴力計算 Session ID，就有機會得到有效的 Session ID 而竊取使用者帳號。

分析 Session ID 的工具可以用以下幾種

1. [OWASP WebScarab](https://www.owasp.org/index.php/Category:OWASP_WebScarab_Project)
2. [Stompy](http://lcamtuf.coredump.cx/soft/stompy.tgz)
3. [Burp Suite](http://portswigger.net/burp/)

觀察 Session ID 的亂數分布，可以了解是否能夠推出規律、猜測有效的 Session ID。

[![分析 Session ID](https://lh4.googleusercontent.com/-0tLscJj_r_E/U3VCmkcvcCI/AAAAAAAAAZo/bChmIZvZZCg/w700-h388-no/2014-05-16-http-session-protection-03-session-id-analysis.jpg "分析 Session ID")](https://lh4.googleusercontent.com/-0tLscJj_r_E/U3VCmkcvcCI/AAAAAAAAAZo/bChmIZvZZCg/s2400/2014-05-16-http-session-protection-03-session-id-analysis.jpg)

Ref: [http://programming4.us/security/3950.aspx](http://programming4.us/security/3950.aspx)

**防護措施**

使用 Session ID 分析程式進行分析，評估是否無法被預測。如果沒有 100% 的把握自己撰寫的 Session ID 產生機制是安全的，不妨使用內建的 Session ID 產生 function，通常都有一定程度的安全。


#### Session Hijacking (竊取 Session ID)

竊取 Session ID 是最常見的攻擊手法。攻擊者可以利用多種方式竊取 Cookie 獲取 Session ID：

1. 跨站腳本攻擊 ([Cross-Site Scripting (XSS)](https://www.owasp.org/index.php/Cross-site_Scripting_%28XSS%29))：利用 XSS 漏洞竊取使用者 Cookie
2. 網路竊聽：使用 ARP Spoofing 等手法竊聽網路封包獲取 Cookie
3. 透過 Referer 取得：若網站允許 Session ID 使用 URL 傳遞，便可能從 Referer 取得 Session ID

竊取利用的方式如下圖：

受害者已經登入網站伺服器，並且取得 Session ID，在連線過程中攻擊者用竊聽的方式獲取受害者 Session ID。

[![竊取 Session ID](https://lh3.googleusercontent.com/-glmPtR_Erp0/U3VCmo0w9yI/AAAAAAAAAZk/4rP1hOOC5W8/w600-no/2014-05-16-http-session-protection-01-session-id-sniffing.png "竊取 Session ID")](https://lh3.googleusercontent.com/-glmPtR_Erp0/U3VCmo0w9yI/AAAAAAAAAZk/4rP1hOOC5W8/s2400/2014-05-16-http-session-protection-01-session-id-sniffing.png)

攻擊者直接使用竊取到的 Session ID 送至伺服器，偽造受害者身分。若伺服器沒有檢查 Session ID 的使用者身分，則可以讓攻擊者得逞。

[![偽造 Session ID](https://lh3.googleusercontent.com/--Si53ercaV0/U3VCmfP_ZKI/AAAAAAAAAZg/-Dirb4AYKGk/w600/2014-05-16-http-session-protection-02-session-id-spoofing.png "偽造 Session ID")](https://lh3.googleusercontent.com/--Si53ercaV0/U3VCmfP_ZKI/AAAAAAAAAZg/-Dirb4AYKGk/s2400/2014-05-16-http-session-protection-02-session-id-spoofing.png)

**防護措施**

* 禁止將 Session ID 使用 URL (GET) 方式來傳遞
* 設定加強安全性的 Cookie 屬性：HttpOnly (無法被 JavaScript 存取)
* 設定加強安全性的 Cookie 屬性：Secure (只在 HTTPS 傳遞，若網站無 HTTPS 請勿設定)
* 在需要權限的頁面請使用者重新輸入密碼

#### Session Fixation (固定 Session ID)

攻擊者誘使受害者使用特定的 Session ID 登入網站，而攻擊者就能取得受害者的身分。

1. 攻擊者從網站取得有效 Session ID
2. 使用社交工程等手法誘使受害者點選連結，使用該 Session ID 登入網站
3. 受害者輸入帳號密碼成功登入網站
4. 攻擊者使用該 Session ID，操作受害者的帳號

[![Session Fixation](https://lh5.googleusercontent.com/-qAizYyaOoRo/U3Vaaw6lqsI/AAAAAAAAAZ4/GNO7z3T6Mjg/w904-h678-no/2014-05-16-http-session-protection-04-session-id-fixation.png "Session Fixation")](https://lh5.googleusercontent.com/-qAizYyaOoRo/U3Vaaw6lqsI/AAAAAAAAAZ4/GNO7z3T6Mjg/s2400/2014-05-16-http-session-protection-04-session-id-fixation.png) 

**防護措施**

* 在使用者登入成功後，立即更換 Session ID，防止攻擊者操控 Session ID 給予受害者。
* 禁止將 Session ID 使用 URL (GET) 方式來傳遞

### Session 防護

那要怎麼防範攻擊呢？當然會有人說，會員卡不要掉不就沒事了嗎？當然我們沒辦法確保用戶不會因為各種方式導致 Cookie 遭竊（XSS、惡意程式等），因此最後一道防線就是網站的 Session 保護。一張會員卡上如果沒有任何可識別的個人資料，當然任何人撿去了都可以用。如果上面有照片跟簽名呢？偷走會員卡的人在進入俱樂部的時候，在門口就會因為照片跟本人不符而被擋下來。Session 保護也是一樣，怎麼讓我們的 Session 保護機制也能辨識身分呢？答案是利用每個使用者特有的識別資訊。

每個使用者在登入網站的時候，我們可以用每個人特有的識別資訊來確認身分：

1. 來源 IP 位址
2. 瀏覽器 User-Agent

如果在同一個 Session 中，使用者的 IP 或者 User-Agent 改變了，最安全的作法就是把這個 Session 清除，請使用者重新登入。雖然使用者可能因為 IP 更換、Proxy 等因素導致被強制登出，但為了安全性，便利性必須要與之取捨。以 PHP 為例，我們可以這樣撰寫：

{% highlight php %}

if($_SERVER['REMOTE_ADDR'] !== $_SESSION['LAST_REMOTE_ADDR'] || $_SERVER['HTTP_USER_AGENT'] !== $_SESSION['LAST_USER_AGENT']) {
   session_destroy();
}
session_regenerate_id();
$_SESSION['LAST_REMOTE_ADDR'] = $_SERVER['REMOTE_ADDR'];
$_SESSION['LAST_USER_AGENT'] = $_SERVER['HTTP_USER_AGENT'];

{% endhighlight %}

除了檢查個人識別資訊來確認是否盜用之外，也可以增加前述的 Session ID 的防護方式：

1. Cookie 設定 Secure Flag (HTTPS)
2. Cookie 設定 HTTP Only Flag
3. 成功登入後立即變更 Session ID

Session 的清除機制也非常重要。當伺服器偵測到可疑的使用者 Session 行為時，例如攻擊者惡意嘗試偽造 Session ID、使用者 Session 可能遭竊、或者逾時等情況，都應該立刻清除該 Session ID 以免被攻擊者利用。

Session 清除機制時機：

1. 偵測到惡意嘗試 Session ID 
2. 識別資訊無效時
3. 逾時

### 管理者有避免使用者帳號遭竊的責任

使用者帳號遭竊一直以來都是顯著的問題，但卻鮮少有網站針對 Session 的機制進行保護。攻擊者可以輕鬆使用 [firesheep](http://codebutler.github.io/firesheep/) 之類的工具竊取帳號。國外已經有不少網站偵測到 Session 可能遭竊時將帳號強制登出，但國內目前還鮮少網站實作此防禦，設備商的 Web 管理介面更少針對 Session 進行保護。如果 VPN Server 等設備有偵測 Session ID 的偽造，在 [OpenSSL Heartbleed](http://devco.re/blog/2014/04/11/openssl-heartbleed-how-to-hack-how-to-protect/) 事件時就不會有那麼慘重的損失了。

立刻把自己的網站加上 Session 保護機制吧！

