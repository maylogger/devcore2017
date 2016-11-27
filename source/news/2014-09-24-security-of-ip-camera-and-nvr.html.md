---
layout: post
title: "網路攝影機、DVR、NVR 的資安議題 - 你知道我在看你嗎？"
description: "網路攝影機 (IP Camera) 與 NVR 是許多企業與家庭都會採購的設備，但鮮少有人關注此類設備的資安議題，殊不知此類設備從 2013 年起已逐漸成為駭客的獵物..."
category: "技術專欄"
tags: [IP Camera, CVE, Statistics, IoT]
author: "bowenhsu"
keywords: "IP Camera, CVE, Statistics, IoT"
og_image: "https://lh5.googleusercontent.com/-yzP5umnsAhg/VCKTF83dDpI/AAAAAAAAAp8/tS59M5xeSuw/w1522-h1015-no/i_am_watching_you.jpg"
---


[![你知道我在看你嗎？](https://lh5.googleusercontent.com/-yzP5umnsAhg/VCKTF83dDpI/AAAAAAAAAp8/tS59M5xeSuw/w1522-h1015-no/i_am_watching_you.jpg "你知道我在看你嗎？")](https://lh5.googleusercontent.com/-yzP5umnsAhg/VCKTF83dDpI/AAAAAAAAAp8/tS59M5xeSuw/w1522-h1015-no/i_am_watching_you.jpg)

網路攝影機的普及率在近幾年來持續攀升，除了老人與幼兒居家照護、企業室內監控等需求迅速增加之外，結合手機應用程式讓人可隨時隨地觀看影像的方便性也成為普及的原因。當大家還以為黑帽駭客的目標仍然是網站、個人電腦時，已經有許多攻擊者悄悄地將目標轉向了各種物連網設備，例如 NAS、Wireless AP、Printer 等產品，而擁有眾多用戶的網路攝影機理所當然地也是目標之一。身為安控產品，卻造成一項資安的隱憂，是不是有點諷刺呢？

恰好最近幾天忽然看到有新聞報導[「家用監視器遭駭客入侵 隱私全被看光光」](http://news.ltn.com.tw/news/world/breakingnews/1112329)這樣子的案例，而在去年也有類似的報導[「數十萬支監控攝影機潛藏被駭漏洞 電影情景恐真實上演」](http://news.networkmagazine.com.tw/classification/security/2013/06/18/51531/)，讓我們不禁想對這個事件做個深入的調查。就讓我們來看看網路攝影機以及相關產品究竟有哪些風險吧！

READMORE

### CVE

我們先來看看幾個大廠在 2013 年到 2014 年之間有哪些已經被公開揭露的 CVE 弱點：

* AVTECH: 3, CVE-2013-4980, CVE-2013-4981, CVE-2013-4982
* AXIS: 2, CVE-2013-3543, CVE-2011-5261
* Hikvision: 3, CVE-2013-4975, CVE-2013-4976, CVE-2013-4977
* SONY: 1, CVE-2013-3539
* Vivotek: 6, CVE-2013-1594, CVE-2013-1595, CVE-2013-1596, CVE-2013-1597, CVE-2013-1598, CVE-2013-4985

讀者們若進一步去看各個 CVE 的詳細資料，會發現有許多弱點都是屬於可執行任意指令的嚴重漏洞，其影響程度非常高，已不只是關於攝影內容是否被竊取，更有可能被利用此類設備進一步攻擊其他內、外網機器。

### 台灣現況

雖然上面提到許多知名廠牌的嚴重漏洞，但是每個國家使用的安控設備不見得都是上述幾個牌子，而身為資安業者，隨時關注自己國家的網路現況也是很合理的事情～在我們的大量觀測下，發現有許多 IP Camera、[DVR (Digital Video Recoder)](http://en.wikipedia.org/wiki/Digital_video_recorder)、[NVR (Network Video Recoder)](http://en.wikipedia.org/wiki/Network_Video_Recorder) 都存在資安議題，我們從其中提出幾個有趣的案例跟各位分享一下：

* 某國外 V 牌廠商 （數量：320+）

  一般的產品通常都會有預設帳號密碼，但這間廠商的產品似乎沒有預設帳號密碼，若使用者未設定帳號密碼，攻擊者只要直接點「OK」按鈕就可以登入系統，而這樣子的 DVR 在台灣有三百多台，也就是有三百多台 DVR 在網路上裸奔...[![網路攝影機、DVR、NVR 案例 1](https://lh6.googleusercontent.com/-K8pb-2R9Esk/VCKX3IJzzMI/AAAAAAAAAqU/w80wIMGjG_Y/w145-h177-no/case_study_01.png "網路攝影機、DVR、NVR 案例 1")](https://lh6.googleusercontent.com/-K8pb-2R9Esk/VCKX3IJzzMI/AAAAAAAAAqU/w80wIMGjG_Y/w145-h177-no/case_study_01.png)

* 某國外 H 牌廠商 （數量：1200+）

  有些廠商為了方便維修或者其他理由，會在 NVR 上開啟了 Telnet 服務，雖然增加了被攻擊的機率，但是若密碼強度足夠且沒有外流，也不會隨便被打進去。而這間廠商非常有趣，除了 root 帳號之外還有一組 guest 帳號，並且 guest 的密碼非常簡單，加上當初建置系統時並未檢查機敏檔案的權限是否設定錯誤，導致攻擊者可先用 guest 帳號登入，再去 /etc/shadow 讀取 root 密碼加以破解，進一步取得設備所有權限。[![網路攝影機、DVR、NVR 案例 2](https://lh3.googleusercontent.com/-LpCdEr9_Oh4/VCKoLA8lr9I/AAAAAAAAArs/cfkenPnECAU/w1267-h916-no/case_study_02.png "網路攝影機、DVR、NVR 案例 2")](https://lh3.googleusercontent.com/-LpCdEr9_Oh4/VCKoLA8lr9I/AAAAAAAAArs/cfkenPnECAU/w1267-h916-no/case_study_02.png)

* 某國外 D 牌廠商 （數量：700+）

  這個案例實在是令人哭笑不得，不知道是原廠還是台灣代理商非常好心地幫使用者建立了多組預設帳號，包含 admin、666666、888888 等等，而且密碼也設定得很簡單。但是通常要使用者記得改一組預設密碼已經非常困難，更何況是要使用者改三組密碼呢？這種情形導致攻擊者可以輕而易舉地拿著弱密碼到處猜，大大提高了用戶的受害機率。而更有趣的是，不知道是基於歷史包袱或者其他原因，此設備開了特殊的 port，直接送出含有特定內容的封包到這個 port 就可以執行相對應的指令，例如可以取得帳號密碼、使用者 email 等等，而在這個過程中完全沒有任何認證機制！等於又有七百多台 NVR 在網路上裸奔...[![網路攝影機、DVR、NVR 案例 3](https://lh6.googleusercontent.com/-A5ocSnssMig/VCKoLCSYHII/AAAAAAAAAro/Cwx5ctzeeXs/w1267-h916-no/case_study_03.png "網路攝影機、DVR、NVR 案例 3")](https://lh6.googleusercontent.com/-A5ocSnssMig/VCKoLCSYHII/AAAAAAAAAro/Cwx5ctzeeXs/w1267-h916-no/case_study_03.png)

* 某國內 A 牌廠商 （數量：1000+）

  這間廠商也是使用常見的預設帳號密碼，但它可怕的地方還不止於此。該系統將帳號密碼轉為 Base64 編碼後直接當作 cookie 內容，因此若預設帳號密碼分別是 abc 與 123，將 abc:123 用 Base64 編碼過後可得到 YWJjOjEyMw==，接著將 Cookie: SSID=YWJjOjEyMw== 這串內容加到 request 的 HTTP header 中，就可以到處測試該設備是否使用預設帳號密碼，甚至還可以進一步下載備份檔，察看使用者有無填寫 email、網路帳號密碼等資料。[![網路攝影機、DVR、NVR 案例 4](https://lh3.googleusercontent.com/-27vJx4_3nnQ/VCKfq9vZh_I/AAAAAAAAArA/A6qo8XpzryI/w1132-h622-no/case_study_04.png "網路攝影機、DVR、NVR 案例 4")](https://lh3.googleusercontent.com/-27vJx4_3nnQ/VCKfq9vZh_I/AAAAAAAAArA/A6qo8XpzryI/w1132-h622-no/case_study_04.png)

* 某國內 A 牌廠商（數量：10+）

  這個案例雖然數量非常少，但是卻非常嚴重。為什麼呢？因為廠商沒有對機敏資料做嚴格的權限控管，只要攻擊者直接在網址列輸入 http://IP/sys.bin，就可以直接下載一個名為 sys.bin 的檔案，而此檔案是 tgz 格式，解壓縮後可以得到 system_server.conf，該檔案中含有帳號、密碼，因此即便使用者修改了預設帳號密碼，也會因為這個嚴重漏洞而輕易地被入侵。[![網路攝影機、DVR、NVR 案例 5](https://lh6.googleusercontent.com/-GQ3TpVeMlP4/VCKfqoFuwOI/AAAAAAAAAq4/fxfRe9BlWZA/w1132-h601-no/case_study_05.png "網路攝影機、DVR、NVR 案例 5")](https://lh6.googleusercontent.com/-GQ3TpVeMlP4/VCKfqoFuwOI/AAAAAAAAAq4/fxfRe9BlWZA/w1132-h601-no/case_study_05.png)

* XXXX科技 （數量：230+）

  這是一個非常經典的案例！一般攻擊者入侵攝影機最常見的就是為了偷看攝影機畫面，再進階一點的可能會控制該攝影機進一步攻擊內網。而這家廠商身為知名保全公司投資成立的安控公司，理當為客戶的監控畫面做最周全的規劃、最謹慎的防護，但是結果呢？報告各位，完全沒有任何防護！只要連到 IP 位址就可以直接看到攝影機畫面，也是屬於裸奔一族...

從這幾個案例我們可以發現台灣目前至少有 3500 台左右的安控設備處於高風險狀態中，而由於我們無暇對每一款設備進行調查，因此這僅僅是一個概略的調查結果。同時這些設備都是在網路上可直接連線的，若再加上各個公家機關、辦公大樓、社區的內網安控設備，恐怕會有更驚人的發現。

### 問題起源

究竟為什麼會有這麼多安控設備被入侵呢？其實主要有兩個面向。第一個是由於許多廠商的防範觀念仍停留在舊時代，不了解駭客到底都怎麼攻擊，因此也不了解確切的防治方法。舉例來說，廠商在網路安控系統的 Web 輸入介面都會設定許多阻擋規則，以防範入侵者輸入惡意攻擊指令，但是這些防治手段都僅僅做在 client 端（用 JavaScript 來防護），入侵者只要利用 proxy 工具或自行寫程式發送客製化 request 就可以繞過那些驗證，若廠商沒有在 server 端再次進行驗證輸入資料是否異常，就有很高的機會被入侵成功。

另一方面則是入侵者的攻擊手法千變萬化，難以保證不會有新的 0-Day 弱點出現。例如今年一月份大量爆發的 NTP 弱點 CVE-2013-5211 就存在於上述六個案例其中之一，我想廠商應該不會有意願針對舊產品修復此類漏洞，也就是未來隨時有幾百台的攝影機可被惡意人士用來執行 DDoS 攻擊。另外今年四月份的 OpenSSL Heartbleed 弱點更是一個具有代表性的重要案例，我想這應該是許多安控設備廠商都會使用的程式。當廠商將此類程式納入網路安控設備中，於弱點被揭露時若無法及時有效修補，或是修補的成本太高導致用戶不願意修補、沒有能力修補，就有可能釀成重大災情，不但造成用戶損失，也嚴重影響商譽。

### 廠商該如何因應？

針對此類資安問題，大型硬體廠商應該落實以下幾個動作：

* 改善資安問題更新流程：將產品的資安更新改變成主動通知使用者，而非需要使用者主動到官網看才知道更新，以縮短使用者更新的平均週期，確保使用者的軟體是最新無風險版本。
* 成立專門資安小組：請專人負責檢驗產品的資安品質與修正資安弱點，以便因應臨時爆發的重大弱點，維持產品的資安品質。
* 黑箱滲透測試：於產品出廠前執行黑箱滲透測試，讓滲透測試專家從黑帽駭客的角度來檢查產品有無漏洞。
* 白箱原始碼檢測：定期執行原始碼檢測，從產品的根本處著手改善，降低產品上市後才被發現弱點的機率。
* 資安教育訓練：請有實際攻防經驗的資安專家給予開發人員正確的資安觀念，了解最新的攻擊手法與有效防禦之道。
* 定期檢閱產品所使用的第三方軟體套件是否有弱點，例如 OpenSSL，以避免把有問題的版本納入產品，造成產品間接產生弱點，因而遭到入侵。
* 定時於網路上收集產品的相關弱點資料，例如 [Secunia](http://secunia.com/)、[SecurityFocus](http://www.securityfocus.com/)、[Packet Storm](http://packetstormsecurity.com/) 等網站都是很好的資訊來源。

### 一般使用者、企業該如何亡羊補牢？

目前的網路安控系統使用者仍未有足夠的資安意識，主要現象有以下幾點：

* 使用弱密碼
* 未進行適當的權限劃分與管理
* 容易開啓攻擊者寄送的惡意連結，導致被 XSS、CSRF 等手法攻擊
* 未限制連入 IP 位址，導致安控系統可從外網任意存取

然而，無論是安控系統或其他任何連網設備，未來都有可能成為潛在的攻擊目標，而且在廠商提供更新檔之前其實也很難確實地自保，因此了解資安知識與常見的攻擊手法是有其必要的。基本的防範之道如下：

* 使用強密碼，包含大小寫英文、數字、特殊符號，並且定期更換密碼
* 勿在系統建立太多不必要的使用者帳號、將多餘的帳號移除，以降低帳號被盜的機率。若需要建立多組帳號，請仔細給予適當的權限
* 勿隨意開啟可疑信件附帶的連結或檔案，以避免被攻擊者以 XSS、CSRF 等手法攻擊
* 限制可存取資訊系統的 IP 位址，避免資訊系統成為公開的攻擊目標
* 定期檢查 log，確認有無異常登入、異常操作甚至是異常帳號等資訊

### 結論

在物連網的時代中，各種可進行無線通訊的設備被攻擊的事件屢見不鮮，例如 2011 年知名駭客 Jay Radcliffe 在 Black Hat 展示如何攻擊胰島素注射器，2013 年已故駭客 Barnaby Jack 原本要在 Black Hat 展示如何利用藍芽通訊控制心律調整器，甚至 2014 年甫推出的可遠程變換顏色燈泡也被揭露有資安問題。在不久的未來，這些資安問題只會更多，身為民眾、企業、廠商的你，準備好面對萬物皆可駭的物連網時代了嗎？
