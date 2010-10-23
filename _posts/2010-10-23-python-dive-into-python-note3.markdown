---
layout: post
title: '{Python} Dive into Python Note 3'
author: Vayn
date: 2010-10-23
categories:
  - python
---

46) UserDict 是一个象字典一样工作的类，它允许你完全子类化字典数据类型，同时增加你自已的行为。（也存在相似的类 UserList 和 UserString ，它们允许你子类化列表和字符串。）（译注：在 2.2 之后已经可以从 dict, list 来派生子类了）(530)

47) Python 支持多重继承。在类名后面的小括号中，你可以列出许多你想要的类名，以逗号分隔。(530)

48) 每个类方法的第一个参数，包括 \__init__，都是指向类的当前实例的引用。按照习惯这个参数总是被称为 self。在 \__init__ 方法中，self 指向新创建的对象；在其它的类方法中，它指向方法被调用的类实例。尽管当定义方法时你需要明确指定 self，但在调用方法时，你_不_用指定它，Python 会替你自动加上的。(531)

{% highlight python %}
class FileInfo(UserDict):
    "store file metadata"
    def __init__(self, filename=None):
        UserDict.__init__(self)
        self["name"] = filename
{% endhighlight %}

49) 在 Python 中，你必须显示地调用在父类中的适合方法。(531)

50) 当定义你自已的类方法时，你 必须 明确将 self 作为每个方法的第一个参数列出，包括 \__init__。当从你的类中调用一个父类的一个方法时，你必须包括 self 参数。但当你从类的外部调用你的类方法时，你不必对 self 参数指定任何值；你完全将其忽略，而 Python 会自动地替你增加实例的引用。(531)

51) \__init__ 方法是可选的，但是一旦你定义了，就必须记得显示调用父类的 __init__ 方法（如果它定义了的话）。(531)

52) 每一个类的实例有一个内置属性， \__class__，它是对象的类。

53) GC：通常，不需要明确地释放实例，因为当指派给它们的变量超出作用域时，它们会被自动地释放。内存泄漏在 Python 中很少见。这种垃圾收集的方式，术语叫“引用计数”。Python 维护着对每个实例的引用列表。（[gc 模块的文档](http://www.python.org/doc/current/lib/module-gc.html)）(541)

54) [在函数中接收元组和列表](http://woodpecker.org.cn/abyteofpython_cn/chinese/ch15s04.html)：在args变量前有\*前缀，所有多余的函数参数都会作为一个元组存储在args中。如果使用的是\*\*前缀，多余的参数则会被认为是一个字典的键/值对。

55) update 方法是一个字典复制器：它把一个字典中的键和值全部拷贝到另一个字典。 这个操作 _并不_ 事先清空目标字典，如果一些键在目标字典中已经存在，则它们将被覆盖，那些键名在目标字典中不存在的则不改变。应该把 update 看作是合并函数，而不是复制函数。(590)

{% highlight python %}
class UserDict:
    def __init__(self, dict=None):
        self.data = {}
        if dict is not None: self.update(dict)
{% endhighlight %}

56) 应该总是在 __init__ 方法中给一个实例的所有数据属性赋予一个初始值。这样做将会节省你在后面调试的时间，不必为捕捉因使用未初始化（也就是不存在）的属性而导致的 AttributeError 异常费时费力。(550)

57) 真正字典的 copy 方法会返回一个新的字典，它是原始字典的原样的复制（所有的键-值对都相同）。但是 UserDict 不能简单地重定向到 self.data.copy，因为那个方法返回一个真正的字典，而我们想要的是返回同一个类的一个新的实例，就象是 self。

{% highlight python %}
    def clear(self): self.data.clear()
    def copy(self):
        if self.__class__ is UserDict:
            return UserDict(self.data)
        import copy
        return copy.copy(self)
    def keys(self): return self.data.keys()
    def items(self): return self.data.items()
    def values(self): return self.data.values()
{% endhighlight %}

