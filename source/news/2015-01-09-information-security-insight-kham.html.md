---

title: "從寬宏售票談資安"
description: "在使用最近熱門的寬宏售票網站時，我們發現網頁原始碼存在一些疑似密碼的資訊。從這件事情出發，我們分別延伸探討了兩個工程師應該注意的議題：分別是金流串接常見的弱點以及駭客的心理。"
category: "科普文章"
tags: ["infoleak","Defense","HTTP Header","Cashflow"]
author: "shaolin"
keywords: "資訊洩漏,駭客心理,安全金流串接"
og_image: "https://lh6.googleusercontent.com/-HFoHvAu_6kU/VK-iyc6JkrI/AAAAAAAAAvw/9mF_ebSMHUc/w878-h596-no/kham.com.tw.png"
---


戴夫寇爾部落格停載了快兩個月，非常抱歉，讓各位常常催稿的朋友們久等了 <(_ _)><br />
今天就乘著全臺瘋買票的浪頭，來談談一些常被忽略的資訊安全小概念吧！

[![寬宏售票](https://lh6.googleusercontent.com/-HFoHvAu_6kU/VK-iyc6JkrI/AAAAAAAAAvw/9mF_ebSMHUc/w878-h596-no/kham.com.tw.png "寬宏售票")](https://lh6.googleusercontent.com/-HFoHvAu_6kU/VK-iyc6JkrI/AAAAAAAAAvw/9mF_ebSMHUc/w878-h596-no/kham.com.tw.png)

READMORE

江蕙引退演唱會一票難求，隔岸觀了兩天火， 也忍不住想要當個鍵盤孝子。無奈運氣不好一直連不上主機，『Service Unavailable』畫面看膩了，只好看看暫存頁面的網頁原始碼，不看還好，一看我驚呆了！

[![寬宏售票資訊洩漏](https://lh6.googleusercontent.com/-JiRvqxjmTc0/VK-j-wHU6-I/AAAAAAAAAwE/29JWcFB9Oo0/w878-h650-no/kham_information_leakage.png "寬宏售票資訊洩漏")](https://lh6.googleusercontent.com/-JiRvqxjmTc0/VK-j-wHU6-I/AAAAAAAAAwE/29JWcFB9Oo0/w878-h650-no/kham_information_leakage.png)
（特別聲明：此流程中並無任何攻擊行為，該頁面是正常購票流程中出現的網頁）

在結帳網頁原始碼當中竟然看到了疑似資料庫密碼 SqlPassWord 在表單裡面！這件事從資安的角度來看，除了表面上洩漏了資料庫密碼之外，還有兩個我想講很久但苦無機會談的資安議題，分別是金流串接常見的弱點以及駭客的心理。藉著寬宏售票網頁洩漏密碼這件事情，順道與大家分享分享吧！

### 談台灣網站的金流串接

在本篇的例子中，寬宏售票網頁表單出現了疑似資料庫密碼，這狀況就好像去銀行繳款，櫃檯給你一把鑰匙跟你說：『這是金庫的鑰匙，麻煩你到對面那個櫃檯把鑰匙給服務員，請他幫你把錢放進金庫裡面』。<br />
是不是有點多此一舉，銀行本來就會有一份鑰匙，幹嘛要請你（瀏覽器）幫忙轉交？<br />
如果今天壞人拿到了這把鑰匙，是不是只要繞過保全的視線，就可以打開金庫為所欲為？

[![key_to_success](https://lh4.googleusercontent.com/-W3tAzOTSrrk/VK-iw2tdc9I/AAAAAAAAAvY/Qtq4pzXFGmE/w640-h427-no/3d_key_to_success.jpg "key_to_success")](https://lh4.googleusercontent.com/-W3tAzOTSrrk/VK-iw2tdc9I/AAAAAAAAAvY/Qtq4pzXFGmE/w640-h427-no/3d_key_to_success.jpg)
（Photo by StockMonkeys.com）

類似的狀況也滿常發生在電子商務與第三方金流服務的串接上。<br />
許多電子商務網站專注於商務，選擇將付款步驟委託第三方金流服務處理，一般常見的流程是這樣的：

1. 電子商務訂單成立，電子商務網站給你一張單子，上面寫著：『訂單 123 號， 金額 456 元』，請你將單子轉交給第三方金流服務網站並繳款。
2. 金流服務網站依據你給它的單據收取 456 元，並且跟電子商務網站說：『訂單 123 已成功繳款，款項 456 元』。
3. 最後電子商務網站告訴你訂單 123 號購買成功。

如果現在有一個惡意使用者，他做了以下惡搞：

1. 在步驟一把電子商務網站給的單子修改成：『訂單 123 號，金額 20 元』（原價是 456 元）
2. 金流服務商依據單據跟惡意使用者收取 20 元費用，並且告訴電子商務網站：『訂單 123 已成功繳款，款項 20 元』
3. 最後電子商務網站看到『訂單 123 已成功繳款』的訊息，就告訴使用者說訂單 123 購買成功。也就是惡意使用者只花取 20 元就購買到原價 456 元的產品。 

(聲明：為求精簡，電子商務與金流服務串接流程有經過簡化，有抓到精髓就好XD)

不管是寬宏售票出現密碼欄位還是上例電子商務網站的金流串接，最大的問題在於他們都相信使用者會正常幫忙轉交，即靠客戶端的瀏覽器來轉址傳值。要知道，利用瀏覽器轉址傳值是不可靠的，一來，重要的資訊就會被客戶知道，例如寬宏售票疑似洩漏資料庫密碼；二來中間的內容可以修改，例如修改訂單金額。另外，可能有人會發現到，在惡意使用者的步驟三裡面，電子商務網站竟然沒有確認付款金額是否正確，沒錯，這是會發生的事情，在過去經驗中，像這樣沒有比對付款金額的台灣系統比例還不少，這些疏忽都會造成企業很多成本損失，不可不注意。

台灣目前還滿常見到這種根據使用者傳來單據來收費的狀況，導致單據可竄改造成企業損失，某部分原因可以歸咎到早期第三方金流的範例都是這樣寫的，工程師也就直接延續這樣的寫法直到現在。以金流串接為例，比較好的處理方式有下面兩種：

* 在單據上加入防偽標記，讓惡意使用者無法輕易竄改單據。在技術上作法有點類似 OAuth 在 Signing Request 時的作法，在請求中多送一組檢查碼，透過 one-way hash 的方式檢查網址是否有被修改，目前大部分金流商都有提供相似解法。
* 單據不再給使用者轉交，電子商務直接傳單子『訂單 123 號，金額 20 元』給金流服務網站，並請使用者直接去專屬的金流商窗口繳費即可。在技術上就是將瀏覽器轉址傳值的動作全部變成伺服器對伺服器溝通處理掉。

以上兩種作法，將可以有效防止惡意使用者修改訂單金額。此外，建議電子商務網站在收到金流回傳的付款資訊後，能夠比對收取款項與訂單款項是否相符，如此雙重檢查，能大大避免惡意行為，減少企業處理惡意金流問題的成本。

### 談駭客心理

很明顯的，寬宏售票洩漏密碼的狀況是工程師的小疏漏。在不知道資料庫確切位置的前提下，知道疑似資料庫密碼的東西確實也無法做什麼，頂多就是了解了一家公司制定密碼的策略。然而，看在駭客眼裡，這點疏失會代表著一個網站面對資安的態度。連顯而易見的問題都沒有注意，那後端程式應該也有可能出現漏洞。一旦駭客決定要攻擊這個網站，勢必會搬出比平常還要多的資源去嘗試，因為他們認為這個投資報酬率很高。

一般駭客基本上會不斷的從所看到的網頁資訊來調整自己攻擊的強度，如果他們不斷看到了奇怪的登入畫面：

[![寬宏售票登入頁面1](https://lh3.googleusercontent.com/-hwjvY9pSsWQ/VK-iyPi36hI/AAAAAAAAAvo/lOXXP8NCU2A/w669-h372-no/kham_login_1.png "寬宏售票登入頁面1")](https://lh3.googleusercontent.com/-hwjvY9pSsWQ/VK-iyPi36hI/AAAAAAAAAvo/lOXXP8NCU2A/w669-h372-no/kham_login_1.png)

或是防火牆的登入畫面

[![寬宏售票登入頁面2](https://lh5.googleusercontent.com/-dPPY-uFkRM4/VK-iybc3oNI/AAAAAAAAAvs/XBpigkmx0MY/w756-h482-no/kham_login_2.png "寬宏售票登入頁面2")](https://lh5.googleusercontent.com/-dPPY-uFkRM4/VK-iybc3oNI/AAAAAAAAAvs/XBpigkmx0MY/w756-h482-no/kham_login_2.png)

就很有可能會增加攻擊的力道。上面這種登入頁面就是就是一種常見的資訊洩漏，在今年台灣駭客年會的議程－「[被遺忘的資訊洩漏](http://devco.re/blog/2014/08/26/information-leakage-in-taiwan-HITCON2014/)」就提及了這類資訊洩漏在台灣是很普及的。注意，出現這樣的頁面並不意味著網站會有漏洞，只是網站容易因此多受到一些攻擊。反之，如果一個網站前端頁面寫的乾淨漂亮，甚至連 [HTTP 安全 header](http://devco.re/blog/2014/03/10/security-issues-of-http-headers-1/) 這種小細節都會注意到，駭客可能就會認為這個網站寫的很嚴謹，甚至連嘗試的慾望都沒有了。

一個經驗豐富的駭客，通常光看首頁就能夠判斷該網站是否可能存有漏洞，憑藉的就是這些蛛絲馬跡。為了不讓自家網站常被路過的惡意使用者攻擊，加強網頁前端的呈現、網頁原始碼乾淨有架構、沒有太多資訊洩漏，這些都是很好的防禦方法。

### 結論

在使用最近熱門的寬宏售票網站時，我們發現網頁原始碼存在一些疑似密碼的資訊。從這件事情出發，我們分別延伸探討了兩個工程師應該注意的議題：

* 第一個議題提醒大家在開發的時候，重要的資訊千萬不要透過客戶端瀏覽器幫忙轉送，記住客戶端都是不可信的，多經一手就多一分風險。文中舉出了台灣電商網站在金流串接時也常出現這樣的問題，可能會造成訂單金額被竄改等企業會有所損失的問題。
* 第二個議題從駭客的心理來談資安，一個網站如果沒有什麼保護機制、輕易的洩漏網站資訊，非常容易挑起駭客想要嘗試入侵的慾望；反之，若一個網站從前端到使用流程都非常注意細節，一般駭客較會興致缺缺。嚴謹的前端呈現，就某種程度來說，也是一種對自身網站的保護。

希望開發者看到上面這兩個議題有掌握到『別相信客戶端』、『駭客會因網站前端寫法不嚴謹而嘗試去攻擊』的重點，提昇自家網站的安全度吧！

最後說個題外話，身為一個工程師，我認為資訊系統該帶給世界的好處是節省大家的時間，而這次搶票卻讓無數人徹夜排隊或守在電腦前不斷的『連不上、買票、失敗』循環。這也許能夠賺到大量的新聞版面，最終票也能全部賣光，但想到台灣有數十萬小時的生產力浪費在無意義的等待上，就覺得這個系統好失敗。現在的技術已經可以負荷這樣大規模的售票，[KKTIX](https://kktix.com/) 甚至可以[一分鐘處理 10 萬張劃位票券](https://medium.com/@hlb/kktix-2015-01-7bf84c47dfdf)！世界在進步，過去的技術也許就該讓它留在過去。有人說：『真正幸福的人：不是搶到票，是可以像江蕙一樣選擇人生』，希望我也可以變成一個幸福的人，可以選擇一個不塞車的售票系統。
