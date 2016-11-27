---
layout: post
title: "如何正確的取得使用者 IP？"
description: "很多網站都有取得使用者 IP 的功能，但是到底有多少網站寫的是對的？網路上又有多少錯誤的教學？本文將介紹利用 HTTP Header 偽造 IP 的方式，以及如何安全、正確取得 IP 的教學。"
category: "技術專欄"
tags: ["HTTP Header", "Defense", "PHP"]
author: "allenown"
keywords: "HTTP Header"
---


[![公車站牌的 IP](https://farm7.staticflickr.com/6220/6250089499_da2fb7a973_z.jpg)](https://farm7.staticflickr.com/6220/6250089499_f908fcb990_o.jpg)
<!-- Photo Credit: https://www.flickr.com/photos/kevandotorg/6250089499/ -->

很多網站都會有偵測使用者 IP 的功能，不管是判斷使用者來自哪邊，或者是記錄使用者的位置。但是你知道嗎？網路上大多數的教學全部都是「錯誤」的。正確的程式寫法可以確保知道訪客的 IP，但是錯誤的寫法卻可能讓網站管理者永遠不知道犯罪者的來源。

這次我們單就偵測 IP 的議題來探討各種錯誤的寫法。

READMORE

### 你知道網路上的教學是不安全的嗎？

我們先來看一下網路上的教學，讓我們 Google 找一下「[PHP 取得 IP](https://www.google.com.tw/search?q=php+取得+ip)」，就可以看到許多人熱心的教學，我們隨意挑一個常見的教學來看看。

以 PHP 為例：

{% highlight php %}

<?php
if(!empty($_SERVER['HTTP_CLIENT_IP'])){
   $myip = $_SERVER['HTTP_CLIENT_IP'];
}else if(!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){
   $myip = $_SERVER['HTTP_X_FORWARDED_FOR'];
}else{
   $myip= $_SERVER['REMOTE_ADDR'];
}
echo $myip;
?>

{% endhighlight %}

以 ASP.NET 為例：

{% highlight c# %}

Dim ClientIP As String = Request.ServerVariables("HTTP_X_FORWARDED_FOR") 
IF ClientIP = String.Empty Then 
 ClientIP = Request.ServerVariables("REMOTE_ADDR") 
End IF

{% endhighlight %}

這是一個很基本的寫法、很正確的想法，如果 HTTP Header 中包含「Client-IP」，就先以他當作真實 IP。若包含「X-Forwarded-For」，則取他當作真實 IP。若兩者都沒有，則取「REMOTE_ADDR」變數作為真實 IP。因為當使用者連線時透過代理伺服器時，REMOTE_ADDR 會顯示為代理伺服器 Proxy 的 IP。部分代理伺服器會將使用者的原始真實 IP 放在 Client-IP 或 X-Forwarded-For header 中傳遞，如果在變數中呼叫則可以取得真實 IP。

但是你知道嗎？**網路上 80% 的教學寫法全部都是「錯誤」的。**

為什麼這樣說呢？請大家記得一件事情：「**任何從客戶端取得的資料都是不可信任的！**」

### 竄改 HTTP Header

「X-Forwarded-For」這個變數雖然「有機會」取得使用者的真實 IP，但是由於這個值是從客戶端傳送過來的，所以「有可能」被使用者竄改。

舉例來說，我寫了一個小程式，偵測這些常見的 HTTP Header 判斷 IP。並且使用 [Burp Suite](http://portswigger.net/burp/) 這個工具來修改 HTTP Request。

[![顯示目前 IP 以及相關 header](https://lh4.googleusercontent.com/-OLYyle4PQ48/U5lB8SLR_DI/AAAAAAAAAc4/yHvzlGfNAAs/w897-h678-no/2014-06-12-client-ip-detection-01-detech-user-ip.png "顯示目前 IP 以及相關 header")](https://lh4.googleusercontent.com/-OLYyle4PQ48/U5lB8SLR_DI/AAAAAAAAAc4/yHvzlGfNAAs/s2400/2014-06-12-client-ip-detection-01-detech-user-ip.png)

頁面上顯示目前我目前的 IP「49.50.68.17」，並且其他的 header 是空的。但如果我今天使用 Burp Suite 之類的 Proxy 工具自行竄改封包，加上 X-Forwarded-For 或是 Client-IP header：

[![使用 Burp Suite 修改 HTTP Request Header](https://lh5.googleusercontent.com/-GC77ijJxN-U/U5lB8NrnGwI/AAAAAAAAAdA/pqJDjoxUeu0/w744-h480-no/2014-06-12-client-ip-detection-02-burp-suite-add-http-header.png "使用 Burp Suite 修改 HTTP Request Header")](https://lh5.googleusercontent.com/-GC77ijJxN-U/U5lB8NrnGwI/AAAAAAAAAdA/pqJDjoxUeu0/s2400/2014-06-12-client-ip-detection-02-burp-suite-add-http-header.png)

修改完畢之後，再到原本的顯示 IP 介面，會發現網頁錯將我竄改的 header 當作正確的資料填入。

[![顯示遭到竄改的 HTTP Header](https://lh3.googleusercontent.com/-hHA7NtX_9KI/U5lB8Nn1VjI/AAAAAAAAAc0/umHpFoGWDDo/w897-h678-no/2014-06-12-client-ip-detection-03-detech-user-ip.png)](https://lh3.googleusercontent.com/-hHA7NtX_9KI/U5lB8Nn1VjI/AAAAAAAAAc0/umHpFoGWDDo/s2400/2014-06-12-client-ip-detection-03-detech-user-ip.png)

### 使用代理伺服器 Proxy 的情況

使用代理伺服器的情況下，HTTP Header 會有不同的行為。例如 Elite Proxy 如何隱藏客戶端的真實 IP。以下簡單介紹幾種常見的狀況給各位參考。

#### 直接連線 （沒有使用 Proxy）

* REMOTE_ADDR: 客戶端真實 IP
* HTTP_VIA: 無
* HTTP_X_FORWARDED_FOR: 無

#### Transparent Proxy 

* REMOTE_ADDR: 最後一個代理伺服器 IP
* HTTP_VIA: 代理伺服器 IP
* HTTP_X_FORWARDED_FOR: 客戶端真實 IP，後以逗點串接多個經過的代理伺服器 IP

#### Anonymous Proxy

* REMOTE_ADDR: 最後一個代理伺服器 IP
* HTTP_VIA: 代理伺服器 IP
* HTTP_X_FORWARDED_FOR: 代理伺服器 IP，後以逗點串接多個經過的代理伺服器 IP

#### High Anonymity Proxy (Elite Proxy)

* REMOTE_ADDR: 代理伺服器 IP
* HTTP_VIA: 無
* HTTP_X_FORWARDED_FOR: 無 (或以逗點串接多個經過的代理伺服器 IP)

### 實際情況

在我們測試的過程中，通常我們都會讓瀏覽器自帶 X-Forwarded-For，並且自行填入 IP。常常會發現有一些網站出現如下的警告...

[![Discuz! 顯示 IP 錯誤](https://lh4.googleusercontent.com/-mWMLyw8Z924/U5lB8y19t5I/AAAAAAAAAc8/PgGRibfggZM/w268-h139-no/2014-06-12-client-ip-detection-04-discuz-user-ip.png)](https://lh4.googleusercontent.com/-mWMLyw8Z924/U5lB8y19t5I/AAAAAAAAAc8/PgGRibfggZM/s2400/2014-06-12-client-ip-detection-04-discuz-user-ip.png)

有沒有搞錯？「上次登入位置 127.0.0.1」？沒錯，這個是知名論壇套件「[Discuz!](http://www.discuz.net/)」的功能，抓取 IP 的功能也是不安全的寫法。也有這樣的經驗，之前開著 X-Forwarded-For 的 header 到一些網站，竟然直接出現管理者後台！

你覺得只有一般人撰寫的程式會有這樣的問題嗎？其實大型網站也可能會有類似的問題：

[![露天拍賣顯示 IP](https://lh6.googleusercontent.com/-4UPvfv9JbiM/U5p3CLiPXNI/AAAAAAAAAdU/Y6cNICTdCKk/w752-h551-no/2014-06-12-client-ip-detection-05-ruten-detect-user-ip.png)](https://lh6.googleusercontent.com/-4UPvfv9JbiM/U5p3CLiPXNI/AAAAAAAAAdU/Y6cNICTdCKk/s2400/2014-06-12-client-ip-detection-05-ruten-detect-user-ip.png)

先不論為什麼 127.0.0.1 會在美國，這樣的寫法可能會讓管理者永遠抓不到犯罪者的真實 IP，甚至攻擊者可以竄改 header 插入特殊字元，對網站進行 SQL Injection 或者 Cross-Site Scripting 攻擊。

### 正確又安全的方式

「**任何從客戶端取得的資料都是不可信任的！**」

請各位開發者、管理者記住這個大原則，雖然這些 Request Header 可能含有真實 IP 的資訊，但是因為他的安全性不高，因此我們絕對不能完全信賴這個數值。

那我們該怎麼處理呢？我的建議是記錄所有相關的 header 欄位存入資料庫，包含「REMOTE_ADDR」「X-Forwarded-For」等等，真正有犯罪事件發生時，就可以調出所有完整的 IP 資訊進行人工判斷，找出真正的 IP。當然從 header 存入的數值也可能會遭到攻擊者竄改插入特殊字元嘗試 SQL Injection，因此存入值必須先經過過濾，或者使用 Prepared Statement 進行存放。

可以參考的 HTTP Header（依照可能存放真實 IP 的順序）

* HTTP_CLIENT_IP
* HTTP_X_FORWARDED_FOR
* HTTP_X_FORWARDED
* HTTP_X_CLUSTER_CLIENT_IP
* HTTP_FORWARDED_FOR
* HTTP_FORWARDED
* REMOTE_ADDR (真實 IP 或是 Proxy IP)
* HTTP_VIA (參考經過的 Proxy)

「駭客思維」就是找出網站任何可能竄改的弱點，從網頁上的元素到 HTTP Header 都是嘗試的對象。因此身為防禦者一定要清楚的知道哪些數值是不能信賴的，不要再參考網路上錯誤的教學了！
