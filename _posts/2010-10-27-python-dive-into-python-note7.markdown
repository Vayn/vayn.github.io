---
layout: post
title: '{Python} Dive into Python Note 7'
author: Vayn
date: 2010-10-27
categories:
  - python
---

117) Python 的最强大力量之一是它的动态绑定，并且动态绑定最强大的用法之一是 _类文件(file-like)对象_ 。

许多需要输入源的函数可以只接收一个文件名，并以读方式打开文件，读取文件，处理完成后关闭它。其实它们不是这样的，而是接收一个 _类文件对象_ 。

你不用把自己局限于真实的文件。输入源可以是任何东西：磁盘上的文件，甚至是一个硬编码的字符串。只要你将一个类文件对象传递给函数，函数只是调用对象的 read 方法，函数可以处理任何类型的输入源，而不需要处理每种类型的特定代码。(1001)

118) 解析字符串 XML (容易但不灵活的方式)：

{% highlight python %}
>>> contents = "<grammar><ref id='bit'><p>0</p><p>1</p></ref></grammar>"
>>> xmldoc = minidom.parseString(contents)
>>> print xmldoc.toxml()
<?xml version="1.0" ?>
<grammar><ref id="bit"><p>0</p><p>1</p></ref></grammar>
{% endhighlight %}

minidom 有一个方法，parseString，它接收一个字符串形式的完整 XML 文档作为参数并解析这个参数。如果你已经将整个 XML 文档放入一个字符串，你可以使用它代替minidom.parse。(1001)

119) 有一个方法可以把字符串转换成类文件对象，这个模块专门设计用来做这件事：StringIO。

{% highlight python %}
>>> contents = "<grammar><ref id='bit'><p>0</p><p>1</p></ref></grammar>"
>>> import StringIO
>>> ssock = StringIO.StringIO(contents)
>>> ssock.read()
"<grammar><ref id='bit'><p>0</p><p>1</p></ref></grammar>"
>>> ssock.read()
''
>>> ssock.seek(0)
>>> ssock.read(15)
'<grammar><ref i'
>>> ssock.read(15)
"d='bit'><p>0</p"
>>> ssock.read()
'><p>1</p></ref></grammar>'
>>> ssock.close()
{% endhighlight %}

StringIO 模块只包含了单个类，也叫 StringIO，它允许你将一个字符串转换为一个类文件对象。这个 StringIO 类在创建实例的时候接收字符串作为参数。

调用 read 返回空字符串。一旦你读取了整个文件，如果不显式定位到文件的开始位置，就不可能读取到任何其他数据。StringIO 对象以相同的方式进行工作。使用 StringIO 对象的 seek 方法，你可以显式的定位到字符串的开始位置，就像在文件中定位一样。(1001)

120) openAnything：

{% highlight python %}
def openAnything(source):
    # try to open with urllib (if source is http, ftp, or file URL)
    import urllib
    try:
        return urllib.urlopen(source)
    except (IOError, OSError):
        pass

    # try to open with native open function (if source is pathname)
    try:
        return open(source)
    except (IOError, OSError):
        pass

    # treat source as string
    import StringIO
    return StringIO.StringIO(str(source))
{% endhighlight %}

到StringIO，你需要假设source是一个其中有硬编码数据的字符串（因为没有什么可以判断的了），所以你可以使用 StringIO 从中创建一个类文件对象并将它返回。（实际上，由于使用了 str 函数，所以source没有必要一定是字符串；它可以是任何对象，你可以使用它的字符串表示形式，通过它的 \__str__ 定义的[特殊方法](http://woodpecker.org.cn/diveintopython/object_oriented_framework/special_class_methods2.html)。）(1001)

121) 标准输入和标准错误（通常缩写为 stdout 和 stderr）是內建在每一个 UNIX 系统中的管道，通常这两个管道只与你正在工作的终端窗口相联，所以当一个程序打印时，你可以看到输出，而当一个程序崩溃时，你可以看到调式信息。(1002)

