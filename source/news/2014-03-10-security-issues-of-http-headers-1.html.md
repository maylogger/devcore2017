---

title: "HTTP Headers 的資安議題 (1)"
description: "企業主與開發人員越來越重視資安卻常不知該如何著手，戴夫寇爾將於本文多項資安相關的 HTTP headers，以低成本方式強化網站安全性。"
category: "技術專欄"
tags: ["HTTP Header", "Defense"]
author: "bowenhsu"
keywords: "HTTP header, Defense"
---


### 前言

隨著駭客攻擊事件日益漸增，原本經常被大眾所忽視的網站資安問題，現在已經逐漸受到重視。但是，許多企業主或開發人員雖然很想強化網站的安全性，卻不知道該如何從何著手。

企業主通常想到的改善方案是添購資安設備，希望可以一勞永逸。我們姑且先不談「**資訊界沒有永遠的安全**」這件事，企業光是要買到有效的資安設備就是一件令人頭痛的事情，不但要花許多時間聽取廠商的簡報，耗費大筆的經費採購，購買之後還要請員工或原廠技術人員協助調校、設定或教學，否則買了等於沒買。

而對於技術人員來說，若要強化網站安全性，必須先了解駭客如何攻擊，才知道如何建立根本性的防禦機制。但是企業主通常捨不得送員工去參加專業的教育訓練，台灣員工拿的 22k 低薪也低得常常令人捨不得花錢去上課。

如果有一種方式可以增強網站的基本安全性，而且不需要花大錢，又可以讓開發人員不用大幅度變更程式，應該是個皆大歡喜的方案？

READMORE

### 究竟有沒有低成本的簡易防禦方法？

有的！目前各家瀏覽器 (Google Chrome、Firefox、Safari、IE) 其實已經支援許多種資安相關的 HTTP headers。開發人員若在伺服器設定加入某些 headers，瀏覽器收到 response 時就會執行相對應的防禦機制，如此一來可直接提升網頁應用程式的基本安全性。這些 HTTP headers 通常也已被許多常見的 framework 納入爲基本功能，即使開發人員不清楚如何修改伺服器相關設定，也可以依靠 framework 提供的方式來使用這些 headers。因此使用這些 headers 來提升網站安全性就成爲頗具 CP 值的方式。

