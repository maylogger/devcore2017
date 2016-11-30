---

title: "HttpOnly - HTTP Headers 的資安議題 (3)"
description: "HttpOnly 主要目的是禁止 JavaScript 直接存取 cookie，以避免他人盜用使用者的帳號。本文將介紹 HttpOnly 的使用方式、實際使用案例。"
category: "技術專欄"
tags: ["HTTP Header", "Defense", "JavaScript", "XSS"]
author: "bowenhsu"
keywords: "HTTP header,Defense,JavaScript,XSS"
---


上次我們提到了 [Content-Security-Pilicy](http://devco.re/blog/2014/04/08/security-issues-of-http-headers-2-content-security-policy/)，這次我們來聊聊同樣是為了防禦 XSS 而生的另一個技術。

### HttpOnly 簡介

Cookie 的概念雖然早在 1994 年就由 Netscape 的工程師 Montulli 提出，但當時仍未有完善的防護機制，像是 HttpOnly、Secure 等規範都是後來陸續被提出，直到 2011 年 4 月才在 [RFC 6265](http://tools.ietf.org/html/rfc6265) 中正式定案。而其中的 [HttpOnly](https://www.owasp.org/index.php/HttpOnly) 是專門為了抵禦攻擊者利用 Cross-Site Scripting (XSS) 手法來盜取用戶身份，此項 Cookie 防護設定應該是在 HTTP Headers 系列文中最廣為人知的項目。

### HttpOnly 主要作用

說明 HttpOnly 主要作用之前，先談談 XSS 最常見的利用方式。XSS 攻擊早在 1990 年就被發現，此攻擊手法最常見的利用方式是存取使用者的 cookie 來獲得一些機敏資料。像是存取 session cookie 即可盜用使用者的身份（關於 session 的重要性，可以參考我們部落格的另一篇文章 [HTTP Session 攻擊與防護](http://devco.re/blog/2014/06/03/http-session-protection/)），如果在 cookie 中記錄了其他機敏資訊，也可能會一併遭竊。因此若能阻止攻擊者存取帶有敏感資料的 cookie，就能減少 XSS 對使用者的影響，因而催生了 HttpOnly 機制。

READMORE

當 cookie 有設定 HttpOnly flag 時，瀏覽器會限制 cookie 只能經由 HTTP(S) 協定來存取。因此當網站有 XSS 弱點時，若 cookie 含有 HttpOnly flag，則攻擊者無法直接經由 JavaScript 存取使用者的 session cookie，可降低使用者身份被盜用的機率。早期有些瀏覽器未完整實作 HttpOnly 所有功能，因此攻擊者仍可透過 XMLHttpRequest 讀取 cookie，但最近幾年各大瀏覽器也陸續阻擋了這個方式。因此 HttpOnly 可有效降低 XSS 的影響並提升攻擊難度。目前瀏覽器的支援列表如下：

[![HttpOnly 瀏覽器支援列表](https://lh3.googleusercontent.com/-ryadJ4jta9o/UyGPRxYv-CI/AAAAAAAAAOA/ch-pNUJQcAs/w531-h122-no/httponly-browser-support-list.png "HttpOnly 瀏覽器支援列表")](https://lh3.googleusercontent.com/-ryadJ4jta9o/UyGPRxYv-CI/AAAAAAAAAOA/ch-pNUJQcAs/w531-h122-no/httponly-browser-support-list.png)

其他瀏覽器支援列表以及各家程式語言使用 HttpOnly 的方式可參考 [OWASP HttpOnly](https://www.owasp.org/index.php/HttpOnly)。

### HttpOnly Demo

以下使用 PHP 程式碼為例：

{% highlight php %}
<?php
session_start();
?>

<html>
    <head>
        <title>HttpOnly Demo</title>
    </head>
    <body>
        <h3>HttpOnly Demo</h3>
        <p>If you didn't set HttpOnly flag, cookie will write down by document.write().</p>
        <script>
            document.write(document.cookie);
        </script>
    </body>
</html>
{% endhighlight %}

[![未設定 HttpOnly 之前，cookie 可被 JavaScript 存取](https://lh5.googleusercontent.com/-nH-7Pn8flY8/U5bZqr_TQQI/AAAAAAAAAcA/NX1xS-C0-Bc/w1138-h687-no/httponly-unset.png "未設定 HttpOnly 之前，cookie 可被 JavaScript 存取")](https://lh5.googleusercontent.com/-nH-7Pn8flY8/U5bZqr_TQQI/AAAAAAAAAcA/NX1xS-C0-Bc/w1138-h687-no/httponly-unset.png)

在上圖中可看到 PHPSESSID 已成功被 JavaScript 存取，這也意味著網站有 XSS 弱點時，使用者的身份有較高的機率被盜用。為了使用 HttpOnly 進行防護，讓我們將 PHP 程式碼修改如下：

{% highlight php %}
<?php
ini_set("session.cookie_httponly", 1);
session_start();
?>
{% endhighlight %}

[![設定 HttpOnly 後，cookie 已無法被 JavaScript 存取](https://lh5.googleusercontent.com/-xIuTi9W726o/U5bZqbseCGI/AAAAAAAAAb8/byQawQzceR4/w1138-h687-no/httponly-set.png "設定 HttpOnly 後，cookie 已無法被 JavaScript 存取")](https://lh5.googleusercontent.com/-xIuTi9W726o/U5bZqbseCGI/AAAAAAAAAb8/byQawQzceR4/w1138-h687-no/httponly-set.png)

我們可以使用畫面中右上角的 Chrome [Edit This Cookie 套件](https://chrome.google.com/webstore/detail/edit-this-cookie/fngmhnnpilhplaeedifhccceomclgfbg) 看到 HttpOnly 已經被勾選（如紅框處），並且 PHPSESSID 已無法被 JavaScript 存取，不存在於 HTML 中。

> 目前 PHP 官方的教學是用 session_set_cookie_params 這個 function，可參考[官方網頁的這篇說明](http://www.php.net/manual/en/function.session-set-cookie-params.php)

### HttpOnly 實際使用案例

由於 HttpOnly 的使用方式較簡單，因此僅列舉幾個站台的使用結果圖片給大家參考，就不另外多做說明囉！

* T客邦 (www.techbang.com)，有設定 HttpOnly

[![T客邦](https://lh3.googleusercontent.com/-s1rI18BhecY/U5bZpKzCjNI/AAAAAAAAAbw/EuIjX4R9AW8/w1138-h882-no/httponly-example-1.png "T客邦")](https://lh3.googleusercontent.com/-s1rI18BhecY/U5bZpKzCjNI/AAAAAAAAAbw/EuIjX4R9AW8/w1138-h882-no/httponly-example-1.png)

* 愛料理 (icook.tw)，有設定 HttpOnly

[![愛料理](https://lh4.googleusercontent.com/-S3uBr-D6xQ8/U5bZpT5WM0I/AAAAAAAAAbs/IQnqvUy7jJw/w1138-h882-no/httponly-example-2.png "愛料理")](https://lh4.googleusercontent.com/-S3uBr-D6xQ8/U5bZpT5WM0I/AAAAAAAAAbs/IQnqvUy7jJw/w1138-h882-no/httponly-example-2.png)

* Mobile01 (www.mobile01.com)，未設定 HttpOnly

[![Mobile01](https://lh6.googleusercontent.com/-1mN1msqkvwg/U5bZpWDOj9I/AAAAAAAAAbo/6g4rHi0q_uk/w1138-h882-no/httponly-example-3.png "Mobile01")](https://lh6.googleusercontent.com/-1mN1msqkvwg/U5bZpWDOj9I/AAAAAAAAAbo/6g4rHi0q_uk/w1138-h882-no/httponly-example-3.png)

* Giga Circle (tw.gigacircle.com)，未設定 HttpOnly

[![Giga Circle](https://lh5.googleusercontent.com/-xX9qAnudjV8/U5bZqCN2FLI/AAAAAAAAAb4/srsZFwPfeRc/w1138-h882-no/httponly-example-4.png "Giga Circle")](https://lh5.googleusercontent.com/-xX9qAnudjV8/U5bZqCN2FLI/AAAAAAAAAb4/srsZFwPfeRc/w1138-h882-no/httponly-example-4.png)

### 結論

HttpOnly 是存在已久的技術，但在我們[系列文第一篇](http://devco.re/blog/2014/03/10/security-issues-of-http-headers-1/)的統計當中，採用的比例仍然偏低。如同之前我們提及的 [Zone Transer](http://devco.re/blog/2014/05/05/zone-transfer-CVE-1999-0532-an-old-dns-security-issue/) 問題，即使一項資安技術或資安議題存在很久，也需要大家持續關注。

但即使採用了 HttpOnly，也僅能防止惡意人士不正當存取 cookie，無法防禦其他的 XSS 攻擊方式，例如將使用者導向至釣魚網站騙取個資、導向至惡意網站植入後門、置換網頁外觀等等。同時未來仍有可能出現新的 XSS 攻擊手法，因此千萬別因設定了 HttpOnly 就掉以輕心，誤以為不會再被 XSS 手法侵害企業利益或用戶資料，仍然必須謹慎檢查每一個系統輸出輸入點，以避免未來因上述影響導致用戶或企業蒙受損失。