122) `sys.stdout.write('Dive in')` stdout 是一个类文件对象；调用它的 write 函数可以打印出你给定的任何字符串。实际上，这就是 print 函数真正做的事情；它在你打印的字符串后面加上一个硬回车，然后调用sys.stdout.write函数。(1002)

123) stdout 和 stderr 都是类文件对象，但是它们都是只写的。它们都没有 read 方法，只有 write 方法。(1002)

124) 重定向输出：

{% highlight python %}
#stdout.py
import sys

print 'Dive in'
saveout = sys.stdout
fsock = open('out.log', 'w')
sys.stdout = fsock
print 'This message will be logged instead of displayed'
sys.stdout = saveout
fsock.close()
{% endhighlight %}

`saveout = sys.stdout` 始终在重定向前保存 stdout ，这样的话之后你还可以将其设回正常。

`sys.stdout = fsock` 将所有后续的输出重定向到刚才打开的新文件上。

`sys.stdout = saveout` 在我们将 stdout 搞乱之前，让我们把它设回原来的方式。(1002)

125) `print >> sys.stderr, 'entering function'` print 语句的快捷语法可以用于向任何打开的文件写入，或者是类文件对象。在这种情况下，你可以将单个print 语句重定向到stderr 而且不用影响后面的print 语句。(1002)

126) `cat binary.xml | python kgp.py -g -` 为了不用指定一个模块(例如binary.xml)，你需要指定“-”，它会使得你的脚本从标准输入载入脚本而不是从磁盘上的特定文件。想想这里的扩展性。代替cat binary.xml，你可以通过运行一个脚本动态生成语法，然后你可以通过管道将它导入你的脚本。(1002)

127) 在kgp.py中从标准输入读取：

{% highlight python %}
def openAnything(source):
    if source == "-":
        import sys
        return sys.stdin

    # try to open with urllib (if source is http, ftp, or file URL)
    import urllib
    try:

[... snip ...]
{% endhighlight %}

函数的开始加入3行代码来检测源是否是“-”; 如果是，返回sys.stdin。实际上，that's it! 记住，stdin 是一个拥有read方法的类文件对象，所以剩下的代码（在kgp.py中，在那里你调用了openAnything) 一点都不需要改动。(1002)

128) 如何构建 kant 语法：为最小的片段定义 ref 元素，然后通过 xref 定义“包含”第一个 ref 元素的 ref 元素，等等。然后，解析“最大的”引用并跟在每个 xref 后面，最后输出真实的文本。输出的文本依赖于你每次填充 xref 所做的（随机）决策，所以每次的输出都是不同的。

这种方式非常灵活，但是有一个不好的地方：性能。当你找到一个 xref 并需要找到相应的 ref 元素时，会遇到一个问题。 xref 有 id 属性，而你要找拥有相同 id 属性的 ref 元素，但是没有简单的方式做到这件事。较慢的方式是每次获取所有 ref 元素的完整列表，然后手动遍历并检视每一个 id 属性。较快的方式是只做一次然后以字典形式构建一个缓冲。

{% highlight python %}
def loadGrammar(self, grammar):
    self.grammar = self._load(grammar)
    self.refs = {}
    for ref in self.grammar.getElementsByTagName("ref"):
        self.refs[ref.attributes["id"].value] = ref
{% endhighlight %}

self.refs 字典的值将是 ref 元素本身。如你在[第 9.3 节 “XML 解析”](http://woodpecker.org.cn/diveintopython/xml_processing/parsing_xml.html)中看到的，已解析 XML 文档中的每个元素，每个节点，每个注释，每个文本片段都是一个对象。(1003)

129) 一旦你构建了这个缓冲，无论何时你遇到一个 xref 并且需要找到具有相同 id 属性的 ref 元素，你只要在 self.refs 中查找它：

{% highlight python %}
def do_xref(self, node):
    id = node.attributes["id"].value
    self.parse(self.randomChildElement(self.refs[id]))
{% endhighlight %}

(1003)

