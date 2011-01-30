---
layout: post
title: '{Python} Dive into Python Note 6'
author: Vayn
date: 2010-10-27
categories:
  - python
---

103) `from xml.dom import minidom` Python 认为它的意思是“在 xml 目录中查找 dom 目录，然后在其中查找 minidom 模块，接着导入它并以 minidom 命名 ”。但是 Python 更聪明；你不仅可以导入包含在一个包中的所有模块，还可以从包的模块中有选择地导入指定的类或者函数。(920)

104) 如果你发现自己正在用 Python 编写一个大型的子系统（或者，很有可能，当你意识到你的小型子系统已经成长为一个大型子系统时），你应该花费些时间设计一个好的 __包__ 架构。它是 Python 所擅长的事情之一，所以应该好好利用它。(920)

105) `xmldoc = minidom.parse('~/diveintopython/common/py/kgp/binary.xml')` `xmldoc.firstChild` Node 类有一个 firstChild 属性，它和childNodes\[0]具有相同的语义。（还有一个 lastChild 属性，它和childNodes\[-1]具有相同的语义。）(920)

106) toxml 用于任何节点：

{% highlight python %}
>>> grammarNode = xmldoc.firstChild
>>> print grammarNode.toxml()
{% endhighlight %}

toxml 方法是定义在 Node 类中的，所以对任何 XML 节点都是可用的，不仅仅是 Document 元素。(930)

107) 查看 binary.xml 中的 XML ，你可能会认为 grammar 只有两个子节点，即两个 ref 元素。但是你忘记了一些东西：硬回车！在'&lt;grammar&gt;'之后，第一个'&lt;ref&gt;'之前是一个硬回车，并且这个文本算作 grammar 元素的一个子节点。(930)

108) Text 节点的.data属性可以向你提供文本节点真正代表的字符串。(930)

109) 当 Python 解析一个 XML 文档时，所有的数据都是以unicode的形式保存在内存中的。(940)

110) unicode用一个 2 字节数字表示每个字符，从 0 到 65535。[5] 每个 2 字节数字表示至少在一种世界语言中使用的一个唯一字符。（在多种语言中都使用的字符具有相同的数字码。）这样就确保每个字符一个数字，并且每个数字一个字符。(940)

111) 为了创建一个unicode字符串而不是通常的 ASCII 字符串，要在字符串前面加上字母“u”。

{% highlight python %}
>>> s = u'La Pe\xf1a'
>>> print s
Traceback (innermost last):
  File "<interactive input>", line 1, in ?
UnicodeError: ASCII encoding error: ordinal not in range(128)
>>> print s.encode('latin-1')
La Peña
{% endhighlight %}

unicode真正的优势，理所当然的是它保存非 ASCII 字符的能力，例如西班牙语的“ñ”(n上带有一个波浪线）。用来表示波浪线n的unicode字符编码是十六进制的0xf1 (十进制的241），你可以象这样输入：\\xf1

s是一个unicode字符串，Python 试图将字符串转换为你的默认编码（转换是无缝的），而 print 只能打印正常的字符串。为了解决这个问题，我们调用 encode 方法（它可以用于每个unicode字符串）将unicode字符串转换为指定编码模式的正常字符串。我们向此函数传入一个参数。在本例中，我们使用 latin-1 （也就是大家知道的 iso-8859-1）。（940）

112) 定制默认编码模式：

{% highlight python %}
# sitecustomize.py
# this file can be anywhere in your Python path,
# but it usually goes in ${pythondir}/lib/site-packages/
import sys
sys.setdefaultencoding('iso-8859-1')
{% endhighlight %}

sitecustomize.py是一个特殊的脚本；Python 会在启动的时候导入它，所以在其中的任何代码都将自动运行。(940)

113) 如果你打算在你的 Python 代码中保存非 ASCII 字符串，你需要在每个文件的顶端加入编码声明来指定每个.py文件的编码。

{% highlight python %}
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
{% endhighlight %}

(940)

114) 每个 Element 对象都有一个称为attributes的属性，它是一个　NamedNodeMap 对象。听上去挺吓人的，其实不然，因为 NamedNodeMap 是一个[行为像字典](http://woodpecker.org.cn/diveintopython/object_oriented_framework/userdict.html)的对象。(960)

115) 访问单个属性：

{% highlight python %}
>>> a = bitref.attributes["id"]
>>> a
<xml.dom.minidom.Attr instance at 0x81d5044>
>>> a.name  
u'id'
>>> a.value 
u'bit'
{% endhighlight %}

Attr 对象完整代表了单个 XML 元素的单个 XML 属性。属性的名称（在bitref.attributes NamedNodeMap 的伪目录中寻找的对象同名）保存在a.name中。

116) 类似于字典，一个 XML 元素的属性没有顺序。属性可以以某种顺序 _偶然_ 列在最初的 XML 文档中，而在 XML 文档解析为 Python 对象时，Attr 对象以某种顺序 _偶然_ 列出，这些顺序都是任意的，没有任何特别的含义。你应该总是使用名称来访问单个属性，就像字典的键一样。(960)

EOF