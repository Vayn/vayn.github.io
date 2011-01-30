---
layout: post
title: '{Python} Dive into Python Note 1'
author: Vayn
date: 2010-10-22
categories:
  - python
---

1) Python 既是 _动态类型定义语言_ (因为它不使用显示数据类型声明) , 又是 _强类型定义语言_ (因为一旦一个变量具有一个数据类型, 它实际上就一直是这个类型了) 。(221)

2) 一旦导入了一个模块, 就可以引用它的任何公共的函数、类或属性。模块可以通过这种方法来使用其它模块的功能, 您也可以在 IDE 中这样做。(240)

3) 在 Python 中的 import 就像 Perl 中的 require。一旦 import 一个 Python 模块, 您可以使用 _module.function_ 来访问它的函数；一旦您 require 一个 Perl 模块, 您可以使用 _module::function_ 来访问它的函数。

实际上真实情况要比这更复杂, 因为不是所有的模块都保存为 .py 文件。有一些, 像 sys 模块, 是"内置模块", 它们实际上是置于 Python 内部的。内置模块的行为如同一般的模块, 但是它们的 Python 源代码是不可用的, 因为它们不是用 Python 写的！ ( sys 模块是用 C 写的。)(240)

4) 在 Python 中 _万物皆对象_ 。字符串是对象。列表是对象。函数是对象。甚至模块也是对象。(242)

5) 与 C 一样, Python 使用 == 做比较, 使用 = 做赋值。 与 C 不一样, Python 不支持行内赋值, 所以不会出现想要进行比较却意外地出现赋值的情况。(260)

6) 模块是对象, 并且所有的模块都有一个内置属性 `__name__`。一个模块的 `__name__` 的值要看您如何应用模块。如果 import 模块, 那么 `__name__` 的值通常为模块的文件名, 不带路径或者文件扩展名。但是您也可以像一个标准的程序一样直接运行模块, 在这种情况下 `__name__` 的值将是一个特别的缺省值, `__main__`。您可以在模块内部为您的模块设计一个测试套件, 在其中加入这个 if 语句。(260)

7) Dictionary: 您可以通过 key 来引用其值, 但是不能通过值获取 key。key 是大小写敏感的。clear 从一个 dictionary 中清除所有元素。[如何通过 key 对 dictionary 的值进行排序](http://www.activestate.com/ASPN/Python/Cookbook/Recipe/52306)。[所有 dictionary 方法](http://www.python.org/doc/current/lib/typesmapping.html) (311)

8) `li[:]` 是生成一个 list 完全拷贝的一个简写。Python 中只能这样拷贝 list。append 向 list 的末尾追加单个元素（可以是另一个 list）。insert 将单个元素插入到 list 中。数值参数是插入点的索引。extend 用来连接 list（使其合成一个），请注意不要使用多个参数来调用 extend, 要使用一个 list 参数进行调用。(322)

9) index 在 list 中查找一个值的 _首次_ 出现。如果在 list 中没有找到值, Python 会引发一个异常。要测试一个值是否在 list 内, 使用 in, 如果值存在, 它返回 True, 否则返为 False 。(323)

10) remove _仅仅_ 删除一个值的首次出现。如果在 list 中没有找到值, Python 会引发一个异常来响应 index 方法。pop 会做两件事: 删除 list 的最后一个元素, 然后返回删除元素的值。(324)

11) Lists 也可以用 + 运算符连接起来。list = list + otherlist 相当于 list.extend(otherlist)。 但 + 运算符把一个新 (连接后) 的 list 作为值返回, 而 extend 只修改存在的 list。 也就是说, 对于大型 list 来说, extend 的执行速度要快一些。(325)

12) Python 支持 `+=` 运算符。`*` 运算符可以作为一个重复器作用于 list。 li = [1, 2] * 3 等同于 li = `[1, 2]` + `[1, 2]` + `[1, 2]`, 即将三个 list 连接成一个。[把 list 作为堆栈和队列使用](http://www.python.org/doc/current/tut/node7.html#SECTION007110000000000000000) 。[所有的 list 方法](http://www.python.org/doc/current/lib/typesseq-mutable.html) 。(325)

13) Tuple 是不可变 list。 一旦创建了一个 tuple 就不能以任何方式改变它。与 list 一样分片 (slice) 也可以使用。注意当分割一个 list 时, 会得到一个新的 list ；当分割一个 tuple 时, 会得到一个新的 tuple。Tuple 没有方法。Tuples 可以在 dictionary 中被用做 key, 但是 list 不行。Tuple 本身是不可改变的, 但是如果您有一个 list 的 tuple, 那就认为是可变的了, 用做 dictionary key 就是不安全的。只有字符串, 整数或其它对 dictionary 安全的 tuple 才可以用作 dictionary key。Tuple 本身是不可改变的, 但是如果您有一个 list 的 tuple, 那就认为是可变的了, 用做 dictionary key 就是不安全的。只有字符串, 整数或其它对 dictionary 安全的 tuple 才可以用作 dictionary key。(330)

14) 只有一个元素的 tuple：(foo,)

15) Python 不允许您引用一个未被赋值的变量, 试图这样做会引发一个异常。(340)

16) Python 中比较 “酷” 的一种编程简写是使用序列来一次给多个变量赋值。[一次赋多值](http://woodpecker.org.cn/diveintopython/native_data_types/declaring_variables.html#odbchelper.multiassign.1.1)。[连续值赋值](http://woodpecker.org.cn/diveintopython/native_data_types/declaring_variables.html#odbchelper.multiassign.2.1)。(342)

17) 试图将一个字符串同一个非字符串连接会引发一个异常。使用包含 ".2" 精度修正符的 %f 格式符选项将只打印 2 位小数。使用包含 ".2" 精度修正符的 %f 格式符选项将只打印 2 位小数。[所有字符串格式化所使用的格式符](http://docs.python.org/library/stdtypes.html#typesseq-strings)。(350)

18) 序列的 keys, values 和 items 函数。(360)

19) join 只能用于元素是字符串的 list; 它不进行任何的类型强制转换。连接一个存在一个或多个非字符串元素的 list 将引发一个异常。split 与 join 正好相反, 它将一个字符串分割成多元素 list。split 接受一个可选的第二个参数, 它是要分割的次数。[为什么 join 是字符串方法 而不是 list 方法](http://www.python.org/doc/faq/?query=4.96&querytype=simple&casefold=yes&req=search)。(370)

EOF