130) 查找节点的直接子节点。你可能认为你只要简单的使用 getElementsByTagName 来实现这点就可以了，但是你不可以这么做。 getElementsByTagName 递归搜索并返回所有找到的元素的单个列表。由于 p 元素可以包含其他的 p 元素，你不能使用 getElementsByTagName ，因为它会返回你不要的嵌套 p 元素。为了只找到直接子元素，你要自己进行处理。

{% highlight python %}
def randomChildElement(self, node):
    choices = [e for e in node.childNodes if e.nodeType == e.ELEMENT_NODE]
    chosen = random.choice(choices)
    return chosen
{% endhighlight %}

childNodes 返回的列表包含了所有不同类型的节点，包括文本节点。这并不是你在这里要查找的。你只要元素形式的孩子。

每个节点都有一个nodeType属性，它可以是元素节点, 文本节点, 注释节点，或者任意数量的其它值。可能值的完整列表在xml.dom包的\__init__.py文件中。你只是对元素节点有兴趣，所以你可以过滤出一个列表，其中只包含nodeType是元素节点的节点。

Python 有一个叫 random 的模块，它包含了好几个有用的函数。random.choice函数接收一个任意数量条目的列表并随机返回其中的一个条目。(1004)

131) parse, 一个通用的 XML 节点分发器：

{% highlight python %}
def parse(self, node):
    parseMethod = getattr(self, "parse_%s" % node.__class__.__name__)
    parseMethod(node)
{% endhighlight %}

基于传入节点（在node参数中）的类名构造一个较大的字符串。如果你传入一个Document节点，你就构造了字符串'parse_Document'，其它类同于此。把这个字符串当作一个函数名称，然后通过 getattr 得到函数自身的引用。调用函数并将节点自身作为参数传入。(1005)

132) parse分发者调用的函数：

{% highlight python %}
def parse_Document(self, node):
    self.parse(node.documentElement)

def parse_Text(self, node):
    text = node.data
    if self.capitalizeNextWord:
        self.pieces.append(text[0].upper())
        self.pieces.append(text[1:])
        self.capitalizeNextWord = 0
    else:
        self.pieces.append(text)

def parse_Comment(self, node):
    pass

def parse_Element(self, node):
    handlerMethod = getattr(self, "do_%s" % node.tagName)
    handlerMethod(node
{% endhighlight %}

parse_Document只会被调用一次，因为在一个 XML 文档中只有一个Document节点，并且在已解析 XML 的表示中只有一个Document对象。它只是turn around并解析语法文件的根元素。

parse_Text 在节点表示文本时被调用。这个函数本身做某种特殊处理，自动将句子的第一个单词进行大写处理，而不是简单的将表示的文本追加到一个列表中。

parse_Comment 只有一个pass，因为你并不关心语法文件中嵌入的注释。但是注意，你还是要定义这个函数并显式的让它不做任何事情。如果这个函数不存在，通用parse函数在遇到一个注释的时候，会执行失败。

parse_Element方法其实本身就是一个分发器，它基于元素的标记名称。

如果你进行的处理过程很复杂（或者你有很多不同的标记名称），你可以将代码分散到独立的模块中，然后使用动态导入的方式导入每个模块并调用你需要的任何函数。(1005)

133) 关于sys.argv需要了解的第一件事情是它包含了你正在调用的脚本的名称。(1006)

134) 命令行参数通过空格进行分隔，在sys.argv类表中，每个参数都是一个独立的元素。对于只是接收单个参数或者没有标记的简单程序，你可以简单的使用sys.argv\[1]来访问参数。这没有什么羞耻的；我一直都是这样做的。对更复杂的程序，你需要 getopt 模块。(1006)

135) getopt 模块介绍：

