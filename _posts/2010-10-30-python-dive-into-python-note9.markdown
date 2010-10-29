---
layout: post
title: '{Python} Dive into Python Note 9'
author: Vayn
date: 2010-10-30
categories:
  - python
---

159) 这是 Dive Into Python 笔记的最后一篇，与其说是笔记倒不如说是摘抄，但对于精读一本书来说也不失为一个不错的办法。DIP 对于有编程经验的人来说是一门不错的指导书籍，但它实在太旧了，最近一次更新还是在 2006 年 4 月！对于 Python 这么一门飞速发展的语言来说基本等于古代。

这本书针对的 Python 版本是 2.3，而现在主流版本是 2.5（App Engine 采用的版本）和 2.7 版。纵然 DIP 是一本好书，但啄木鸟社区把它放在首页上明显是不合适的。好吧，虽然语言的版本在变，但大部分基础的东西一般不会变化，读 DIP 也不会有什么损失。

基于以上原因，我打算在读完“单元测试”这章后（没错，我跳过了 SOAP），把剩下的三章大概扫一遍。就这样吧。

160) 为还未开发的程序开发测试代码。这就是所谓的单元测试，因为这两个转换函数可以被当作一个单元来开发和测试，不用考虑它们可能今后成为一个大程序的一部分。 Python 有一个单元测试框架，被恰如其分地称作 unittest 模块。(1302)

161) 单元测试应该是自动的。可以自己判断被测试函数是通过还是失败，不需要人工干预结果。每个测试用例是一个孤岛。(1304)

162) `class KnownValues(unittest.TestCase):` 编写测试用例首先需要写一个类来继承 unittest 模块中的 TestCase 类，TestCase 类提供了很多可以用在你的测试用例中来测试特定情况的有用方法。(1304)

163) 单元测试的关键不在于所有可能的输入，而是一个有代表性的样本。(1304)

164) 每个独立测试都是其自己的方法，既不需要参数也不返回任何值。

{% highlight python %}
def testToRomanKnownValues(self):
        """toRoman should give known result with known input"""
        for integer, numeral in self.knownValues:
            result = roman.toRoman(integer)
            self.assertEqual(numeral, result)
{% endhighlight %}

如果该方法正常退出没有引发异常，测试被认为通过；如果测试引发异常，测试被认为失败。(1304)

165) `result = roman.toRoman(integer)` 这里你真正调用了 toRoman 函数。（当然，函数还没有编写，但一旦被编写，这里便是调用之处） 注意你在这里为 toRoman 函数定义了 API ：它必须接受整数（待转换的数）并返回一个字符串（对应的罗马数字表示）， 如果 API 不是这样，测试将失败。同样值得注意，你在调用 toRoman 时没有试图捕捉任何可能发生的异常。有效输入调用 toRoman 不会引发任何异常，因此这些输入都是有效的。如果 toRoman 引发了异常，则测试被认为失败（输入是无效的）。(1304)

166) `self.assertEqual(numeral, result)` TestCase 类提供了一个方法： assertEqual 来测试两个值是否相等。如果 toRoman 返回的结果 (value) 不等于我们预期的值 (numeral)， assertEqual 将会引发一个异常，测试也就此失败。如果两个值相等，assertEqual 什么也不做。预期值 assertEqual 不会引发异常，testToRomanKnownValues 会最终正常退出，这意味着 toRoman 通过了该测试。(1304)

167) 使用有效输入确保函数成功通过测试还不够，你还需要测试无效输入导致函数失败的情形。但并不是任何失败都可以，必须如你预期地失败。(1305)

168) unittest 模块提供了用于测试函数是否在给定无效输入时引发特定异常的方法：

{% highlight python %}
class ToRomanBadInput(unittest.TestCase):
    def testTooLarge(self):
        """toRoman should fail with large input"""
        self.assertRaises(roman.OutOfRangeError, roman.toRoman, 4000)
{% endhighlight %}

