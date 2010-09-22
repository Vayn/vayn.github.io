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

Project VaynWords 正式升级到 0.5.3 版。

1、本版增加 RSS 订阅功能。

通过 Google Reader 等阅读器，你可以方便地在任何时间、任何地点查阅和记忆词汇。

2、同时还增加了 RSS 输出控制选项。

你可以在新版 config.php 中找到 $vw_rss_output 变量，此变量默认值为 25，也就是说输出 25 个条目。请 __务必__ 用新版 config.php 覆盖旧版文件。

3、数据库结构略有改动。

我已提供数据库升级工具 DataUpdate.inc，只须将 DataUpdate.inc 改为 DataUpdate.php 后运行一次即可。 __升级后请删除此文件！__

下载地址 [http://project-vaynwords.googlecode.com/files/project-vaynwords-v0.5.3.tar.gz](http://project-vaynwords.googlecode.com/files/project-vaynwords-v0.5.3.tar.gz)

---

特别感谢[沙滩凉鞋（屈超）](http://www.quchao.com/)的指点！m（＿＿）m

---

参考资料：

1. [RSS 教程](http://www.w3school.com.cn/rss/index.asp 'RSS')