{% highlight python %}
def main(argv):
    grammar = "kant.xml"
    try:
        opts, args = getopt.getopt(argv, "hg:d", ["help", "grammar="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

...

if __name__ == "__main__":
    main(sys.argv[1:])
{% endhighlight %}

`main(sys.argv[1:])` 注意你正在调用main函数，参数是sys.argv\[1:]。记住，sys.argv\[0]是你正在运行脚本的名称；对命令行而言，你不用关心它，所以你可以砍掉它并传入列表的剩余部分。

`opts, args = getopt.getopt(argv, "hg:d", ["help", "grammar="])` getopt 模块的 getopt 函数接收三个参数：参数列表（你从sys.argv\[1:]得到的），一个包含了程序所有可能接收到的单字符命令行标志，和一个等价于单字符的长命令行标志的列表。

在解析这些命令行标志时，如果有任何事情错了，getopt 会抛出异常，你可以捕获它。你可以告诉 getopt 你明白的所有标志，那么这也意味着终端用户可以传入一些你不理解的命令行标志。(1006)

136) "hg:d"：

{% highlight python %}
-h
print usage summary
-g ...
use specified grammar file or URL
-d
show debugging information while parsing
{% endhighlight %}

第一个标志和第三个标志是简单的独立标志；你选择是否指定它们，它们做某些事情（打印帮助）或者改变状态（关闭调试）。

第二个标志（-g）必须跟随一个参数，进行读取的语法文件的名称。它可以是一个文件名或者一个web地址，你可能还不知道，但是你要知道必须要 _有些东西_ 。你可以通过在 getopt 函数的第二个参数的g后面放一个冒号（g:），来向 getopt 说明这一点。

这个脚本接收短标志（像-h）或者长标记（像--help），并且你要它们做相同的事。这就是 getopt 第三个参数存在的原因，为了指定长标志的一个列表，其中的长标志是和第二个参数中指定的短标志相对应的。(1006)

137) \["help", "grammar="]：

{% highlight python %}
["help", "grammar="]
--help
print usage summary
--grammar ...
use specified grammar file or URL
{% endhighlight %}

所有命令行中的长标志以两个短划线开始，但是在调用 getopt 时，你不用包含这两个短划线。它们是能够被理解的。

\-\-grammar标志的后面必须跟着另一个参数，就像-g标志一样。通过等于号标识出来 "grammar="。

长标志列表比短标志列表更短一些，因为-d标志没有相应的长标志。这也好；只有-d才会打开调试。但是短标志和长标志的顺序必须是相同的，你应该先指定有长标志的短标志，然后才是剩下的短标志。(1006)

138) 在 kgp.py 中处理命令行参数：

{% highlight python %}
def main(argv):
    grammar = "kant.xml"
    try:
        opts, args = getopt.getopt(argv, "hg:d", ["help", "grammar="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt == '-d':
            global _debug
            _debug = 1
        elif opt in ("-g", "--grammar"):
            grammar = arg

    source = "".join(args)

    k = KantGenerator(grammar, source)
    print k.output()
{% endhighlight %}

grammar变量会跟踪你正在使用的语法文件。如果你没有在命令行指定它（使用-g或者--grammar标志定义它），在这里你将初始化它。

你从 getopt 取回的 opts 变量包含了元组（flag 和 argument）的一个列表。

`if opt in ("-h", "--help"):` 如果你指定-h标志，opt将会包含"-h"；如果你指定--help标志，opt将会包含"--help"标志。所以你需要检查它们两个。

-d标记没有相应的长标志，所以你只需要检查短形式。如果你找到了它，你就可以设置一个全局变量来指示后面要打印出调试信息。

`elif opt in ("-g", "--grammar"): grammar = arg` 如果你找到了一个语法文件，-g标志或者--grammar标志带着的，那你要保存跟在它（保存在arg）后面的参数到变量grammar中，覆盖掉在main函数你初始化的默认值。

That’s it。你已经遍历并处理了所有的命令行标志(opt)。这意味着所有剩下的东西都必须是命令行参数(args)。这些从 getopt 函数的 args 变量回来。如果没有指定命令行参数，args 将是一个空列表，并且 source 将以空字符串结束。

[全部放在一起](http://woodpecker.org.cn/diveintopython/scripts_and_streams/all_together.html)。(1006)

EOF