unittest 模块中的 TestCase 类提供了 assertRaises 方法，它接受这几个参数：预期的异常，测试的函数以及传递给函数的参数 （如果被测试函数有不止一个参数，把它们按顺序全部传递给 assertRaises ，它会把这些参数传给被测的函数。）特别注意这里的操作：不是直接调用 toRoman 再手工查看是否引发特定异常 （使用 [try...except block](http://woodpecker.org.cn/diveintopython/file_handling/index.html#fileinfo.exception) 捕捉异常）， assertRaises 为我们封装了这些。 所有你要做的就是把异常（roman.OutOfRangeError），函数（toRoman）以及 toRoman 的参数（4000）传递给 assertRaises ，它会调用 toRoman 查看是否引发 roman.OutOfRangeError 异常。(1305)

169) `def testSanity(self):` 你经常会发现一组代码中包含互逆函数，它们通常是转换函数，一个把 A 转换为 B ，另一个把 B 转换为 A。 在这种情况下，创建“完备性检测（Testing for sanity）”可以使你在由 A 转 B 再转 A 的过程中不会出现丢失精度和取整等错误。(1306)

170) `numeral = roman.toRoman(integer)` 这里的 integer 并不是一个 Python 关键字，而只是没有什么特别的变量名。(1306)

171) 如果你需要分析方能找出问题所在，无疑你的测试用例在设计上出了问题。(1306)

172)  “除了诱惑什么我都能抗拒（I can resist everything except temptation.）” --Oscar Wilde (1306)

173) 定义你自己的 Python 异常。异常也是类，通过继承已有的异常，你可以创建自定义的异常。 强烈建议（但不是必须）你继承 Exception 来定义自己的异常，因为它是所有内建异常的基类。 这里我定义了 RomanError （从 Exception 继承而来）作为我所有自定义异常的基类。 这是一个风格问题，我也可以直接从 Exception 继承建立每一个自定义异常：

{% highlight python %}
class RomanError(Exception): pass
class OutOfRangeError(RomanError): pass
class NotIntegerError(RomanError): pass
class InvalidRomanNumeralError(RomanError): pass

def toRoman(n):
    """convert integer to Roman numeral"""
    pass

def fromRoman(s):
    """convert Roman numeral to integer"""
    pass
{% endhighlight %}

你只是想定义每个函数的 API ，而不想具体实现它们，因此你以 Python 关键字 [pass](http://woodpecker.org.cn/diveintopython/object_oriented_framework/defining_classes.html#fileinfo.class.simplest) 姑且带过。(1401)

174) 目前而言，每一个测试用例都应该失败。 事实上，任何测试用例在此时通过，你都应该回头看看 romantest.py ，仔细想想为什么你写的测试代码如此没用，以至于连什么都不作的函数都能通过测试。(1401)

175) ` if not (0 < n < 4000)` 等价于 `if not ((0 < n) and (n < 4000))` 但更容易让人理解。非常 Pythonic 的写法。(1403)

176) `raise OutOfRangeError, "number out of range (must be 1..3999)"` 你使用 raise 语句引发自己的异常。 你可以引发任何内建异常或者已定义的自定义异常。第二个参数是可选的，如果给定，则在异常未被处理时显示于追踪信息（trackback）之中。(1403)

177) 当一个函数的所有单元测试都通过了，停止编写这个函数。一旦一个完整模块的单元测试通过了，停止编写这个模块。(1403)

178) 如果测试用例没能正确通过，你需要思量这个修改错了还是测试用例本身出现了 Bug。无论如何，从长远上讲，这样在测试代码和代码之间的反复是值得的，因为这样会使 Bug 在第一时间就被修正的可能性大大提高。 而且，由于任何新的更改后你都可以轻易地重新运行 所有 测试用例，新代码破坏老代码的机会也变得微乎其微。 今天的单元测试就是明天的回归测试（regression test）。(1501)

179) 全面的单元测试带来的最大好处不是你的全部测试用例最终通过时的成就感；也不是被责怪破坏了别人的代码时能够证明自己的自信。最大的好处是单元测试给了你自由去无情地重构。重构是在可运行代码的基础上使之更良好工作的过程。这里， “更好” 意味着 “更快”。(1503)

180) 通过预编译正则表达式使函数提速：

{% highlight python %}
>>> import re
>>> pattern = '^M?M?M?$'
>>> re.search(pattern, 'M')
<SRE_Match object at 01090490>
>>> compiledPattern = re.compile(pattern)
>>> compiledPattern
<SRE_Pattern object at 00F06E28>
>>> dir(compiledPattern)
['findall', 'match', 'scanner', 'search', 'split', 'sub', 'subn']
>>> compiledPattern.search('M')
<SRE_Match object at 01104928>
{% endhighlight %}

