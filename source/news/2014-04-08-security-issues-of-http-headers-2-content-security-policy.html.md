---
layout: post
title: "Content-Security-Policy - HTTP Headers 的資安議題 (2)"
description: "Content-Security-Policy 主要目的是用來防止 Cross-Site Scripting (XSS) 跟網頁樣式置換，本文將介紹 Content-Security-Policy 的使用方式、實際使用案例、常見誤用案例。"
category: "技術專欄"
tags: ["HTTP Header", "Defense", "JavaScript", "XSS"]
author: "bowenhsu"
keywords: "HTTP header,Defense,JavaScript,XSS"
---


### Content-Security-Policy

還記得在上一篇 [HTTP headers 的資安議題 (1)](http://devco.re/blog/2014/03/10/security-issues-of-http-headers-1/) 文章中，我們提到了多種資安相關的 HTTP headers 嗎？接下來的幾篇文章我們會介紹幾個專門對付 XSS 的 HTTP headers，首先就由 Content-Security-Policy 打頭陣。

[Content-Security-Policy](https://www.owasp.org/index.php/Content_Security_Policy)（以下簡稱 CSP）是從 2010 年被提出來的一項 Web 規格，主要目的是用來防止 Cross-Site Scripting（以下簡稱 XSS）跟網頁樣式置換（例如[科技部被惡搞](http://udn.com/NEWS/NATIONAL/NAT5/8554327.shtml)就是一個最好的例子）。經過五年發展，CSP 1.0 已從 W3C 的 TR (Technical Report) 變成 [Candidate Recommendation](http://www.w3.org/TR/CSP/)，應該不久就會將成為 W3C 推薦標準。新的 [CSP 1.1](http://w3c.github.io/webappsec/specs/content-security-policy/csp-specification.dev.html) 則仍在草案階段。

CSP 家族龐大，總共有三個類別，六個項目：

* Content-Security-Policy
* Content-Security-Policy-Report-Only
* X-Content-Security-Policy
* X-Content-Security-Policy-Report-Only
* X-WebKit-CSP
* X-WebKit-CSP-Report-Only

在 CSP 發展初期，主流瀏覽器並未全部依照同一標準來開發，因此發展成這三種類別。目前由於 CSP 1.0 即將成為標準，大多數瀏覽器已支援 Content-Security-Policy 這個類別，因此狀況已逐漸收斂。主流瀏覽器的支援列表如下圖：

[![Content-Security-Policy 瀏覽器支援列表](https://lh3.googleusercontent.com/-qJvtcG9lvq8/Ux6DrOeqNhI/AAAAAAAAALQ/gzQ2EbNrOHA/w531-h105-no/csp-browser-support-list.png "Content-Security-Policy 瀏覽器支援列表")](https://lh3.googleusercontent.com/-qJvtcG9lvq8/Ux6DrOeqNhI/AAAAAAAAALQ/gzQ2EbNrOHA/w531-h105-no/csp-browser-support-list.png "Content-Security-Policy 瀏覽器支援列表")

從列表中可看到，只要使用 Content-Security-Policy 與 X-Content-Security-Policy 就已有很高的覆蓋率，除非要支援 Safari 6，否則不用特意使用 X-WebKit-CSP。更詳細的瀏覽器支援列表可參考 [Can I use](http://caniuse.com/contentsecuritypolicy)。

READMORE

### CSP 1.0 主要作用

* 載入來源白名單

  宣告一組受信任的白名單與資源種類（如 JavaScript, CSS, image 等等），使瀏覽器只能從此白名單中載入資源，藉此防止攻擊者從外部引入含有惡意程式碼的資源。

  例：Content-Security-Policy: default-src 'self'; script-src 'self' http://js.devco.re; style-src 'self' http://css.devco.re; img-src 'self' data:; frame-src 'none'

  效果：限定 script 資源只能從 http://js.devco.re 載入；限定 style 資源只能從 http://css.devco.re 載入；限定 img 只能從相同 domain 載入，並且支援 data scheme；限定 frame 不能從任何來源載入；除了 script、style、img、frame 之外的資源，則只能從同樣 domain 以及同樣協定的來源載入。

* 禁止 inline 程式碼

  一般人開發網站時為求便利，經常會在 HTML 中寫入一些 inline 程式碼，但攻擊者意圖入侵網站時也常用此手法。然而瀏覽器其實無法分辨這些 inline 程式碼究竟是開發人員寫的，還是攻擊者植入的。因此 CSP 乾脆強迫開發者必須把所有 inline 程式碼移到外部檔案，完全杜絕在 HTML 中出現 inline 程式碼的狀況。因此除非你在 CSP 宣告時有註明 'unsafe-inline'，否則 CSP 預設禁止使用 inline script 或 inline CSS。

  例：Content-Security-Policy: default-src 'self'; script-src 'unsafe-inline'

* 禁止 eval 函式

  eval() 對許多開發者來說一直是個非常方便的函式，然而若缺乏資安觀念，使用此函式時很可能會導致潛在的 XSS 風險。因此除非你在 CSP 宣告時有註明 'unsafe-eval'，否則 CSP 預設禁止使用 eval() 函式。

  例：Content-Security-Policy: default-src 'self'; script-src 'unsafe-eval'

* 防止 sniffer

  由於 CSP 可指定載入資源時強制使用 https 協定，因此可降低被 sniffing 的機率。

  例：Content-Security-Policy: default-src http://devco.re; img-src https:

  效果：限定圖片只能從 https 協定載入，不限定 domain。而除了圖片之外的資源則可從任意來源載入。

### CSP Demo

下面這一段程式碼，使用 default-src * 讓相關資源可正常顯示：
{% highlight php %}
<?php
header("Content-Security-Policy: default-src *");
?>

<html>
    <head>
        <title>CSP Demo Site</title>
    </head>
    <body>
        <h3>Content Security Policy Demo Site</h3>
        <img width="200" height="200" src="http://devco.re/assets/themes/devcore/images/double-sticker.png"></img>
        <iframe frameborder='0' width='300' height='200' src='http://www.youtube.com/embed/E-BGf1MwecU'></iframe>
    </body>
</html>
{% endhighlight %}

[![使用最寬鬆的 Content-Security-Policy 規則](https://lh3.googleusercontent.com/-DVXEu8Xe4GQ/Ux6DqiVHyBI/AAAAAAAAALU/88qSfa5aJkY/w754-h633-no/csp-demo-1.png "使用最寬鬆的 Content-Security-Policy 規則")](https://lh3.googleusercontent.com/-DVXEu8Xe4GQ/Ux6DqiVHyBI/AAAAAAAAALU/88qSfa5aJkY/w754-h633-no/csp-demo-1.png "使用最寬鬆的 Content-Security-Policy 規則")

接下來我們將 php header 的那一行程式碼修改如下並且 reload 瀏覽器頁面：
{% highlight php %}
<?php
header("Content-Security-Policy: default-src *; img-src https:; frame-src 'none'");
?>
{% endhighlight %}

[![使用 Content-Security-Policy 限制 img 與 frame 的來源](https://lh5.googleusercontent.com/-iisyWwpo5IY/Ux6Dqn3FBgI/AAAAAAAAALM/MahpofJ2sK0/w754-h633-no/csp-demo-2.png "使用 Content-Security-Policy 限制 img 與 frame 的來源")](https://lh5.googleusercontent.com/-iisyWwpo5IY/Ux6Dqn3FBgI/AAAAAAAAALM/MahpofJ2sK0/w754-h633-no/csp-demo-2.png "使用 Content-Security-Policy 限制 img 與 frame 的來源")

使用 CSP 限制 img 與 frame 的來源種類後，我們可以從上圖 Chrome Inspector 的紅字觀察到，網站的圖片與 iframe 影片已被瀏覽器擋掉，無法載入。

如果擔心直接使用 CSP 會影響網站營運，但又想嘗試 CSP，可以先使用 Content-Security-Policy-Report-Only，示範如下：

{% highlight php %}
<?php
header("Content-Security-Policy-Report-Only: default-src *; img-src https:; frame-src 'none'; report-uri http://devco.re/demo");
?>
{% endhighlight %}

[![Content-Security-Policy-Report-Only](https://lh5.googleusercontent.com/-zLXj9r2aIxc/UyGO-Bzi_5I/AAAAAAAAANU/nbwz6lAfTLc/w754-h594-no/csp-demo-report-only.png "Content-Security-Policy-Report-Only")](https://lh5.googleusercontent.com/-zLXj9r2aIxc/UyGO-Bzi_5I/AAAAAAAAANU/nbwz6lAfTLc/w754-h594-no/csp-demo-report-only.png "Content-Security-Policy-Report-Only")

由上圖可以看到，此 header 不會直接阻擋不符合 CSP 規範的資源，但是會根據使用者所違反的規則發送相對應的 POST request 至指定的 URI，發送內容如下：

{% highlight json %}
{
  "csp-report": {
    "blocked-uri":"http://devco.re/",
    "document-uri":"http://yoursite.com/csp.php",
    "original-policy":"default-src *; img-src https:; frame-src 'none'; report-uri http://devco.re/demo",
    "referrer":"",
    "status-code":200,
    "violated-directive":"img-src https:"
  }
}
{% endhighlight %}

由發送內容可看出這個 request 因為違反了「img-src https:」規則而將「http://devco.re/」這個來源擋掉。經由此方式，可一邊修改網站一邊觀察是否仍有不符合 CSP 規範之處，等到所有違規的內容都修正完畢後，再將 CSP 套用到正式上線環境。

由於宣告方式非常多種，在這邊就不一一條列，若有興趣可前往 [Content Security Policy Reference & Examples](http://content-security-policy.com/)、[Using Content Security Policy - Security \| MDN](https://developer.mozilla.org/en-US/docs/Security/CSP/Using_Content_Security_Policy) 等網頁，有更完整的使用情境與範例可供參考。另外也有 [Slide](http://benvinegar.github.io/csp-talk-2013/) (by Ben Vinegar) 跟 [YouTube 影片](https://www.youtube.com/watch?v=pocsv39pNXA) (by Adam Barth) 可參考。

若欲使用 CSP 卻一直未能成功時，可到 [Content Security Policy Playground](http://www.cspplayground.com/csp_validator) 驗證您所寫的設定是否正確。

### CSP 實際使用案例

目前採用 CSP 的案例較少，比較知名的使用案例是 [GitHub](https://github.com/)，在 2013 年 4 月 [GitHub 還寫了一篇專文](https://github.com/blog/1477-content-security-policy)公告表示他們已開始採用 CSP。另外一個案例廠商可能較廣為人知，是在 2013 年當紅的免費儲存空間 [MEGA](https://mega.co.nz/)。兩個案例的實際內容可見於下圖：

[![GitHub 與 MEGA 使用 CSP 後的 HTTP response](https://lh4.googleusercontent.com/-WPU1UT9T6WA/Ux6DrfiQ_EI/AAAAAAAAALc/s0XmlPFKmoc/w1169-h758-no/http-headers-github-and-mega.jpg "GitHub 與 MEGA 使用 CSP 後的 HTTP response")](https://lh4.googleusercontent.com/-WPU1UT9T6WA/Ux6DrfiQ_EI/AAAAAAAAALc/s0XmlPFKmoc/w1169-h758-no/http-headers-github-and-mega.jpg "GitHub 與 MEGA 使用 CSP 後的 HTTP response")

另一項知名使用案例是 Google 明定[開發 Chrome Extension 時必須使用 CSP](http://developer.chrome.com/extensions/contentSecurityPolicy)，以追求更高的安全性。Mozilla 也在 [MozillaWiki 開了一頁](https://wiki.mozilla.org/Security/CSP/Specification)存放相關技術細節。若您想觀察其他使用案例，可使用 Chrome Inspector 或 curl 觀察以下幾個網站：[LastPass](https://lastpass.com/)，[Twitter Help Center](https://support.twitter.com/)，[Adblock Plus](https://adblockplus.org/en/chrome)，[Sendsafely](https://www.sendsafely.com/)，[LikeAlyzer](http://likealyzer.com/)。

### CSP 常見誤用案例

* directives 後面不需加冒號

  錯誤：default-src: 'self'

  正確：**default-src 'self'**

* directives 之間以分號區隔

  錯誤：default-src 'self', script-src 'self'

  正確：**default-src 'self'; script-src 'self'**

* 多個 source 之間僅以空白區隔

  錯誤：default-src 'self'; img-src 'self', img1.devco.re, img2.devco.re

  正確：**default-src 'self'; img-src 'self' img1.devco.re img2.devco.re**

* 某些 source 必須加冒號（https:、data:）

  錯誤：default-src 'self'; img-src 'self' https data

  正確：**default-src 'self'; img-src 'self' https: data:**

* 某些 source 必須用單引號括起來（'none'、'self'、'unsafe-inline'、'unsafe-eval'）

  錯誤：script-src self unsafe-inline unsafe-eval

  正確：**script-src 'self' 'unsafe-inline' 'unsafe-eval'**

### 結論

使用 CSP 可以有效提升攻擊難度，讓許多常見的 XSS 攻擊失效，是一個非常推薦開發者使用的 HTTP header。但由於目前的開發者在 HTML 裡面寫 inline script 及 inline CSS 的比例非常高，同時也有一些網路服務預設都需要使用 inline script（例如 Google Analytics，相關解法可參考[這裡](http://stackoverflow.com/questions/3870345/new-google-analytics-code-into-external-file)），因此要享受這樣的安全之前，可能需要先付出許多時間與心力將網站大幅整理，套用 CSP 規範後網頁才能正常運作。