---
layout: post
title: '{Python} Dive into Python Note 2'
author: Vayn
date: 2010-10-23
categories:
  - python
---

20) 自省（introspection）是指代码可以查看内存中以对象形式存在的其它模块和函数，获取它们的信息，并对它们进行操作。用这种方法, 你可以定义没有名称的函数，不按函数声明的参数顺序调用函数，甚至引用事先并不知道名称的函数。（[Python 自省指南](http://www.ibm.com/developerworks/cn/linux/l-pyint/index.html)）(410)

21) type 函数返回任意对象的数据类型。在 types 模块中列出了可能的数据类型。type 可以接收任何东西作为参数。你可以使用 types 模块中的常量来进行对象类型的比较。(431)

22) str 将数据强制转型为字符串。每种数据类型都可以强制转型为字符串。str 还允许作用于模块。注意模块的字符串形式表示包含了模块在磁盘上的路径名。(432)

23) dir 函数返回任意对象的属性和方法列表。(432)

24) callable 函数，它接收任何对象作为参数，如果参数对象是可调用的那么返回 True，否则返回 False。可调用对象包括函数、类方法，甚至类自身。(432)

25) string 模块中的函数现在已经不赞成使用了（尽管很多人现在仍然还在使用 join 函数），但是在这个模块中包含了许多有用的变量比如 string.punctuation，这个模块包含了所有标准的标点符号字符。(432)

26) 任何可调用的对象都有 doc string。通过将 callable 函数作用于一个对象的每个属性，可以确定哪些属性（方法、函数、类）是你要关注的，哪些属性（常量等等）是你可以忽略、之前不需要知道的。(432)

27) type、str、dir 和其它的 Python 内置函数都归组到了 __builtin__ （前后分别是双下划线）这个特殊的模块中。你可以认为 Python 在启动时自动执行了 from __builtin__ import *。(433)

28) 注意 li.pop 并不是调用 pop 方法；调用 pop 方法的应该是 li.pop()。这里指的是方法对象本身。(440)

29) 使用 getattr 函数，可以得到一个直到运行时才知道名称的函数的引用。如果不信它是多么的有用，试试这个：getattr 的返回值 _是_ 方法 getattr(li, "append")("Moe")，然后你就可以调用它就像直接使用 li.append("Moe") 一样。但是实际上你没有直接调用函数；只是以字符串形式指定了函数名称。(440)

30) getattr 不仅仅适用于内置数据类型，也可作用于模块。(441)

31) getattr 常见的使用模式是作为一个分发者。例子：

{% highlight python %}
import statsout

def output(data, format="text"):                              
    output_function = getattr(statsout, "output_%s" % format) 
    return output_function(data) 
{% endhighlight %}

如果用户传入一个格式参数，但是在 statsout 中没有定义相应的格式输出函数，会发生什么呢？还好，getattr 会返回 None，它会取代一个有效函数并被赋值给 output_function，然后下一行调用函数的语句将会失败并抛出一个异常。这种方式不好。(442)

32) getattr 能够使用可选的第三个参数，一个缺省返回值。例子：

{% highlight python %}
import statsout

def output(data, format="text"):
    output_function = getattr(statsout, "output_%s" % format, statsout.output_text)
    return output_function(data)
{% endhighlight %}

第三个参数是一个缺省返回值，如果第二个参数指定的属性或者方法没能找到，则将返回这个缺省返回值。(442)

33) 过滤列表语法：

[`[_mapping-expression_ for _element_ in _source-list_ if _filter-expression_]`](http://woodpecker.org.cn/diveintopython/native_data_types/mapping_lists.html)

count 是一个列表方法，返回某个值在列表中出现的次数。(450)

34) 回到 [apihelper.py](http://woodpecker.org.cn/diveintopython/power_of_introspection/index.html#apihelper.intro.1.1) 中的这一行：

`methodList = [method for method in dir(object) if callable(getattr(object, method))]`

整个过滤表达式返回一个列表，并赋值给 methodList 变量。表达式的前半部分是列表映射部分。映射表达式是一个和遍历元素相同的表达式，因此它返回每个元素的值。dir(object) 返回 object 对象的属性和方法列表——你正在映射的列表。

过滤表达式。如果 object 是一个模块，并且 method 是上述模块中某个函数的名称，那么表达式 getattr(object, method) 将返回一个函数对象。

所以这个表达式接收一个名为 object 的对象，然后得到它的属性、方法、函数和其他部件的名称列表，接着过滤掉我们不关心的部件。执行过滤行为是通过对每个属性/方法/函数的名称调用 getattr 函数取得实际部件的引用，然后检查这些部件对象是否是可调用的，当然这些可调用的部件对象可能是方法或者函数，同时也可能是内置的（比如列表的 pop 方法）或者用户自定义的（比如 odbchelper 模块的 buildConnectionString 函数）。这里你不用关心其它的属性，如内置在每一个模块中的 __name__ 属性。

35) 在Python 中，and 和 or 执行布尔逻辑演算，如你所期待的一样，但是它们并不返回布尔值；而是，返回它们实际进行比较的值之一。0、''、\[\]、()、{}、None 在布尔上下文中为假；其它任何东西都为真。(460)

36) 如果布尔上下文中的某个值为假，则 and 返回第一个假值。所有值都为真，所以 and 返回最后一个真值。(460)