`dir(compiledPattern)` re.compile 返回已编译的 pattern 对象有几个值得关注的功能：包括了几个 re 模块直接提供的功能（比如： search 和 sub）。用已编译的 pattern 对象的 search 函数与用正则表达式和字符串 'M' 调用 re.search 可以得到相同的结果，只是快了很多（事实上，re.search 函数仅仅将正则表达式编译，然后为你调用编译后的 pattern 对象的 search 方法。）。在需要多次使用同一个正则表达式的情况下，应该将它进行编译以获得一个 pattern 对象，然后直接调用这个 pattern 对象的方法。(1503)

181) 正则表达式越晦涩难懂越快，我可不想在六个月内再回头试图维护它。是呀！测试用例通过了，我便知道它工作正常，但如果我搞不懂它是 _如何_ 工作的，添加新功能，修正新 Bug，或者维护它都将变得很困难。 正如你在 [第 7.5 节 “松散正则表达式”](http://woodpecker.org.cn/diveintopython/regular_expressions/verbose.html), 看到的， Python 提供了逐行注释你的逻辑的方法。(1503)

182) 最后发现这个程序中最令人头痛（性能负担）的是正则表达式，它是必需的，因为没有其它方法来处理罗马数字。但是，它们只有 5000 个，为什么不一次性地构建一个查询表来读取？ 不必用正则表达式凸现了这个主意的好处。 你建立了整数到罗马数字查询表的时候，罗马数字到整数的逆向查询表也构建了。

{% highlight python %}
#Define exceptions
class RomanError(Exception): pass
class OutOfRangeError(RomanError): pass
class NotIntegerError(RomanError): pass
class InvalidRomanNumeralError(RomanError): pass

#Roman numerals must be less than 5000
MAX_ROMAN_NUMERAL = 4999

#Define digit mapping
romanNumeralMap = (('M',  1000),
                   ('CM', 900),
                   ('D',  500),
                   ('CD', 400),
                   ('C',  100),
                   ('XC', 90),
                   ('L',  50),
                   ('XL', 40),
                   ('X',  10),
                   ('IX', 9),
                   ('V',  5),
                   ('IV', 4),
                   ('I',  1))

#Create tables for fast conversion of roman numerals.
#See fillLookupTables() below.
toRomanTable = [ None ]  # Skip an index since Roman numerals have no zero
fromRomanTable = {}

def toRoman(n):
    """convert integer to Roman numeral"""
    if not (0 < n <= MAX_ROMAN_NUMERAL):
        raise OutOfRangeError, "number out of range (must be 1..%s)" % MAX_ROMAN_NUMERAL
    if int(n) <> n:
        raise NotIntegerError, "non-integers can not be converted"
    return toRomanTable[n]

def fromRoman(s):
    """convert Roman numeral to integer"""
    if not s:
        raise InvalidRomanNumeralError, "Input can not be blank"
    if not fromRomanTable.has_key(s):
        raise InvalidRomanNumeralError, "Invalid Roman numeral: %s" % s
    return fromRomanTable[s]

def toRomanDynamic(n):
    """convert integer to Roman numeral using dynamic programming"""
    result = ""
    for numeral, integer in romanNumeralMap:
        if n >= integer:
            result = numeral
            n -= integer
            break
    if n > 0:
        result += toRomanTable[n]
    return result

def fillLookupTables():
    """compute all the possible roman numerals"""
    #Save the values in two global tables to convert to and from integers.
    for integer in range(1, MAX_ROMAN_NUMERAL + 1):
        romanNumber = toRomanDynamic(integer)
        toRomanTable.append(romanNumber)
        fromRomanTable[romanNumber] = integer

fillLookupTables()
{% endhighlight %}

原有版本的最快速度是 13 个测试耗时 3.315 秒，现在只需要 0.791 秒。当然，这样的比较不完全公平，因为这个新版本需要更长的时间来导入 （当它填充查询表时）。 但是导入只需一次，在运行过程中可以忽略。(1504)

183) 简洁是美德。特别是使用正则表达式时。单元测试给了你大规模重构的信心...... 既便没写出原有的代码也是这样。(1505)

184) 好了，Dive Into Python 这本书我就算囫囵个看完了，剩下的三章除了“[使用 timeit 模块](http://woodpecker.org.cn/diveintopython/performance_tuning/timeit.html)”这部分我还想了解，其他部分对我来说现在了解实在太早。

接下来我会阅读 The Python Tutorial 的最新版，一是巩固现有知识，二是了解一下 2.7 版的 Python。

EOF