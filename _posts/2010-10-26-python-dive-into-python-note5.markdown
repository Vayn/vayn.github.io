---
layout: post
title: '{Python} Dive into Python Note 5'
author: Vayn
date: 2010-10-26
categories:
  - python
---

84) urllib 模块最简单的使用是提取用 urlopen 函数取回的网页的整个文本。urlopen 的返回值是象文件一样的对象，它具有一个文件对象一样的方法。

使用由 urlopen 所返回的类文件对象所能做的最简单的事情就是 read，这个对象也支持 readlines 方法，这个方法可以将文本按行放入一个列表中。当用完这个对象，要确保将它 close。

urllister.py

{% highlight python %}
from sgmllib import SGMLParser

class URLLister(SGMLParser):
    def reset(self):
        SGMLParser.reset(self)
        self.urls = []

    def start_a(self, attrs):
        href = [v for k, v in attrs if k=='href']
        if href:
            self.urls.extend(href)
{% endhighlight %}

reset 由 SGMLParser 的 \__init__ 方法来调用，也可以在创建一个分析器实例时手工来调用。所以如果您需要做初始化，在 reset 中去做，而不要在 \__init__ 中做。只要找到一个 &lt;a&gt; 标记，start_a 就会由 SGMLParser 进行调用。k==&#8217;href&#8217; 的字符串比较是区分大小写的，但是这里是安全的。因为 SGMLParser 会在创建 attrs 时将属性名转化为小写。(830)

85) 使用 urllister.py

{% highlight python %}
>>> import urllib, urllister
>>> usock = urllib.urlopen("http://diveintopython.org/")
>>> parser = urllister.URLLister()
>>> parser.feed(usock.read())
>>> usock.close()
>>> parser.close()
>>> for url in parser.urls: print url
{% endhighlight %}

调用定义在 SGMLParser 中的 feed 方法，将 HTML 内容放入分析器中。

（象 SGMLParser 这样的分析器，技术术语叫做 _消费者 (consumer)_ 。它消费 HTML，并且拆分它。也许因为这就选择了 feed 这个名字，以便同 _消费者_ 这个主题相适应。就个人来说，它让我想象在动物园看展览。里面有一个黑漆漆的兽穴，没有树，没有植物，没有任何生命的迹象。但只要您非常安静地站着，尽可能靠近着瞧，您会看到在远处的角落里有两只明眸在盯着您。但是您会安慰自已那不过是心理作用。唯一知道兽穴里并不是空无一物的方法，就是在栅栏上有一个不明显的标记，上面写着 “禁止给分析器喂食”。但也许只有我这么想，不管怎么样，这种心理想象很有意思。）

您也应该 close 您的分析器对象，但出于不同的原因。feed 方法不保证对传给它的全部 HTML 进行处理，它可能会对其进行缓冲处理，等待接收更多的内容。一旦没有更多的内容，应调用 close 来刷新缓冲区，并且强制所有内容被完全处理。(830)

86) SGMLParser 自身不会产生任何结果。它只是分析，分析，再分析，对于它找到的有趣的东西会调用相应的一个方法，但是这些方法什么都不做。我们要定义一个可以捕捉 SGMLParser 所丢出来的所有东西的一个类，接着重建整个 HTML 文档。用技术术语来说，这个类将是一个 _HTML 生产者 (producer)_ 。(840)

87) SGMLParser 子类化 BaseHTMLProcessor ，并且提供了全部的 8 个处理方法: unknown_starttag, unknown_endtag, handle_charref, handle_entityref, handle_comment, handle_pi, handle_decl 和handle_data。(840)

88) BaseHTMLProcessor 介绍：

{% highlight python %}
    def reset(self):
        self.pieces = []
        SGMLParser.reset(self)
{% endhighlight %}

注意，self.pieces 是一个 list。也许您想将它定义为一个字符串，然后不停地将每个片段追加到它的后面。这样做是可以的，但是 Python 在处理 list 方面效率更高一些。

