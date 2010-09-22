---
layout: post
title: '{JxLab} VaynWords 升级至 v0.5.3'
author: Vayn
date: 2010-05-08T16:02:00+0000
categories: 
  - important
  - jxlab
  - php

  - xml

---

<p>Project VaynWords 正式升级到 0.5.3 版。</p>
<p>1、本版增加 RSS 订阅功能。<br />
通过 Google Reader 等阅读器，你可以方便地在任何时间、任何地点查阅和记忆词汇。</p>
<p>2、同时还增加了 RSS 输出控制选项。<br />
你可以在新版 config.php 中找到 $vw_rss_output 变量，此变量默认值为 25，也就是说输出 25 个条目。请 <span style="font-size: large;"><b style="color: red;">务必</b></span> 用新版 config.php 覆盖旧版文件。</p>
<p>3、数据库结构略有改动。<br />
我已提供数据库升级工具 DataUpdate.inc，只须将 DataUpdate.inc 改为 DataUpdate.php 后运行一次即可。<span style="font-size: large;"><b style="color: red;">升级后请删除此文件</b></span>！</p>
<p>下载地址 <a href="http://project-vaynwords.googlecode.com/files/project-vaynwords-v0.5.3.tar.gz">http://project-vaynwords.googlecode.com/files/project-vaynwords-v0.5.3.tar.gz</a></p>
<p>更多信息请访问 <a href="http://phpsycho.jixia.org/p/vaynwords.html">http://phpsycho.jixia.org/p/vaynwords.html</a></p>
<p>===========</p>
<p>特别感谢<a href="http://www.quchao.com/">沙滩凉鞋（屈超）</a>的指点！m（＿＿）m</p>
<p>===========</p>
<p>参考资料：</p>
<p>1、<a href="http://www.w3school.com.cn/rss/index.asp" title="RSS 教程">RSS 教程</a></p>
<p>2、<a href="http://www.w3school.com.cn/xsl/index.asp" title="XSLT教程">XSLT 教程</a></p>
<p>3、<a href="http://www.w3school.com.cn/xpath/xpath_functions.asp" title="XPath、XQuery 以及 XSLT 函数">XPath、XQuery 以及 XSLT 函数</a></p>
<p>4、<a href="http://www.ibm.com/developerworks/cn/xml/x-phprss/">结合使用 PHP 和 RSS</a></p>
<p>5、<a href="http://www.ibm.com/developerworks/cn/xml/x-wxxm36.html">使用 XML: 扩展 RSS 的能力</a></p>
<p>EOF</p>
