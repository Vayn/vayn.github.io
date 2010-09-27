---
layout: post
title: '{PHP} PHP 快速分析器(PHP Quick Profiler)'
author: Vayn
date: 2010-09-26
categories:
  - PHP
  - translation

---
原文：[PHP Quick Profiler](http://particletree.com/features/php-quick-profiler/) By Ryan Campbell

翻译：Vayn a.k.a. VT &lt;vayn at(not spam) vayn dot de&gt;

在我们公司，[代码审计](http://en.wikipedia.org/wiki/Code_review)在制作优质软件的开发进程中是一个不可分割的部分。我们开发 Wufoo 的时候选择了 [mentor style approach](http://www.codinghorror.com/blog/archives/001229.html)，也就是一个开发人员在一个部分工作一段时间，然后把这个部分传递给一个更有经验的开发者进行审计。我们很喜欢这个方法，因为这意味更多的开发者慢慢熟悉不同代码层服务的基础。更重要地是，他们充当着对抗安全漏洞、内存泄漏、低效查询（poor queries）、复杂文件结构（heavy file structures）等额外保障的角色。不幸地是，这些审计也非常消耗时间，在一个小型团队中有时会对审计者造成不便——他也有他们自己的 todo list 要完成。

<p style="text-align:center;">[![Wufoo](http://particletree.com/images/ads/wufooad10.gif)](http://wufoo.com/)</p>