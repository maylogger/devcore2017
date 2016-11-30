---
title: "奇優廣告 Qiyou 廣告手法剖析"
description: "廣告網站為了增加廣告曝光度以及點擊率，使用各種複雜多變的手法顯示廣告。戴夫寇爾將於本文分析奇優廣告 Qiyou 是如何利用 JavaScript 控制滑鼠事件顯示廣告。"
category: "案例剖析"
tags: [JavaScript, Hijack]
author: "allenown"
keywords: "Clickjacking, Qiyou, Hijack"
og_image: ""
---


歡迎來到我們的技術文章專欄！

今天我們來談談「廣告顯示手法」。不少廣告商為了要增加廣告的曝光以及點擊率，會使用各種手法強迫使用者顯示廣告。例如彈出式視窗、內嵌廣告、強制跳轉等等。但這樣的手法有什麼好提的呢？今天有一個很特別的案例，讓我們來看看一個網站「[1kkk.com 極速漫畫](http://1kkk.com)」。

![奇優廣告 Qiyou 廣告手法剖析 - 1kkk.com](https://lh4.googleusercontent.com/4pevslM2QNBVcXug76t7MCziPk5ms9U1gK76fXqLyQ=w839-h634-no "奇優廣告 Qiyou 廣告手法剖析 - 1kkk.com")
這是一個常見的網路漫畫網站，接著點擊進去漫畫頁面。
READMORE
![奇優廣告 Qiyou 廣告手法剖析 - 1kkk.com 漫畫頁面](https://lh6.googleusercontent.com/-Q9pSLJQc0Ak/Uxf8YrS0tNI/AAAAAAAAAHQ/lZNQcky2r8k/w839-h634-no/blog_qiyou_hijack_03.png "奇優廣告 Qiyou 廣告手法剖析 - 1kkk.com 漫畫頁面")
網站中充斥著煩人的廣告，並且突然一閃而過 Safari 的「閱讀列表」動畫。怎麼會突然這樣呢？讓我們打開「閱讀列表」一探究竟。

![奇優廣告 Qiyou 廣告手法剖析 - Safari 顯示閱讀側邊欄](https://lh6.googleusercontent.com/-4s9QKuK9ANs/Uxf8ZVeIr-I/AAAAAAAAAHE/C06SoY1VyMI/w262-h525-no/blog_qiyou_hijack_04.png "奇優廣告 Qiyou 廣告手法剖析 - Safari 顯示閱讀側邊欄")
![奇優廣告 Qiyou 廣告手法剖析 - Safari 閱讀列表被放置廣告 URL](https://lh6.googleusercontent.com/-gWdJCWw41dY/Uxf8ZtMwpuI/AAAAAAAAAHM/m9WbSBbnJSM/w839-h634-no/blog_qiyou_hijack_05.png "奇優廣告 Qiyou 廣告手法剖析 - Safari 閱讀列表被放置廣告 URL")

打開閱讀列表之後，我們赫然發現裡面被加了非常多廣告的頁面！

可以看以下影片示範：
{% youtube E-BGf1MwecU %}

這是怎麼做到的呢？就是一種利用 JavaScript 控制滑鼠點擊的變形應用。點選「網頁檢閱器」或是「開發者工具」，會看到一段奇怪的 JavaScript 控制滑鼠的點擊行為。

![奇優廣告 Qiyou 廣告手法剖析 - 廣告 JavaScript](https://lh6.googleusercontent.com/-Ngnx2PsIyNw/Uxf8ZtZtfSI/AAAAAAAAAHU/NEvZLh6a09M/w795-h634-no/blog_qiyou_hijack_06.png "奇優廣告 Qiyou 廣告手法剖析 - 廣告 JavaScript")

分析節錄後的 code 如下：

{% highlight html %}<!DOCTYPE html>
<html>
<head>
  <script>
    var force_add_url_to_readinglist = function (target_url) {
      try {
        var fake_element = document.createElement('a');
        fake_element.setAttribute('href', target_url);
        fake_element.setAttribute('style', 'display:none;');

        // https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent
        var fake_event = document.createEvent('MouseEvents');
        fake_event.initMouseEvent('click', false, false, window, 0, 0, 0, 0, 0, false, false, true, false, 0, null);
        fake_element.dispatchEvent(fake_event);

      } catch ( error ) {
        // nothing.
      }
    };

    var url = 'http://google.com/?' + Math.random().toString().substr(1);
    force_add_url_to_readinglist(url);
  </script>
</head>

<body>

  <h1>Test: FORCE_ADD_URL_TO_READINGLIST</h1>

</body>
</html>
{% endhighlight %}


利用「[initMouseEvent](https://developer.mozilla.org/en-US/docs/Web/API/event.initMouseEvent)」模擬滑鼠的點擊，在 URL 上按下 Shift 鍵點擊。在一般瀏覽器中是「開啟新視窗」，在 Safari 中則是「加入閱讀清單」了，因此形成廣告視窗不斷加入閱讀清單的現象。廣告商利用這種手法增加廣告的點擊率，只要瀏覽器沒有安裝阻擋廣告的套件或者是阻擋「彈出式視窗」，你就會成為流量的貢獻者。

經過我們的測試，Internet Explorer、Mozilla Firefox 不會受這類攻擊影響，Google Chrome、Opera 則會被內建的 Pop-up 視窗阻擋功能擋下。但若是直接模擬點擊，則全數瀏覽器都會受影響導向至 URL。雖然這種類型的攻擊不會造成實質上的損失跟危害，但若是結合其他惡意手法將可以造成攻擊。例如透過網站掛碼將使用者導向至惡意網站等等。

若要避免此類型攻擊，有以下幾個建議方案：

1. 安裝 NoScript 類型套件，僅允許可信賴的網站執行 JavaScript
1. 開啟「彈出式視窗」阻擋功能，並將網站安全性等級提高。
1. 安裝 AdBlock 等廣告阻擋套件（但會影響網站營收）
1. 使用最新版本瀏覽器以策安全

網頁型的攻擊越來越多樣化，除了依賴瀏覽器本身的保護並輔以第三方安全套件之外，更需要使用者本身的安全意識，才能安心暢快的瀏覽網路！
