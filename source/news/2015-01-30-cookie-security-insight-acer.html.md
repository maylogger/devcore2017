---

title: "談 Cookie 認證安全－以宏碁雲端售票為例"
description: "由於 Cookie 存在瀏覽器端，有被竄改的可能，所以如果網站使用 Cookie 認證就會有一些安全上的風險。本篇就以宏碁雲端售票為例，說明這種小疏忽可能會造成被盜用帳號的風險。"
category: "案例剖析"
tags: ["Cookie", "Session", "Defense", "Vulreport"]
author: "shaolin"
keywords: "Cookie, Session, 安全, 雲端售票, 江蕙"
og_image: "https://lh4.googleusercontent.com/-u-F2KxtrEh0/VMtTowWHskI/AAAAAAAAAwo/07yCkSn9vkM/w555-h538-no/tamper_cookie.gif"
---


### 前言

[![tamper cookie](https://lh4.googleusercontent.com/-u-F2KxtrEh0/VMtTowWHskI/AAAAAAAAAwo/07yCkSn9vkM/w555-h538-no/tamper_cookie.gif "tamper cookie")](https://lh4.googleusercontent.com/-u-F2KxtrEh0/VMtTowWHskI/AAAAAAAAAwo/07yCkSn9vkM/w555-h538-no/tamper_cookie.gif)
(Photo by [mcf1986](https://www.flickr.com/photos/mcf1986/2398237441/in/photolist-4DVArp-PhbMe-7JECFz-7JECQt-7JJyrw-bGFngi-5rW57Y-6xHB2u-pu7B57-4c7y2z-aDa9uc-o5bZTa-8L1384-5DkkLv-b6jovn-o5pesn-79zgAq-5Fpj5G-7pz2TV-4bVGh3-6PQ929-aE2HH8-bnKBwv-brCnx3-bsqgqU-6xHC89-5ELJKU-6rocvE-4bVGm7-4bVGpd-4bRG6B-4bVGiC-6SzwyG-5CBhyB-5CBhxp-emi7PE-5fxugW-XpEdp-qDhTXJ-aBrsh-67NH6d-4bVGjN-4bRGaB-phCGo-aP1qDc-aP1riK-aP1rXn-aCQQav-baRCLB-vJ7RW/))

Cookie 是開發網頁應用程式很常利用的東西，它是為了解決 HTTP stateless 特性但又需要有互動而產生的。開發者想把什麼資訊暫存在用戶瀏覽器都可以透過 Cookie 來完成，只要資訊量不大於約 4KB 的限制就沒問題。在這樣的空間裡，可以放購物車內的暫存商品、可以儲存讀者閱讀記錄以精準推薦產品、當然也可以寫入一些認證資訊讓使用者能保持登入狀態。

Cookie 有一些先天上的缺點，在於資料是儲存在瀏覽器端，而使用者是可以任意修改這些資料的。所以如果網站的使用者身分認證資訊依賴 Cookie，偷偷竄改那些認證資訊，也許有機會能夠欺騙網站，盜用他人身分，今天就來談談這樣的一件事情吧！

READMORE

### 問題與回報

會想要聊這個議題，主要是因為最近很紅的宏碁雲端售票系統就是採用 Cookie 認證。上週在註冊該網站時看了一下 Cookie，發現該網站沒有使用 [Session 機制](http://devco.re/blog/2014/06/03/http-session-protection/)的跡象，也就是單純利用 Cookie 的值來認證。

[![宏碁雲端 cookie](https://lh3.googleusercontent.com/-9Z7DJr1KJEM/VMtTniDZ4bI/AAAAAAAAAwg/PCAa8tafZmY/w697-h489-no/acer_cookie.png "宏碁雲端 cookie")](https://lh3.googleusercontent.com/-9Z7DJr1KJEM/VMtTniDZ4bI/AAAAAAAAAwg/PCAa8tafZmY/w697-h489-no/acer_cookie.png)

於是開始好奇認證主要的依據是什麼？從圖中可以看到 Cookie 值並不多，猜測該網站大概會是看 USER_ID、USER_ACCOUNT 來判斷你是哪個使用者，稍作測試後會發現有些頁面只依據 USER_ACCOUNT 的值來確認身分，而 USER_ACCOUNT 這個值其實就是使用者的身分證字號，也就是說任何人只要跟網站說我的身分證字號是什麼，網站就會認為你是那個身分證字號的使用者。利用這點設計上的小瑕疵，就可以竊取他人個資，更進階一點，甚至可以用來清空別人的志願單讓其他使用者買不到票。

發現這個問題後，決定通報 [VulReport 漏洞回報平台](https://vulreport.net/)，由該平台統一通知開發商。這是我第一次使用這個平台，對我而言這是一個方便且對整體資安環境有助益的平台。方便點在於，過去常常困擾於發現一些網站有設計上的疏失卻不知該不該通報，如果認識該網站的開發者倒是還好可以直接講，但對於其他不認識的，一來沒有明確窗口，二來礙於工作關係怕被認為是敲竹槓，所以影響不大的漏洞可能就放水流了。這樣放任其實不是一件健康的事情，漏洞在風險就在，有了這樣的回報平台至少可以告訴企業可能存在風險，自己也可以放心通報。事實上，對岸有[類似的平台](http://wooyun.org/)已經行之有年，最顯著的效果，就是對岸網站在 0 day 被揭露後能在一週左右全國修復，而以往可能好多年過去了漏洞還在。這真的能夠加速保護企業和使用者，很高興台灣也有了這樣的平台！

昨天早上收到了平台回報宏碁雲端售票已經[修復的消息](https://vulreport.net/vulnerability/detail/284)，既然已經修復且公開了，就順便講解這個問題的細節吧！希望其他開發者可以從中體會到攻擊者的思維，進而做洽當的防禦。

### 驗證及危害

為了方便驗證解說這個問題，這邊特別用兩個不存在的身分證字號在宏碁雲端售票申請帳號，分別是 Z288252522 和 Z239398899。測試目的是登入帳號 Z288252522 後看看是否能利用上述 Cookie 問題讀取 Z239398899 的個資。

首先登入帳號 Z288252522，找到一個會回傳個資的頁面：<br />
https://www.jody-ticket.com.tw/UTK0196_.aspx

[![第一個使用者個資](https://lh4.googleusercontent.com/-Sr6zlrJiMdQ/VMtTpyzELnI/AAAAAAAAAxA/VmWdgS82gVQ/w485-h548-no/user_A_data.png "第一個使用者個資")](https://lh4.googleusercontent.com/-Sr6zlrJiMdQ/VMtTpyzELnI/AAAAAAAAAxA/VmWdgS82gVQ/w485-h548-no/user_A_data.png)

此時的 Cookie 值如下

[![第一個使用者 cookie](https://lh3.googleusercontent.com/-vqjLAyXggfc/VMtTp7iHtdI/AAAAAAAAAw8/sfUXYUPC57U/w881-h548-no/user_A_cookie.png "第一個使用者 cookie")](https://lh3.googleusercontent.com/-vqjLAyXggfc/VMtTp7iHtdI/AAAAAAAAAw8/sfUXYUPC57U/w881-h548-no/user_A_cookie.png)

從圖中發現 Cookie 的值其實是經過加密的，這點在上面說明攻擊觀念時刻意沒有提及。把 Cookie 值加密是一種防止別人修改 Cookie 值的方式，攻擊者不知道 Cookie 值的內容，自然也無法修改了。

然而這樣做還是存在些微風險，一旦這個加解密方式被找到，攻擊者就得以修改 Cookie 內容，進而盜用別人身分。在本例中，若想憑著改變 Cookie 盜用別人身分其實可以不用花時間去解加密法，這裡有一個小 trick，我們從觀察中馬上就能發現所有 Cookie 值都是用同一套加密方式，而且其中 USER_EMAIL、USER_NAME 這些還是我們可以修改的值。這也意味著如果我們把姓名改成我們想要加密的身分證字號，伺服器就會回傳一個加密好的值給 USER_NAME。我們直接來修改姓名看看：

[![修改姓名成身分證字號](https://lh5.googleusercontent.com/-ohhdlHt-jRQ/VMtTvHl5jjI/AAAAAAAAAxQ/Gs-5jRr_vKc/w707-h548-no/change_name.png "修改姓名成身分證字號")](https://lh5.googleusercontent.com/-ohhdlHt-jRQ/VMtTvHl5jjI/AAAAAAAAAxQ/Gs-5jRr_vKc/w707-h548-no/change_name.png)

當姓名改成目標 Z239398899 時，Cookie 中的 USER_NAME 值就會改變成我們要的加密結果。耶！是一種作業不會寫找出題老師幫忙寫的概念 XD

[![改變第一個使用者 cookie](https://lh6.googleusercontent.com/-JSS4s1LR1f8/VMtTpwlQXxI/AAAAAAAAAw4/OwvKW76pqy8/w881-h548-no/user_B_cookie.png "改變第一個使用者 cookie")](https://lh6.googleusercontent.com/-JSS4s1LR1f8/VMtTpwlQXxI/AAAAAAAAAw4/OwvKW76pqy8/w881-h548-no/user_B_cookie.png)

接著直接把 USER_NAME 的值拿來用，複製貼上到目標欄位 USER_ACCOUNT 中，之後就是以 Z239398899 的身分來讀取網頁了。我們再讀取一次 https://www.jody-ticket.com.tw/UTK0196_.aspx 看看：

[![第二個使用者個資](https://lh3.googleusercontent.com/-ROUvA-9K96o/VMtTrC0U-DI/AAAAAAAAAxI/EyCpVoeQ1Kc/w485-h548-no/user_B_data.png "第二個使用者個資")](https://lh3.googleusercontent.com/-ROUvA-9K96o/VMtTrC0U-DI/AAAAAAAAAxI/EyCpVoeQ1Kc/w485-h548-no/user_B_data.png)

成功看到 Z239398899 的資料了！如此，就可以只憑一個身分證字號讀到他人的地址電話資訊，甚至可以幫別人搶票或取消票券。這個流程寫成程式後只要兩個 request 就可以嘗試登入一個身分證字號，要大量偷取會員個資也是可行的了。

說到這邊，也許有人會質疑要猜中註冊帳戶的身分證字號是有難度的，但其實要列舉出全台灣可能在使用的身分證字號並不困難，再加上宏碁雲端的硬體其實是很不錯的，事實也證明它能夠在[短時間處理四千萬個請求系統仍保持穩定](https://tw.news.yahoo.com/%E6%B1%9F%E8%95%99%E5%8A%A0%E5%A0%B4%E5%94%AE%E7%A5%A8-%E9%A7%AD%E5%AE%A2%E6%94%BB%E6%93%8A4000%E8%90%AC%E6%AC%A1-041458504.html)，只要攻擊者網路不要[卡在自家巷子口](http://www.cna.com.tw/news/afe/201501250162-1.aspx)，多機器多線程佈下去猜身分證字號效率應該很可觀！

### 建議原則

這次的問題是兩個弱點的組合攻擊：

1. Cookie 加密的內容可解也可偽造－透過網站幫忙
2. 功能缺少權限控管 (Missing Function Level Access Control)－部分頁面只憑身分證字號就可存取個資

宏碁雲端售票為了效率和分流，使用 Cookie 認證是相當合理的設計，所以要解決這個問題，從第二點來解決會是最有效且符合成本的方式，怎麼改呢？推測原本的 SQL 語句應該類似這樣：

{% highlight sql startinline %}
select * from USER where account=USER_ACCOUNT
{% endhighlight %}

由於 USER_ACCOUNT 是身分證字號，容易窮舉，更嚴謹的作法可以多判斷一個 id，像是這樣：

{% highlight sql startinline %}
select * from USER where account=USER_ACCOUNT and id=USER_ID
{% endhighlight %}

從只需要告訴伺服器身分證字號就回傳會員資料，到變成需要身分證字號和會員編號同時正確才會回傳會員資料，至此，攻擊者已經很難同時知道別人的會員編號和身分證字號了，因此大大降低了被猜中的機率，增加了安全性。

Cookie 一直以來都是 Web Application Security 領域的兵家必爭之地，攻擊者無不絞盡腦汁想偷到或偽造它，前陣子舉辦的 [HITCON GIRLS](http://girls.hitcon.org/) Web 課堂練習題第一題就是改 Cookie 來偽造身分，足見這個問題有多基本和重要。

關於 Cookie，這裡提供一點原則和概念供大家參考：

首先，Cookie 是存在客戶端的，所以有機會被看到、被竄改、被其他人偷走。基於這些原因，不建議在 Cookie 中儲存機敏資料，或是存放會影響伺服器運作的重要參數，需評估一下這些暫存資料被人家看到或修改是不是沒差，這是儲存的原則。如果權衡後還是要在 Cookie 中存放重要資料，那就需要對值加密避免被讀改，而且要確保加密的強度以及其他人是否能透過其他方法解析修改。最後，Cookie 最常被偷走的方式是透過 JavaScript，所以建議在重要的 Cookie 加上 [HttpOnly flag](http://devco.re/blog/2014/06/11/setcookie-httponly-security-issues-of-http-headers-3/) 能有效的降低被偷走的機率。也來試著整理一下這一小段的重點：

☑ 機敏資料不要存<br/>
☑ 加密資訊不可少<br/>
☑ 設定標頭不怕駭<br/>
☑ 一次搞定沒煩惱<br/>

沒想到信手拈來就是三不一沒有，前面再加個勾勾，感覺好像很厲害呢！

### 結論

由於 Cookie 存在瀏覽器端，有被竄改的可能，所以如果網站使用 Cookie 認證就會有一些安全上的風險。本篇就以宏碁雲端售票為例，說明這種小疏忽可能會造成被盜用帳號的風險。開發者在面對使用者可以改變的變數一定要特別小心處理，做好該有的防護，還是老話一句：使用者傳來的資料皆不可信！只要掌握這個原則，開發出來的產品就能夠少很多很多風險！

行文至此，預期中是要再推廣一下漏洞回報平台，順便稱讚宏碁非常重視資安，修復快速，是良好的正循環。不過前兩天看到一些關於宏碁雲端售票的新聞時，上線發現此弱點仍未修復，這好像真的有點不應該，畢竟官方上週已經接收到通報，要修復這個弱點也只需一行判斷式...。能理解這次的弱點在短時間開發過程中很難被注意到，對於這樣一個一週不眠不休完成的售票網站，我其實也是給予滿高的評價，但如果官方能再增兩分對資安事件的重視，相信下次定能以滿分之姿呈現在使用者面前！