37) 如果布尔上下文中有一个值为真，or 立刻返回该值。如果所有的值都为假，or 返回最后一个假值。注意 or 在布尔上下文中会一直进行表达式演算直到找到第一个真值，然后就会忽略剩余的比较值。(460)

38) and-or 技巧介绍：

{% highlight python %}
>>> a = "first"
>>> b = "second"
>>> 1 and a or b 
'first'
>>> 0 and a or b 
'second'
{% endhighlight %}

由于这种 Python 表达式单单只是进行布尔逻辑运算，并不是语言的特定构成，这是 and-or 技巧和 C 语言中的 _bool_ ? a : b 语法非常重要的不同。如果 a 为假，表达式就不会按你期望的那样工作了。

{% highlight python %}
>>> a = ""
>>> b = "second"
>>> 1 and a or b         
'second'
{% endhighlight %}

由于 a 是一个空字符串，在 Python 的布尔上下文中空字符串被认为是假的，1 and '' 的演算值为 ''，最后 '' or 'second' 的演算值为 'second'。

在 and-or 技巧后面真正的技巧是，确保 a 的值决不会为假。最常用的方式是使 a 成为 [a] 、 b 成为 [b]，然后使用返回值列表的第一个元素，应该是 a 或 b中的某一个。

{% highlight python %}
>>> a = ""
>>> b = "second"
>>> (1 and [a] or [b])[0]
{% endhighlight %}

由于 [a] 是一个非空列表，所以它决不会为假。即使 a 是 0 或者 '' 或者其它假值，列表 [a] 也为真，因为它有一个元素。(461)

39) 在 Python 语言的某些情况下 if 语句是不允许使用的，比如在 lambda 函数中。这个时候，上面的技巧就有它的价值了。(461)

40) Python（2.5及以上） 支持三元描述符：[V1 if X else V2](http://www.vimer.cn/2010/09/python%E4%B8%89%E5%85%83%E8%BF%90%E7%AE%97%E7%AC%A6%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%96%B9%E6%B3%95.html)。

41) Python 支持一种有趣的语法，它允许你快速定义单行的最小函数。这些叫做 lambda 的函数，是从 Lisp 借用来的，可以用在任何需要函数的地方。[你可以使用 lambda 函数甚至不需要将它赋值给一个变量](http://woodpecker.org.cn/diveintopython/power_of_introspection/lambda_functions.html#apihelper.lambda.1.3)。(470)

42) [apihelper.py](http://woodpecker.org.cn/diveintopython/power_of_introspection/index.html#apihelper.intro.1.1) 中的 lambda 函数：

{% highlight python %}
    processFunc = collapse and (lambda s: " ".join(s.split())) or (lambda s: s)
{% endhighlight %}

这里使用了 [and-or](http://woodpecker.org.cn/diveintopython/power_of_introspection/and_or.html) 技巧的简单形式，lambda 函数在[布尔上下文中](http://woodpecker.org.cn/diveintopython/native_data_types/lists.html#tip.boolean)总是为真（这并不意味这 lambda 函数不能返回假值。这个函数对象的布尔值为真；它的返回值可以是任何东西。）。(471)

processFunc 现在是一个函数，但是它到底是哪一个函数还要取决于 collapse 变量。如果 collapse 为真，processFunc(_string_) 将压缩空白；否则 processFunc(_string_) 将返回未改变的参数。(471)

43) 没有参数的 split 函数按空白（空格、换行、制表）进行分割。(471)

44) 严格地讲, 在小括号, 方括号或大括号中的表达式可以用或者不用续行符 (“\”) 分割成多行。(340)

45) 分析 [apihelper.py](http://woodpecker.org.cn/diveintopython/power_of_introspection/index.html#apihelper.intro.1.1) 最后也是核心的一段：

{% highlight python %}
    print "\n".join(["%s %s" %
                      (method.ljust(spacing),
                       processFunc(str(getattr(object, method).__doc__)))
                     for method in methodList])
{% endhighlight %}

从后向前：

`for method in methodList` 使用 method 遍历列表。

`getattr(object, method).__doc__` 动态得到 doc string。

str 是一个内置函数，它可以 [强制将数据转化为字符串](http://woodpecker.org.cn/diveintopython/power_of_introspection/built_in_functions.html)。但是一个 doc string 应该总是一个字符串，为什么还要费事的使用 str 函数呢？答案就是：不是每个函数都有 doc string ，如果没有，这个 __doc__ 属性为 None。

在 SQL 中，你必须使用 IS NULL 代替 = NULL 进行 null 值比较。在 Python，你可以使用 == None 或者 is None 进行比较，但是 is None 更快。

现在你看出来为什么使用 str 将 None 转化为一个字符串很重要了。processFunc 假设接收到一个字符串参数然后调用 split 方法，如果你传入 None ，将导致程序崩溃，因为 None 没有 split 方法。

ljust 用空格填充字符串以符合指定的长度。如果指定的长度小于字符串的长度，ljust 将简单的返回未变化的字符串。它决不会截断字符串。

有了 ljust 方法填充过的方法名称和来自调用 processFunc 方法得到的 doc string（可能压缩过），你就可以将两者连接起来并得到单个字符串。因为对 methodList 进行了映射，最终你将获得一个字符串列表。利用 "\n" 的 join 函数，将这个列表连接为单个字符串，列表中每个元素独占一行，接着打印出结果。

EOF