我们使用 __class__ 属性来查看是否 self 是一个 UserDict，如果是，太好了，因为我们知道如何拷贝一个 UserDict：只要创建一个新的 UserDict ，并传给它真正的字典，这个字典已经存放在 self.data 中了。 然后你立即返回这个新的 UserDict，你甚至于不需要再下面一行中使用 import copy。

如果 self.__class__ 不是 UserDict，那么 self 一定是 UserDict 的某个子类（如可能为 FileInfo）。 UserDict 不知道如何生成它的子类的一个原样的拷贝，例如，有可能在子类中定义了其它的数据属性，所以我们只能完全复制它们，确定拷贝了它们的全部内容。幸运的是，Python 带了一个模块可以正确地完成这件事，它叫做 copy。说 copy 能够拷贝任何 Python 对象就够了，这就是为什么我们在这里用它的原因。(550)

58) 专用方法是在特殊情况下或当使用特别语法时由 Python 替你调用的，而不是在代码中直接调用（象普通的方法那样）。它们提供了一种方法，可以将非方法调用语法映射到方法调用上。(560)

{% highlight python %}
def __getitem__(self, key): return self.data[key]
>>> f = fileinfo.FileInfo("/music/_singles/kairo.mp3")
>>> f
{'name':'/music/_singles/kairo.mp3'}
>>> f.__getitem__("name") 
'/music/_singles/kairo.mp3'
>>> f["name"]             
'/music/_singles/kairo.mp3'

def __setitem__(self, key, item): self.data[key] = item
>>> f
{'name':'/music/_singles/kairo.mp3'}
>>> f.__setitem__("genre", 31) # 1
>>> f
{'name':'/music/_singles/kairo.mp3', 'genre':31}
>>> f["genre"] = 32 # 2
>>> f
{'name':'/music/_singles/kairo.mp3', 'genre':32}
{% endhighlight %}

1)) 与 \__getitem__ 方法一样，\__setitem__ 简单地重定向到真正的字典 self.data。并且象 \__getitem__ 一样，通常你不会直接调用它，当你使用了正确的语法，Python 会替你调用 \__setitem__ 。

2)) 这个看上去象正常的字典语法，当然除了 f 实际上是一个类。这行代码实际上暗地里调用了 `f.__setitem__("genre", 32)`。

\__setitem__ 是一个专用类方法，因为它可以让 Python 来替你调用，但是它仍然是一个类方法。就象在 UserDict 中定义 \__setitem__ 方法一样容易，我们可以在子类中重新定义它，对父类的方法进行覆盖。这就允许我们定义出在某些方面象字典一样动作的类，但是可以定义它自已的行为，超过和超出内置的字典。

59) 当在一个类中存取数据属性时，你需要限定属性名：self.attribute。当调用类中的其它方法时，你属要限定方法名：self.method。(561)

60) UserDict 一些其他专用方法。对于类实例，你可以定义 \__cmp__ 方法，自已编写比较逻辑，然后你可以使用 == 来比较你的类，Python 将会替你调用你的 \__cmp__ 专用方法。(570)

61) 在 Python 中，通过使用 str1 is str2 可以决定两个字符串变量是否指向同一块物理内存位置，这叫做 _对象同一性_。在 Python 中比较两个字符串值，你要使用 str1 == str2，这被称作 _对象确定（object identity）_。(570)

62) 在 Python 中，只有类属性（类的变量）是紧跟在类定义之后定义的，数据属性（对象的变量）定义在 __init__ 方法中（[类与对象的方法](http://woodpecker.org.cn/abyteofpython_cn/chinese/ch11s06.html)）。(570)

63) 类属性可以作为类级别的常量来使用（这就是为什么我们在 MP3FileInfo 中使用它们），但是它们不是真正的常量。你也可以修改它们。在 Python 中没有常量。(570)

64) 如果一个 Python 函数，类方法，或属性的名字以两个下划线开始（但不是结束），它是私有的；其它所有的都是公有的。 Python 没有类方法 保护 的概念（只能用于它们自已的类和子类中）。类方法或者是私有（只能在它们自已的类中使用）或者是公有（任何地方都可使用）。(590)

EOF