Python 处理 list 比字符串快的原因是: list 是可变的，但字符串是不可变的。这就是说向 list 进行追加只是增加元素和修改索引。因为字符串在创建之后不能被修改，象 s = s + newpiece 这样的代码将会从原值和新片段的连接结果中创建一个全新的字符串，然后丢弃原来的字符串。这样就需要大量昂贵的内存管理，并且随着字符串变长，所需要的开销也在增长。所以在一个循环中执行 s = s + newpiece 非常不好。用技术术语来说，向一个 list 追加 n 个项的代价为 O(n)，而向一个字符串追加 n 个项的代价是 O(n^2)。

{% highlight python %}
    def unknown_starttag(self, tag, attrs):
        strattrs = "".join([' %s="%s"' % (key, value) for key, value in attrs])
        self.pieces.append("<%(tag)s%(strattrs)s>" % locals())
{% endhighlight %}

因为 BaseHTMLProcessor 没有为特别标记定义方法 (如在 [URLLister](http://woodpecker.org.cn/diveintopython/html_processing/extracting_data.html#dialect.extract.links) 中的 start_a 方法)， SGMLParser 将对每一个开始标记调用 unknown_starttag 方法。这个方法接收标记 (tag) 和属性的名字/值对的 list(attrs) 两参数，重新构造初始的 HTML，接着将结果追加到 self.pieces 后。

{% highlight python %}
    def handle_entityref(self, ref):
        self.pieces.append("&%(ref)s" % locals())
        if htmlentitydefs.entitydefs.has_key(ref):
            self.pieces.append(";")
{% endhighlight %}

重建原始的实体引用只要将 ref 包装在 &...; 字符串中间。 (实际上，一位博学的读者曾经向我指出，除些之外还稍微有些复杂。仅有某种标准的 HTML 实体以一个分号结束；其它看上去差不多的实体并不如此。幸运的是，标准 HTML 实体集已经定义在 Python 的一个叫做 htmlentitydefs 的模块中了。从而引出额外的 if 语句。)

{% highlight python %}
    def output(self):
        """Return processed HTML as a single string"""
        return "".join(self.pieces)
{% endhighlight %}

这是在 BaseHTMLProcessor 中的一个方法，它永远不会被父类 SGMLParser 所调用。Python 在处理列表方面非常出色，但对于字符串处理就逊色了。所以我们只有在某人确实需要它时才创建完整的字符串。也可以换成使用 string 模块的 join 方法: string.join(self.pieces, "")。(840)

89) Python 有两个内置的函数, locals 和 globals, 它们提供了基于 dictionary 的访问局部和全局变量的方式。Python 使用叫做名字空间的东西来记录变量的轨迹。名字空间只是一个 dictionary ，它的键就是变量名，它的值就是那些变量的值。(850)

90) 每个函数都有着自已的名字空间，叫做局部名字空间，它记录了函数的变量，包括函数的参数和局部定义的变量。(850)

91) 每个模块拥有它自已的名字空间，叫做全局名字空间，它记录了模块的变量，包括函数、类、其它导入的模块、模块级的变量和常量。还有就是内置名字空间，任何模块均可访问它，它存放着内置的函数和异常。(850)

92) Python 在所有可用的名字空间去查找变量 x 的顺序:

1. 局部名字空间 - 特指当前函数或类的方法。如果函数定义了一个局部变量 x, 或一个参数 x，Python 将使用它，然后停止搜索。
2. 全局名字空间 - 特指当前的模块。如果模块定义了一个名为 x 的变量，函数或类，Python 将使用它然后停止搜索。
3. 内置名字空间 - 对每个模块都是全局的。作为最后的尝试，Python 将假设 x 是内置函数或变量。

如果 Python 在这些名字空间找不到 x，它将放弃查找并引发一个 NameError 异常。(850)

93) 象 Python 中的许多事情一样，名字空间 _在运行时直接可以访问_ 。怎么样? 不错吧，局部名字空间可以通过内置的 locals 函数来访问。全局 (模块级别) 名字空间可以通过内置的 globals 函数来访问。(850)

