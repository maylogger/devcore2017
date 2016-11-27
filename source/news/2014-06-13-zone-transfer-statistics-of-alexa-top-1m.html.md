---
layout: post
title: "Zone Transfer Statistics of Alexa Top 1 Million"
description: "Zone Transfer 雖然已經是一個古老的 DNS 資安問題，但仍然有許多企業對此不設防。本篇將為大家說明 Alexa Top 1M 的 Zone Transfer 資安議題相關統計結果。"
category: "技術專欄"
tags: [DNS, CVE, Reconnaissance, Statistics]
author: "bowenhsu"
keywords: "DNS,CVE,Reconnaissance,Statistics"
---


### Zone Transfer 世界大揭秘

還記得在上一篇文章 [Zone Transfer CVE-1999-0532 - 古老的 DNS 資安議題](http://devco.re/blog/2014/05/05/zone-transfer-CVE-1999-0532-an-old-dns-security-issue/)中我們曾提到，若對全世界的網站進行 zone transfer 檢測恐怕會有更多驚人的案例嗎？正好 [Alexa 提供了全球排名前一百萬名的網站資料](http://s3.amazonaws.com/alexa-static/top-1m.csv.zip)，我們就以這份資料為基礎來做一些統計吧！

### 有問題的 domain 總數與比例

* 79133，約佔所有受測目標的 8.014%
* 上述 domain 的所有 zone file 共含有 22631804 筆 DNS 記錄

由於在 Alexa Top 1M 中有許多資料是重複的 domain，另外也有些資料是 IP，在本次的檢測當中都不列入計算，因此受測 domain 總數僅有 987447 個，而非一百萬個。另外，本次掃描為求快速犧牲了部分準確率，因此實際數量應比 79133 更多。

READMORE

### 有問題的 Top-Level Domain (TLD) 數量

* 全世界 TLD 總數：567
* 受測目標的 TLD 總數：316，佔全世界總數的 55.73%
* 有 zone transfer 問題的 TLD 總數：220，佔受測目標的 69.62%

目前 TLD 總數的數據取自於 [Internet Assigned Numbers Authority (IANA)](https://data.iana.org/TLD/tlds-alpha-by-domain.txt)，不了解 TLD 是什麼的人可以參考[這篇維基百科文章](http://en.wikipedia.org/wiki/Top-level_domain)。

有趣的是，連一些新的 TLD 都有 zone transfer 問題，例如 .technology、.museum 等等，可見這真的很容易被大家忽略～

### 關於各個 TLD 的統計數據

* Transferable domain in this TLD：在特定 TLD 中，有多少 domain 可任意執行 zone transfer
* Same TLD in Alexa top 1M：特定 TLD 在本次 987447 個受測目標中所佔的數量
* Percentage of same TLD in Alexa top 1M：特定 TLD 在 Alexa top 1M 內所有同樣 TLD 所佔的百分比（例：.com 即為 35230 / 527203 = 6.68%）
* Percentage of all transferable domain：某特定 TLD 可任意執行 zone transfer 的數量在本次所有可任意執行 zone transfer 所占的百分比（例：.com 即為 35230 / 79133 = 44.52%）

由於原始數據太多，因此本文僅列出前 25 名。

[![Zone Transfer 問題的 TLD 相關統計](https://lh6.googleusercontent.com/-taAD_Ilxm2c/U2mqBEzEx2I/AAAAAAAAAVY/Jv-_PR7i9xQ/w494-h750-no/zone-transfer-statistics-of-TLD.png "Zone Transfer 問題的 TLD 相關統計")](https://lh6.googleusercontent.com/-taAD_Ilxm2c/U2mqBEzEx2I/AAAAAAAAAVY/Jv-_PR7i9xQ/w494-h750-no/zone-transfer-statistics-of-TLD.png "Zone Transfer 問題的 TLD 相關統計")

.tw 網域排第二十一名，幸好這次不是世界第一了，否則又是另類的台灣之光。

### 關於 name server 的統計數據

* Number of domain：該台 name server 有多少 domain 可任意執行 zone transfer

由於原始數據太多，因此本文僅列出前 25 名。

[![Zone Transfer 問題的 name server 相關統計](https://lh5.googleusercontent.com/-VNyNVj3MkAA/U2mqBMfEKfI/AAAAAAAAAVU/FGGPow_qt_E/w367-h693-no/zone-transfer-statistics-of-name-server.png "Zone Transfer 問題的 name server 相關統計")](https://lh5.googleusercontent.com/-VNyNVj3MkAA/U2mqBMfEKfI/AAAAAAAAAVU/FGGPow_qt_E/w367-h693-no/zone-transfer-statistics-of-name-server.png "Zone Transfer 問題的 name server 相關統計")

> 可執行 zone transfer 且不重複的 namer server 共有 53830 個

### 關於 IP 位址的統計數據

* 有 7939172 個不重複的 IP 位址
* 在全部 IP 位址中，有 704638 個是私有 IP 位址
* 在私有 IP 位址中，有 598443 個是 10. 開頭，佔所有 IP 位址的 7.538%，佔私有 IP 位址的 84.929%
* 在私有 IP 位址中，有 66270 個是 172.16~31 開頭，佔所有 IP 位址的 0.835%，佔私有 IP 位址的 9.405%
* 在私有 IP 位址中，有 39925 個是 192.168 開頭，佔所有 IP 位址的 0.503%，佔私有 IP 位址的 5.666%

### subdomain 的統計數據

以下選出一些常被入侵者當作攻擊目標的 subdomain 來計算在 22631804 筆 DNS 記錄中分別各佔了幾筆，每個 subdomain 共有兩個統計結果，逗號左邊的統計結果代表以該 subdomain 開頭的 DNS 記錄，例如 git.devco.re。逗號右邊的統計結果則將前後有數字的 subdomain 也一併計入，例如 dns01.devco.re、01dns.devco.re、0dns001.devco.re 等等。

* 版本控制

  git: 583, 626

  gitlab: 138, 138

  svn: 1552, 1669

  subversion: 71, 72

  cvs: 284, 330

  hg: 115, 331

  mercurial: 18, 19

* 開發與測試

  test: 14691, 20001

  dev: 8300, 10959

  stage: 1329, 1628

* 資料庫

  db: 1190, 2537

  database: 150, 302

  sql: 2209, 3298

  mysql: 4045, 4998

  postgre: 11, 11

  redis: 21, 33

  mongodb: 6, 42

  memcache: 13, 72

  phpmyadmin: 455, 485

* 後台管理

  manager: 188, 222

  staff: 481, 542

  member: 331, 376

  backend: 153, 177

* 線上服務相關

  api: 1871, 2097

  search: 1469, 10987

  pic: 178, 293

  img: 1775, 3517

  service: 779, 959

  payment: 225, 238

  cache: 373, 627

* 私有服務

  erp: 275, 318

  eip: 69, 80

  log: 227, 414

  nagios: 636, 736

  mrtg: 458, 565

  cgi: 194, 261

  dns: 2634, 9085

  ns: 12198, 63431

  ftp: 197414, 199481

  blog: 5074, 5446

  mail: 238742, 254515

  email: 2484, 2706

  webmail: 24164, 25067

  owa: 798, 888

  autodiscover: 30462, 30466

  vpn: 3152, 7025

  sso: 398, 462

  ssl: 709, 932

  proxy: 1464, 2215

  cms: 1320, 1696

  crm: 1152, 1301

  forum: 3654, 4037

### 按 End 的人有福了

究竟經由 zone transfer 所得到的資料可以拿來做什麼？對於攻擊者而言，主要有以下三種利用方式：

* 建立字典檔：入侵者可利用上述資料建立一份最常見的 subdomain 的字典檔，未來利用此字典檔進行掃描時可節省許多時間成本，快速檢測某間公司有哪些 subdomain
* 旁敲側擊：入侵者可觀察哪些 name server 有開放 zone transfer 查詢，接著去蒐集還有哪些公司使用同一台 name server，再進一步掃瞄那些 domain。那些 domain 也許不是大公司、不在 Alexa top 1M 內，但你無法確保它永遠不會是入侵者的攻擊目標。
* 結合 0day 進行攻擊：當某個第三方套件被揭露 0day 弱點時，擁有上述資料的人就可以迅速執行大範圍的攻擊。例如[這幾年正夯的 Rails 在去年被爆出有 Remote Code Exection 弱點 CVE-2013-0156](http://www.cvedetails.com/cve/CVE-2013-0156/)，入侵者可直接對所有 redmine 進行攻擊。[Juniper VPN 在今年也被揭露 Remote Code Execution 弱點](http://www.cvedetails.com/cve/CVE-2014-3412/)，入侵者可找尋所有 vpn subdomain 來進行嘗試。

在上次我們提起這個古老的弱點後，已經有部分台灣企業陸續將此問題修復，但許多台灣企業仍有此問題而不自知，也許過陣子我們直接做個 Wall of Shame 條列出哪些廠商有問題會讓大家比較有感 :p

不過也別急著笑台灣企業，許多國際級的大網站同樣也有此類問題。由此可見資安問題不分新舊、不分國內外，總是容易被大家忽略，等到不知不覺被入侵者捅了重重的一刀後，才驚覺這許多的小弱點一旦串起來是多麼的可怕。你，開始有所警覺了嗎？