---
layout: post
title: '{Linux} 配置 SSH Key'
author: Vayn
date: 2010-05-04T19:40:00+0000
categories: 
  - faq
  - linux
  - ssh
  - trick

---

<p>我真是越来越懒，现在连登录服务器的密码都懒得打了，有没有什么懒人专用的办法呢？老规矩，先放狗搜一遍~</p>
<p>狗狗果然搜出一大堆有关 SSH Public Key authentication（authorize?真是记不清啊~）的文章，依葫芦画瓢地实作一遍，成功！</p>
<p>为了不增加垃圾比特，这里就只放 URL 了，一般来说照着第一篇文章就能成功。</p>
<p>1. <a href="http://josephjiang.com/article/understand-ssh-key/">SSH 免密碼登入</a></p>
<p>2. <a href="http://www.ibm.com/developerworks/cn/linux/security/openssh/part1/index.html">通用线程: OpenSSH 密钥管理，第 1 部分</a></p>
<p>3.<a href="http://help.github.com/linux-key-setup/">Generating SSH keys (Linux)</a></p>
<p>4. <a href="http://help.github.com/working-with-key-passphrases/">Working with SSH key passphrases</a></p>
<p>5. <a href="http://www.cnblogs.com/1-2-3/category/106003.html">白话数字签名系列</a></p>
<p>外送一个 ssh debug 命令: ssh -v</p>
<p>EOF</p>