94) 在 locals 与 globals 之间有另外一个重要的区别，locals 是只读的, globals 不是。locals 实际上没有返回局部名字空间，它返回的是一个拷贝。所以对它进行改变对局部名字空间中的变量值并无影响。globals 返回实际的全局名字空间，而不是一个拷贝: 与 locals 的行为完全相反。(850)

95) 基于 dictionary 的字符串格式化可用于任意数量的有名的键字。每个键字必须在一个给定的 dictionary 中存在，否则这个格式化操作将失败并引发一个 KeyError 的异常。可以两次指定同一键字，每个键字发生之处将被同一个值所替换。(860)

96) 仅为了进行字符串格式化就需要创建一个有键字和值的 dictionary 看上去的确有些小题大作。它的真正最大用处是当您碰巧已经有了象 locals 一样的有意义的键字和值的 dictionary 的时候。

BaseHTMLProcessor.py 中的基于 dictionary 的字符串格式化：

{% highlight python %}
    def handle_comment(self, text):
        self.pieces.append("<!--%(text)s-->" % locals())
{% endhighlight %}

这就是说您可以在您的字符串 (本例中是 text，它作为一个参数传递给类方法) 中使用局部变量的名字，并且每个命名的变量将会被它的值替换。如果 text 是 'Begin page footer'，字符串格式化 `"<!--%(text)s-->" % locals()` 将得到字符串 `'<!--Begin page footer-->'`。(860)

97) 使用 locals 来应用基于 dictionary 的字符串格式化是一种方便的作法，它可以使复杂的字符串格式化表达式更易读。但它需要花费一定的代价。在调用 locals 方面有一点性能上的问题，这是由于 [locals 创建了局部名字空间的一个拷贝](http://woodpecker.org.cn/diveintopython/html_processing/locals_and_globals.html#dialect.locals.readonly.example) 引起的。(860)

98) 可以在一个函数中导入模块，这意味着导入的模块只能在函数中使用。如果您有一个只能用在一个函数中的模块，这是一个简便的方法，使您的代码更模块化。(890)

{% highlight python %}
    parserName = "%sDialectizer" % dialectName.capitalize()
    parserClass = globals()[parserName]
    parser = parserClass()
{% endhighlight %}

99) capitalize 是一个我们以前未曾见过的字符串方法；它只是将一个字符串的第一个字母变成大写，将其它的字母强制变成小写。(890)

100) `parserClass = globals()[parserName]` 我们有了一个字符串形式 (parserName) 的类名称，还有一个 dictionary (globals()) 形式的全局名字空间。合起来后，我们可以得到一个以前面字符串命名的类的引用。(890)

101) `parser = parserClass()` 生成这个类的一个实例。[象函数一样调用类](http://woodpecker.org.cn/diveintopython/object_oriented_framework/instantiating_classes.html)。(890)

102) 怎么这么麻烦？ 理由之一是: 可扩展性。这个 translate 函数完全不用关心我们定义了多少个方言变换器类。

设想一下方言的名字是从程序外面的某个地方来的，也许是从一个数据库中，或从一个表格中的用户输入的值中。您可以使用任意多的服务端 Python 脚本架构来动态地生成网页；这个函数将接收在页面请求的查询字符串中的一个 URL 和一个方言名字 (两个都是字符串) ，接着输出 “翻译” 后的网页。

最后，设想一下，使用了一种插件架构的 Dialectizer 框架。您可以将每个 Dialectizer 类放在分别放在独立的文件中，在 dialect.py 中只留下 translate 函数。假定一种统一的命名模式，这个 translate 函数能够动态地从合适的文件中导入合适的类，除了方言名字外什么都不用给出。 (虽然您还没有看过动态导入，但我保证在后面的一章中会涉及到它。) 如果要加入一种新的方言，您只要在插件目录下加入一个以合适的名字命名的文件 (象 foodialect.py，它包含了 FooDialectizer 类) 。使用方言名 'foo' 来调用这个 translate 函数，将会查找 foodialect.py 模块，导入 FooDialectizer 类，这样就行了。(890)

EOF