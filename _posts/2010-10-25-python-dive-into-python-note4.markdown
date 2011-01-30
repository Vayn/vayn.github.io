---
layout: post
title: '{Python} Dive into Python Note 4'
author: Vayn
date: 2010-10-25
categories:
  - python
---

65) 如果知道一行代码可能会引发异常，你应该使用一个 try...except 块来处理异常。(610)

66) 一个 try...except 块可以有一条 else 子句，就象 if 语句。如果在 try 块中没有异常引发，然后 else 子句被执行。(611)

67) Python 有一个内置函数，open，用来打开在磁盘上的文件。open 返回一个文件对象，它拥有一些方法和属性，可以得到打开文件的信息，和对打开文件进行操作。(620)

68) open 方法可以接收三个参数：文件名，模式，和缓冲区参数。只有第一个参数，文件名，是必须的；其它两个是 [可选的](http://woodpecker.org.cn/diveintopython/power_of_introspection/optional_arguments.html)。

69) 文件对象的 tell 方法告诉你在打开文件中的当前位置。

文件对象的 seek 方法在打开文件中移动到另一个位置。第二个参数指出第一个参数是什么意思：0 表示移动到一个绝对位置 （从文件开始算起），1 表示移到一个相对位置 （从当前位置算起），还有 2 表示对于文件尾的一个相对位置。(621)

70) closed 属性证实了文件被关闭了。(622)

71) 下面这个例子展示了如何安全的打开文件和读取文件以及优美地处理错误。

{% highlight python %}
 try:
    fsock = open(filename, "rb", 0)
        try:
            fsock.seek(-128, 2)
            tagdata = fsock.read(128)
        finally:
            fsock.close()
        .
        .
        .
except IOError:
    pass
{% endhighlight %}

在 finally 块中的代码将 _总是_ 被执行，甚至某些东西在 try 块中引发一个异常也会执行。(623)

72) file 是 open 的同义语。 它用一行打开文件, 读取内容, 并打印它们。[将一个文件一次一行地读到 list 中](http://www.python.org/doc/current/tut/node9.html#SECTION009210000000000000000)。[各种各样读取文件方法](http://www.effbot.org/guides/readline-performance.htm)。(624)

73) for 循环不仅仅用于简单计数。 它们可以遍历任何类型的东西。

{% highlight python %}
>>> import os
>>> for k, v in os.environ.items():
...     print "%s=%s" % (k, v)
>>>
>>> print "\n".join(["%s=%s" % (k, v)
...     for k, v in os.environ.items()])
{% endhighlight %}

os.environ 是在你的系统上所定义的环境变量的 dictionary。下面的版本稍微快一些，因为它只有一条 print 语句而不是许多。(630)

74) 分析 [第 5 章](http://woodpecker.org.cn/diveintopython/object_oriented_framework/index.html) 样例程序 fileinfo.py 中 MP3FileInfo 的 for 循环：

{% highlight python %}
    tagDataMap = {"title"   : (  3,  33, stripnulls),
                  "artist"  : ( 33,  63, stripnulls),
                  "album"   : ( 63,  93, stripnulls),
                  "year"    : ( 93,  97, stripnulls),
                  "comment" : ( 97, 126, stripnulls),
                  "genre"   : (127, 128, ord)}
    .
    .
    .
            if tagdata[:3] == "TAG":
                for tag, (start, end, parseFunc) in self.tagDataMap.items():
                    self[tag] = parseFunc(tagdata[start:end])
{% endhighlight %}

一旦我们读出文件最后 128 个字节，第 3 到 32 字节总是歌曲的名字，33-62 总是歌手的名字，63-92 为专辑的名字，等等。请注意 tagDataMap 是一个 tuple 的 dictionary，每个 tuple 包含两个整数和一个函数引用。

将 parseFunc 作为值赋值给伪字典 self 中的键字 tag。(630)

75) 当导入新的模块，它们加入到 sys.modules 中。这就解释了为什么第二次导入相同的模块时非常的快：Python 已经在 sys.modules 中装入和缓冲了，所以第二次导入仅仅对字典做了一个查询。(640)

76) 每个 Python 类拥有一个内置的 类属性 \__module__，它定义了这个类的模块的名字。(640)

77) fileinfo.py 中的 sys.modules：

{% highlight python %}
    def getFileInfoClass(filename, module=sys.modules[FileInfo.__module__]):
        "get file info class from filename extension"
        subclass = "%sFileInfo" % os.path.splitext(filename)[1].upper()[1:]
        return hasattr(module, subclass) and getattr(module, subclass) or FileInfo
{% endhighlight %}

你可能认为 Python 会在每次函数调用时计算这个 sys.modules 表达式。实际上，Python 仅会对缺省表达式计算一次，是在模块导入的第一次。

现在，只要相信 subclass 最终为一个类的名字就行了，象 MP3FileInfo。

hasattr 是一个补充性的函数，用来检查是否一个对象具有一个特别的属性；在本例中，用来检查一个模块是否有一个特别的类 （然而它可以用于任何类和任何属性，就象 getattr）。

