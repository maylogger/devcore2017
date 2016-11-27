---
layout: post
title: "LINE 免費貼圖釣魚訊息分析"
description: "你有收過奇怪的 LINE 送貼圖訊息嗎？小心這種免費的訊息中都隱藏著資安危機！攻擊者常利用通訊軟體想盡辦法竊取你的帳號密碼，不得不慎！"
category: "案例剖析"
tags: [Phishing, IM, Facebook]
author: "allenown"
keywords: "Phishing, LINE, 釣魚"
og_image: "https://lh3.googleusercontent.com/-hBW82hxnHIE/U2kPLgV2BSI/AAAAAAAAAU4/wpXMZ7eVtqU/w381-h677-no/LINE_Phishing_02.png"
---


晚上突然接到社群朋友傳 LINE 的訊息過來，定睛一看並不單純。這網址看起來就是釣魚網站啊？怎麼會這樣呢？難道是朋友在測試我們的警覺心夠不夠嗎？讓我們看下去這個釣魚網頁怎麼玩。

[![LINE 傳送贈送貼圖訊息釣魚](https://lh3.googleusercontent.com/-ynmXJsHIv0w/U2kPLvxOvkI/AAAAAAAAAUw/qG0y0Ahcf44/w381-h677-no/LINE_Phishing_01.png "LINE 傳送贈送貼圖訊息釣魚")](https://lh3.googleusercontent.com/-ynmXJsHIv0w/U2kPLvxOvkI/AAAAAAAAAUw/qG0y0Ahcf44/s2560/LINE_Phishing_01.png)

READMORE

此 LINE 釣魚訊息說只要幫忙轉發 15 次訊息，就會贈送貼圖。先不論 LINE 有沒有這樣的機制，我們先直接點選連結看看葫蘆裡賣什麼藥。

[![LINE 釣魚假貼圖網頁](https://lh3.googleusercontent.com/-hBW82hxnHIE/U2kPLgV2BSI/AAAAAAAAAU4/wpXMZ7eVtqU/w381-h677-no/LINE_Phishing_02.png "LINE 釣魚假貼圖網頁")](https://lh3.googleusercontent.com/-hBW82hxnHIE/U2kPLgV2BSI/AAAAAAAAAU4/wpXMZ7eVtqU/s2560/LINE_Phishing_02.png)

瀏覽器打開之後，跳出了領取貼圖的「網頁」，而且還有詭異的紅字。各種跡象都跟一般領取貼圖的模式不同，太令人起疑了。點了圖就會跳到 Facebook 登入頁面。

[![假 Facebook 登入頁面騙取帳號密碼](https://lh6.googleusercontent.com/--bO6e0Rrqwc/U2kPLHyDyCI/AAAAAAAAAUk/a4qob4-uzPI/w381-h677-no/LINE_Phishing_03.png "假 Facebook 登入頁面騙取帳號密碼")](https://lh6.googleusercontent.com/--bO6e0Rrqwc/U2kPLHyDyCI/AAAAAAAAAUk/a4qob4-uzPI/s2560/LINE_Phishing_03.png)

明眼人看到這個 Facebook 登入頁面就會發現太假了，破綻多多。Logo、網址、網頁格式破板、簡體字，太多令人懷疑的地方了。在這邊我們只要隨便輸入帳號跟密碼，就能到下個畫面。

[![假 Facebook 登入完成頁面](https://lh3.googleusercontent.com/-gCfMgE3Jp3A/U2kPMJmUgYI/AAAAAAAAAUs/WuzFRNt3LXI/w381-h677-no/LINE_Phishing_04.png "假 Facebook 登入完成頁面")](https://lh3.googleusercontent.com/-gCfMgE3Jp3A/U2kPMJmUgYI/AAAAAAAAAUs/WuzFRNt3LXI/s2560/LINE_Phishing_04.png)

結果當然是不會給你貼圖啦！而且網址「cuowu」是「錯誤」的拼音，也暴露了網站作者的身分。直接用瀏覽器看傳遞的頁面叫做「tj.asp」，「tj」正好是「提交」，畫面上的錯誤訊息更是大剌剌的直接秀出簡體字。

[![釣魚網站網頁訊息](https://lh5.googleusercontent.com/-4oNH9XJfjG0/U2kPMrUGMVI/AAAAAAAAAU0/kHzzJHSlNvM/w786-h647-no/LINE_Phishing_05.png "釣魚網站網頁訊息")](https://lh5.googleusercontent.com/-4oNH9XJfjG0/U2kPMrUGMVI/AAAAAAAAAU0/kHzzJHSlNvM/s2560/LINE_Phishing_05.png)

事後友人直接說 LINE 帳號被盜用發訊息了，而且密碼可能過於簡單、也沒有設定換機密碼。因此在這邊呼籲大家做好 LINE 的安全設定：

1. 加強密碼長度、複雜度
2. 設定「換機密碼」
3. 若只在手機使用 LINE，可將「允許自其他裝置登入」關閉
4. 如果有帳號被盜狀況，趕快聯絡 LINE [https://line.naver.jp/cs/](https://line.naver.jp/cs/)

大家在享受通訊軟體與朋友傳訊貼圖的同時，也必須要注意有心人士利用這些管道竊取你的帳號密碼喔！