目前最常見的資安相關 HTTP headers 可參考 [OWASP 網站](https://www.owasp.org/index.php/List_of_useful_HTTP_headers) 所條列的內容：

* Content-Security-Policy (X-Content-Security-Policy、X-Webkit-CSP 都是同一系列)
* Strict-Transport-Security
* X-Content-Type-Options
* X-Frame-Options
* X-XSS-Protection

還有一些其他的資安相關 HTTP headers 也值得注意：

* Access-Control-Allow-Origin
* X-Download-Options
* X-Permitted-Cross-Domain-Policies

最後有一項比較特別的是 Cookie 的安全設定，由於 Cookie 也是 HTTP headers 的一部份，因此本文也將其列出：

* Set-Cookie: HttpOnly
* Set-Cookie: Secure

上述 headers 的數量是不是稍微超過你的想像？其實這些技術早已被很多大公司採用，像是 Google、Facebook、Twitter 等常見的網路服務都可看到這些 headers 的蹤影。下面這張圖片使用 Chrome 的 Inspector 來觀察 Twitter 的 HTTP response 內容：

[![Twitter 的 HTTP reponse](https://lh6.googleusercontent.com/-6dyPHEZZ6RU/UxlujAnSihI/AAAAAAAAAIg/Yq2xC_M4dV8/w1138-h954-no/http-headers-twitter.jpg "Twitter 的 HTTP reponse")](https://lh6.googleusercontent.com/-6dyPHEZZ6RU/UxlujAnSihI/AAAAAAAAAIg/Yq2xC_M4dV8/w1138-h954-no/http-headers-twitter.jpg)

從畫紅線的部分我們可看到 Twitter 在 Cookie 設定了 Secure 與 HttpOnly 這兩個屬性，並且採用了 Strict-Transport-Security、X-Content-Type-Options、X-Frame-Options、X-XSS-Protection 這幾種 headers。

如果覺得用圖形界面太麻煩，也可以使用 command line 的工具來觀察。下面這張圖片使用 curl 來觀察 Facebook 的 HTTP response 內容：

[![Facebook 的 HTTP response](https://lh4.googleusercontent.com/-wKFIH6kIZDk/UxybqPYO60I/AAAAAAAAAI4/t12_TyJz3cA/w1096-h370-no/http-headers-facebook.jpg "Facebook 的 HTTP response")](https://lh4.googleusercontent.com/-wKFIH6kIZDk/UxybqPYO60I/AAAAAAAAAI4/t12_TyJz3cA/w1096-h370-no/http-headers-facebook.jpg)

### 上述資安相關的 headers 想解決哪些問題？

目前這些資安相關的 HTTP headers 想解決的問題主要可分為以下五大類：

* 防禦 XSS (Cross Site Scripting)：
  * Content-Security-Policy
  * Set-Cookie: HttpOnly
  * X-XSS-Protection
  * X-Download-Options
* 防禦 Clickjacking：
  * X-Frame-Options
* 強化 HTTPS 機制：
  * Set-Cookie: Secure
  * Strict-Transport-Security
* 避免瀏覽器誤判文件形態：
  * X-Content-Type-Options
* 保護網站資源別被任意存取：
  * Access-Control-Allow-Origin（此 header 若設定錯誤會適得其反！）
  * X-Permitted-Cross-Domain-Policies

其中 <a href="https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)">XSS</a> 與 [Clickjacking](https://www.owasp.org/index.php/Clickjacking) 是目前常見的攻擊手法，尤其 XSS 目前仍高居 [OWASP Top 10 2013 的第三名](https://www.owasp.org/index.php/Top_10_2013-Top_10)，其嚴重性可見一斑。而在我們執行過的許多[滲透測試](http://devco.re/services/penetration-test)案之中，被我們找出 XSS 弱點的網站高達九成！實在是不能輕忽這些問題。若能降低這些手法攻擊成功的機率，企業的利益就能有更多的安全保障，客戶對企業的信賴亦會更加穩固。

### 目前這些 headers 的使用狀況？

這麼簡便的基本防禦方式，理當廣為企業所採用，因此我們針對 [Alexa Taiwan Top 525](http://www.alexa.com/topsites/countries/TW) 中挑出 513 個可正常使用的網站（咦？一般不是 Top 500 嗎？我沒騙你，[真的有 525](http://www.alexa.com/topsites/countries;20/TW)），調查這些網站是否使用某些常見的 HTTP headers。結果相當令人失望，許多網站都未採用這些 headers。統計數據如下圖：

[![HTTP headers statistic of Alexa Taiwan Top 513](https://lh3.googleusercontent.com/-EGrtPA75hno/Uxy4jyFD9PI/AAAAAAAAAJc/QDhb3lIDtHw/w369-h201-no/http-headers-statistic-alexa-taiwan.png "HTTP headers statistic of Alexa Taiwan Top 513")](https://lh3.googleusercontent.com/-EGrtPA75hno/Uxy4jyFD9PI/AAAAAAAAAJc/QDhb3lIDtHw/w369-h201-no/http-headers-statistic-alexa-taiwan.png)

從統計結果中可發現最多人使用的 HttpOnly 只有 21.25%，排名第二的 X-Frame-Options 也只有 7.80%。而且這些數據尚未將 Google、Twitter 等大公司排除，若將前述國際公司排除後，這些比率恐怕會更低。

不過在上述網站中有不少入口網站、漫畫網站、色情網站，或是公司並非台灣企業，無法反應台灣的使用狀況。恰好在 2012 年 10 月台灣有許多網路服務公司一同成立了 [TIEA 台灣網路暨電子商務產業發展協會](http://www.tieataiwan.org/index.php)，目前網站上的[會員名單](http://www.tieataiwan.org/member.php)中有 116 個會員，其中不少頗具代表性，正好可觀察這些公司營運的網站是否有採用這些 headers。統計數據如下圖：

[![HTTP headers statistic of TIEA](https://lh6.googleusercontent.com/-iG4K8bQRP-U/Uxy4vfPsqPI/AAAAAAAAAJo/x66oSzmqwoM/w369-h201-no/http-headers-statistic-tiea.png "HTTP headers statistic of TIEA")](https://lh6.googleusercontent.com/-iG4K8bQRP-U/Uxy4vfPsqPI/AAAAAAAAAJo/x66oSzmqwoM/w369-h201-no/http-headers-statistic-tiea.png)

很可惜地，所有 headers 的採用率比起上一份數據都還要低。除非公司網站僅使用靜態頁面，網站上沒有任何商業邏輯、帳號、個資，否則應該都要使用合適的 headers 為你的資安防禦工事多築一道牆。

而且由於 meeya 目前沒有正式官網，是直接使用 facebook 粉絲頁作為官網，因此 Content-Security-Policy、Set-Cookie Secure、Strict-Transport-Security、X-Content-Type-Options、X-Frame-Options、X-XSS-Protection 等六項 headers 的統計數量都還要再減一，頓時 Content-Security-Policy 與 Strict-Transport-Security 的總數量皆降至 0 個。此狀況顯示出，即使是在一些台灣主流的網站中，相關營運人員在資安領域仍有許多努力與學習的空間。

許多台灣企業經常顧著衝業績、開發新功能、趕著讓新服務上線，卻忽略了非常重要的基礎資安建設，往往是在遭到攻擊後才大呼損失慘重，甚至是已被滲透了而不自知，其企業利益與民眾個資的保障皆相當令人擔憂。

### 下集預告

接下來本文的續作我們會分幾個篇章詳談各種 headers 的使用方式並介紹實際案例，下一篇將會探討專門防禦 XSS 的 HTTP headers，敬請期待！等不及的朋友們就請先用上面的一些關鍵字自行上網查詢囉！
