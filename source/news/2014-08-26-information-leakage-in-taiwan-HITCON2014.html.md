---

title: "被遺忘的資訊洩漏－重點回顧"
description: "資訊洩漏是十幾年前就被一提再提的議題，在資訊安全領域中也是最最最基本該注意的事情，然而至今很多網站都還是忽略它，甚至連一些熱門網站都仍有資訊洩漏問題。來看看資訊洩漏到底影響什麼..."
category: "科普文章"
tags: [Defense, infoleak, SVN, OpenSSL, IoT]
author: "shaolin"
keywords: "Defense, infoleak, SVN, OpenSSL, IoT"
og_image: "https://lh6.googleusercontent.com/-8oFs--PeQRg/U_xM6u373RI/AAAAAAAAAos/eT4wfRradUg/w878-h659-no/information_leakage_hitcon2014.jpg"
---


### 前言

![被遺忘的資訊洩漏 / Information Leakage in Taiwan][information_leakage_hitcon2014]

在今年駭客年會企業場，我們分享了一場『被遺忘的資訊洩漏』。資訊洩漏是十幾年前就被一提再提的議題，在資訊安全領域中也是最最最基本該注意的事情，然而至今很多網站都還是忽略它，甚至連一些熱門網站都仍有資訊洩漏問題。議程中我們舉了大量的例子證明資訊洩漏其實可以很嚴重，希望能幫大家複習一下，如果網站沒有注意這些，會造成什麼樣的後果。議程投影片如下所示，就讓我們來總結一下吧！

READMORE

<center><iframe src="http://www.slideshare.net/slideshow/embed_code/38312258" width="560" height="460" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;"> </iframe></center><br>


### DEVCORE 常利用的資訊洩漏

首先我們從過往滲透測試經驗中挑選了幾個常見的資訊洩漏問題，分別如下：

- 管理介面洩漏 (p8-p19)
- 目錄(Index of)洩漏 (p20-p28)
- 錯誤訊息洩漏 (p29-p35)
- 暫存、測試資訊 (p36-p46)
- 版本控管 (p47-p55)
- DNS 資訊洩漏 (p56-p63)

以上種種不同洩漏方式，可能會洩漏出系統環境資訊、程式碼內容、含有帳號密碼的設定檔等。透過這些資訊，駭客就能組織出一個有效的攻擊行動。我們甚至在過往的經驗中，只透過目標的資訊洩漏，就直接取得資料庫操作權限(詳見投影片 p65-p71)。

為了解目前一些熱門網站是否重視這些最基本的保護，我們實際對 alexa 台灣前 525 名的網站進行資訊洩漏的調查。

![phpmyadmin 頁面洩漏狀況][phpmyadmin_leak]
![phpinfo 頁面洩漏狀況][phpinfo_leak]

在管理介面和測試頁面洩漏的項目，我們用很保守的方式測試根目錄下是否存有 phpmyadmin 和 phpinfo 頁面，結果分別有 7% 和 9% 的網站有這樣的問題。這樣的結果非常令人訝異，畢竟受測網站都是知名且有技術力的網站，而且並非所有網站都使用 php 開發，再加上我們只是測試預設的命名，實際洩漏的情況會更多！

![版本控制洩漏狀況][version_control_leak]

另一個值得一提的是版本控管洩漏問題，我們同樣保守的只針對版本控管軟體中 GIT 和 SVN 兩項進行調查。結果竟然有 10% 的網站有這樣的問題。這個現象非常嚴重！這個現象非常嚴重！這個現象非常嚴重！這個洩漏有機會能還原整個服務的原始碼，被攻擊成功的機率相當高！台灣熱門的網站裡，十個裡面就有一個存有這樣的問題，非常危險，煩請看到這篇文章的朋友能去注意貴公司的網站是否存在這樣的問題。

### 大數據資料蒐集

在這場議程中，我們還提到了另一個層次的資訊洩漏議題：當全世界主機的服務及版本資訊全部都被收集起來，會發生什麼樣的事情？

駭客擁有這樣的資料，就能夠在非常短暫的時間內篩選出有問題的主機，進行大量的入侵。我們利用類似的技術針對台灣主機快速的進行掃描，就發現了台灣有 61414 台主機可以被利用來做 DNS Amplification DDoS 攻擊、1003 台主機可以被利用來做 NTP Amplification DDoS 攻擊。也就是說，駭客可以在短時間內組織一支六萬多人的台灣大軍，可以針對他想要攻擊的目標進行攻擊。

![OpenSSL Heartbleed 尚未修復的狀況][heartbleed]