[缺省参数到底在什么时候和是如何计算的](http://www.python.org/doc/current/tut/node6.html#SECTION006710000000000000000)。(640)

78) os.path 的 join 函数用一个或多个部分路径名构造成一个路径名。

expanduser 函数将对使用 ~ 来表示当前用户根目录的路径名进行扩展。

split 函数对一个全路径名进行分割，返回一个包含路径和文件名的 tuple `(filepath, filename) = os.path.split("c:\\music\ap\mahadeva.mp3")`。

splitext 函数可以用来对文件名进行分割，并且返回一个包含了文件名和文件扩展名的 tuple。

{% highlight python %}
>>> [f for f in os.listdir(dirname)
...     if os.path.isfile(os.path.join(dirname, f))]
>>>
>>> [f for f in os.listdir(dirname)
...     if os.path.isdir(os.path.join(dirname, f))]
{% endhighlight %}

你可以使用 [过滤列表](http://woodpecker.org.cn/diveintopython/power_of_introspection/filtering_lists.html) 和 os.path 模块的 isfile 函数，从文件夹中将文件分离出来。isfile 接收一个路径名，如果路径表示一个文件，则返回 1，否则为 0。可以使用 os.getcwd() 来得到当前的工作目录。isdir 函数，当路径表示一个目录，则返回 1，否则为 0。(650)

79) os.path.normcase(f) 根据操作系统的缺省值对大小写进行标准化处理。 normcase 用于对大小写不敏感操作系统的一个补充。(650)

80) 超级强大的 glob 模块：

{% highlight python %}
>>> import glob
>>> glob.glob('c:\\music\\_singles\\*.mp3')
['c:\\music\\_singles\\a_time_long_forgotten_con.mp3',
'c:\\music\\_singles\\hellraiser.mp3',
'c:\\music\\_singles\\kairo.mp3',
'c:\\music\\_singles\\long_way_home1.mp3',
'c:\\music\\_singles\\sidewinder.mp3',
'c:\\music\\_singles\\spinning.mp3']
>>> glob.glob('c:\\music\\_singles\\s*.mp3')
['c:\\music\\_singles\\sidewinder.mp3',
'c:\\music\\_singles\\spinning.mp3']
>>> glob.glob('c:\\music\\*\\*.mp3')
{% endhighlight %}

glob 模块选取一个通配符并且返回文件的或目录的完整路径与之匹配。(650)

81) _嵌套函数_ ，从字面理解，是定义在函数内的函数。嵌套函数 getFileInfoClass 只能在定义它的函数 listDirectory 内进行调用。

{% highlight python %}
def listDirectory(directory, fileExtList):
    "get list of file info objects for files of particular extensions"
    fileList = [os.path.normcase(f)
                for f in os.listdir(directory)]
    fileList = [os.path.join(directory, f)
               for f in fileList
                if os.path.splitext(f)[1] in fileExtList]
    def getFileInfoClass(filename, module=sys.modules[FileInfo.__module__]):
        "get file info class from filename extension"
        subclass = "%sFileInfo" % os.path.splitext(filename)[1].upper()[1:]
        return hasattr(module, subclass) and getattr(module, subclass) or FileInfo
    return [getFileInfoClass(f)(f) for f in fileList]
{% endhighlight %}

正如任何其它的函数一样，不需要一个接口声明或奇怪的什么东西，只要定义函数，开始编码就行了。(660)

82) `return hasattr(module, subclass) and getattr(module, subclass) or FileInfo` 在生成完处理这个文件的处理类的名字之后，我们查阅在这个模块中是否存在这个处理类。如果存在，我们返回这个类，否则我们返回基类 FileInfo。这一点很重要: _这个函数返回一个类_ 。不是类的实例，而是类本身。(660)

83) `return [getFileInfoClass(f)(f) for f in fileList]` 对每个属于我们 “感兴趣文件” 列表 (fileList)中的文件，我们用文件名 (f) 来调用 getFileInfoClass。调用 getFileInfoClass(f) 返回一个类；我们并不知道确切是哪一个类，但是我们并不关心。接着我们创建这个类 （不管它是什么） 的一个实例，传入文件名 （又是 f） 给的 \__init__ 方法。正如我们在 [本章的前面](http://woodpecker.org.cn/diveintopython/object_oriented_framework/special_class_methods.html#fileinfo.specialmethods.setname) 所看到的，FileInfo 的 __init__ 方法设置了 self["name"]，它将引发 \__setitem__ 的调用，\__setitem__ 在子类 (MP3FileInfo) 中被覆盖掉了，用来适当地对文件进行分析，取出文件的元数据。我们对所有感兴趣的文件进行处理，返回结果实例的一个 list。

请注意 listDirectory 完全是通用的。动态地 [实例化未知类型的类](http://woodpecker.org.cn/diveintopython/file_handling/all_together.html) 通过将类看成对象并传入参数。(660~670)

EOF