利用相同的技術，我們也順便檢驗了前陣子非常熱門的 [OpenSSL Heartbleed](http://devco.re/blog/2014/04/09/openssl-heartbleed-CVE-2014-0160/) 問題。OpenSSL Heartbleed 被稱之為『近十年網路最嚴重的安全漏洞』，其嚴重程度可以想見，然而根據我們的觀察，台灣至今仍有 1480 台 HTTP 伺服器尚未修復，而台灣前 525 大熱門網站中，也有 21 個(4%)網站未修復。足見台灣網站對於資安的意識仍然不夠。

對於這樣海量收集資料衍生的資安議題，我們認為最大的受害者，是物聯網的使用者！就我們的觀察，物聯網的設備通常安全防護不佳，容易遭受到駭客攻擊，前陣子 [HP 也出了一份報告指出](http://www8.hp.com/us/en/hp-news/press-release.html?id=1744676)，物聯網的設備有七成存在弱點，而且每台設備平均有 25 個弱點。除此之外，物聯網的設備不易更新，少有人會定期更新，更導致物聯網設備可以被大範圍的攻擊，進而滲透家用網路，危害使用者居家隱私。這是個未來需要持續關注的重要議題。

![仍暴露在 SynoLocker 風險狀況統計][synolocker]

最後，我們用最近 SynoLocker 的案例為大數據資料蒐集作結，SynoLocker 是一款針對 Synology 的勒索軟體，去年底 Synology 官方已經推出新版修正問題，本月 SynoLocker 擴散至全世界，新聞一再強調需要更新 NAS，但我們針對台灣 1812 台對外開放的 Synology NAS 做統計，至今仍發現有 64％ 的使用者沒有更新，也就是這些 NAS 仍暴露在 SynoLocker 的風險中。這件事情又再次證明駭客有能力在短時間利用大數據資料找到攻擊目標，也順帶說明了台灣資安意識普遍不足的問題。

### 結論

在這次議題我們關注了很古老的資訊洩漏問題，並且發現目前台灣一些熱門網站仍然存在這樣的問題。資訊洩漏也許不是一件很嚴重的事情，但往往能激起駭客高漲的情緒，駭客會認為一個網站連最最最基本的資料保護都沒有做到，一定會存在其他資安問題，進而進行更大量的攻擊行為。而事實上，我們也從實例證明了其實資訊洩漏可以很嚴重，希望網站提供者能夠注重這個簡單可解決且重要的議題。

我們也提到了駭客透過平常大量的資料收集，在需要的時候能快速找到目標並且大範圍攻擊。這其中又以物聯網的用戶影響最多。面對這樣的議題，我們建議除了適當的隱藏(偽造)主機版本資訊以避免出現 0-Day 時成為首要攻擊目標。我們也提倡要對自己的服務做普查，了解自己到底對外開啟了什麼服務，以及關注自己使用的[第三方套件](http://devco.re/blog/2014/03/14/3rd-party-software-security-issues/)是否有安全更新。

希望明年不需要再有一篇『依舊沒改變的資訊洩漏』！大家快點注意這件簡單的事情吧！


[information_leakage_hitcon2014]: https://lh6.googleusercontent.com/-8oFs--PeQRg/U_xM6u373RI/AAAAAAAAAos/eT4wfRradUg/w878-h659-no/information_leakage_hitcon2014.jpg
[phpmyadmin_leak]: https://lh4.googleusercontent.com/-nkTDQZHfH1Y/U_xNFWwqgsI/AAAAAAAAAo0/ElXB9PWtF1s/w878-h659-no/phpmyadmin_leak.jpg
[phpinfo_leak]: https://lh4.googleusercontent.com/-To2bi4RSj-E/U_xNGVtGRrI/AAAAAAAAAo8/cIL9Gw15Yv0/w878-h659-no/phpinfo_leak.jpg
[version_control_leak]: https://lh6.googleusercontent.com/-cswPNS5-A3Q/U_xNHRv8hcI/AAAAAAAAApE/7xwduuTUug8/w878-h659-no/version_control_leak.jpg
[heartbleed]: https://lh5.googleusercontent.com/-BBzmwDTmrtk/U_xPpzBhcnI/AAAAAAAAApY/OtleTlTFIrA/w878-h659-no/heartbleed.jpg
[synolocker]: https://lh5.googleusercontent.com/-2Cj8HGgmtHs/U_xPqgVi1CI/AAAAAAAAApg/YpZkYboUk24/w878-h659-no/synolocker.jpg