---
layout: post
title: '{Python} Dive into Python Note 8'
author: Vayn
date: 2010-10-28
categories:
  - python
---

139) `urllib.urlopen('http://diveintomark.org/xml/atom.xml').read()` urllib 模块有一个便利的 urlopen 函数，它接受您所要获取的页面地址, 然后返回一个类似文件的对象，您仅仅使用 read() 便可获得页面的全部内容。但这样的做法效率实在是太低了, 并且对服务器来说也太笨了。(1102)

140) 如果你第二次 (或第三次, 或第四次) 请求相同的数据, 你可以告诉服务器你上一次获得的最后修改日期: 在你的请求中发送了一个 If-Modified-Since 头信息, 它包含了上一次从服务器连同数据所获得的日期。 如果数据从那时起没有改变, 服务器将返回一个特殊的 HTTP 状态代码 304, 这意谓着 “从上一次请求后这个数据没有改变”。(1103)

141) ETag 是实现与最近修改数据检查同样的功能的另一种方法: 没有变化时不重新下载数据。当第二次请求相同的数据时, 在 If-None-Match: 头信息中将包含 ETag hash, 如果数据没有改变, 服务器将返回 304 状态代码。 与最近修改数据检查相同, 服务器 _仅仅_ 发送 304 状态代码; 第二次将不为你发送相同的数据。 在第二次请求时, 通过包含 ETag hash, 你会告诉服务器，如果 hash 仍旧匹配就没有必要重新发送相同的数据, 因为你还有上一次访问过的数据。(1103)

142)  在你的请求中包含 Accept-encoding: gzip 头信息, 如果服务器支持压缩, 他将返回由 gzip 压缩的数据并且使用 Content-encoding: gzip 头信息标记。(1103)

143) `import httplib\ httplib.HTTPConnection.debuglevel = 1` __urllib__ 依赖于另一个 Python 的标准库, httplib。 通常你不必显示地给出 import httplib (urllib 会自动导入), 但是你可以为 urllib 使用内部的 HTTPConnection 类设置调试标记来访问 HTTP 服务器。 这是一种令人难以置信的有用技术。(1104)

__Note:__ 但是 Vayn 发现按照 <abbr title="Dive into Python">DIP</abbr> 的示例代码去实作，并不会打印 debug 信息。Google 一番后终于找到原因：

如果想在 urllib2 中让 httplib.HTTPConnection.debuglevel 工作，需要创建你自己的 HTTPHandler，将其 debug 打开，并安装到 urllib2。

先看示例中的无效做法（只对 urllib 有效）：

{% highlight python %}
>>> import urllib2, httplib
>>> httplib.HTTPConnection.debuglevel = 1
{% endhighlight %}

有效做法：

{% highlight python %}
>>> import urllib2
>>> h = urllib2.HTTPHandler(debuglevel=1)
>>> opener = urllib2.build_opener(h)
>>> urllib2.install_opener(opener)
>>> urllib2.urlopen('http://www.google.com').read()
connect: (www.google.com, 80)
send: 'GET / HTTP/1.1\r\nAccept-Encoding: identity\r\nHost: www.google.com\r\nConnection: close\r\nUser-agent: Python-urllib/2.
reply: 'HTTP/1.1 200 OK\r\n'
header: Cache-Control: private
...etc.
{% endhighlight %}

[via](http://mail.python.org/pipermail/tutor/2005-November/043069.html)

144) 使用 urllib2 获取 HTTP 资源包括三个处理步骤。`urllib2.Request('http://diveintomark.org/xml/atom.xml')` 第一步是创建 Request 对象, 它接受一个你最终想要获取资源的 URL。`opener = urllib2.build_opener()` 第二步是创建一个 URL 开启器 (opener)。 这可以使用任何数量的操作者来控制响应的处理。`feeddata = opener.open(request).read()` 最后一个步骤是, 使用你创建的 Request 对象告诉开启器打开 URL。(1105)

145) `request.add_header('User-Agent', 'OpenAnything/1.0 +http://diveintopython.org/')` 使用Request 对象的 add_header 方法, 你能向请求中添加任意的 HTTP 头信息。(1105)

146) `opener.open(request).headers.dict` .headers 是 [一个类似 dictionary 行为的对象](http://woodpecker.org.cn/diveintopython/object_oriented_framework/userdict.html) 并且 允许你获得任何个别的从 HTTP 服务器返回的头信息。(1106)

147) `request.add_header('If-Modified-Since', firstdatastream.headers.get('Last-Modified'))` 在第二次请求时, 你用第一次请求获得的最近修改时间添加了 If-Modified-Since 头信息。 如果数据没被改变, 服务器应该返回一个 304 状态代码。(1107)

148) urllib2 将为 _任何_ 除了状态代码 200 (OK), 301 (permanent redirect), 或 302 (temporary redirect) 之外的状态引发 HTTPError。

149) 自定义 URL 头信息，捕获状态代码并简单返回它, 不抛弃任何异常：

{% highlight python %}
class DefaultErrorHandler(urllib2.HTTPDefaultErrorHandler):
    def http_error_default(self, req, fp, code, msg, headers):
        result = urllib2.HTTPError(
            req.get_full_url(), code, msg, headers, fp)
        result.status = code
        return result
{% endhighlight %}

urllib2 是围绕 URL 头信息而设计的。 每一个头信息就是一个能定义任意数量方法的类。与 [第 9 章 XML 处理](http://woodpecker.org.cn/diveintopython/xml_processing/index.html) 类似的自省为不同节点类型定义了一些处理器，但是 urllib2 是很灵活的，还可以内省为当前请求所定义的所有处理器。

当从服务器遇到一个 304 状态代码, urllib2 查找定义的操作并调用 http_error_default 方法。 通过定义一个自定义的错误处理, 你可以阻止 urllib2 引发异常。 取而代之的是, 你创建 HTTPError 对象, 返回它而不是引发异常。

返回之前, 你保存从 HTTP 服务器返回的状态代码。 这将使你从调用程序轻而易举地访问它。(1106)

150) `opener = urllib2.build_opener(openanything.DefaultErrorHandler())` 这是关键所在: 既然已经定义了你的自定义 URL 头信息, 你需要告诉 urllib2 来使用它。 还记得我怎么说 urllib2 将一个 HTTP 资源的访问过程分解为三个步骤的正当理由吗？ 这便是为什么构建 HTTP 开启器就是它自身的步骤，因为你能用你自定义的 URL 操作覆盖 urllib2 的默认行为来创建它。(1106)

151) 处理 ETag 的工作也非常相像, 不是检查 Last-Modified 并发送 If-Modified-Since, 而是检查 ETag 并发送 If-None-Match。(1106)

152) 没有重定向处理的情况下，访问 web 服务：

{% highlight python %}
>>> import urllib2, httplib
>>> httplib.HTTPConnection.debuglevel = 1
>>> request = urllib2.Request(
...     'http://diveintomark.org/redir/example301.xml')
>>> opener = urllib2.build_opener()
>>> f = opener.open(request)
[...sinpet...]
>>> f.url
'http://diveintomark.org/xml/atom.xml'
>>> f.headers.dict
{'content-length': '15955',
'accept-ranges': 'bytes',
'server': 'Apache/2.0.49 (Debian GNU/Linux)',
'last-modified': 'Thu, 15 Apr 2004 19:45:21 GMT',
'connection': 'close',
'etag': '"e842a-3e53-55d97640"',
'date': 'Thu, 15 Apr 2004 22:06:25 GMT',
'content-type': 'application/atom+xml'}
>>> f.status
Traceback (most recent call last):
  File "<stdin>", line 1, in ?
AttributeError: addinfourl instance has no attribute 'status'
{% endhighlight %}

urllib2 注意到了重定向状态代码并会自动从Location: 头信息中给出的新地址获取数据。但是状态代码不见了, 因此你无从知晓重定向到底是永久重定向还是临时重定向。 这是至关重要的: 如果这是临时重定向, 那么你应该继续使用旧地址访问数据。 但是如果是永久重定向 (正如本例), 你应该从现在起使用新地址访问数据。(1107)

153) urllib2 遇到 301 或 302 时并不做行为, 所以让我们来覆盖这些行为：

{% highlight python %}
class SmartRedirectHandler(urllib2.HTTPRedirectHandler):
    def http_error_301(self, req, fp, code, msg, headers):
        result = urllib2.HTTPRedirectHandler.http_error_301(
            self, req, fp, code, msg, headers)
        result.status = code
        return result

    def http_error_302(self, req, fp, code, msg, headers):
        result = urllib2.HTTPRedirectHandler.http_error_302(
            self, req, fp, code, msg, headers)
        result.status = code
        return result
{% endhighlight %}

重定向行为定义在 urllib2 的一个叫做 HTTPRedirectHandler 的类中。 我们不想完全地覆盖这些行为,只想做点扩展, 所以我们将子类化 HTTPRedirectHandler, 从而我们仍然可以调用祖先类来实现所有原来的功能。

现在你可以构造一个用自定义重定向处理器的 URL 开启器, 并且它依然能自动跟踪重定向, 并且现在也能展示出重定向状态代码。(1107)

154) `opener = urllib2.build_opener(openanything.SmartRedirectHandler())` 用刚刚定义的重定向处理器创建一个 URL 开启器。`f = opener.open(request)` 用 URL 开启器打开 Request 对象，一但收到 `reply: 'HTTP/1.1 301 Moved Permanently\r\n'` 301 状态代码，http_error_301 方法就被调用了。这样就能根据存储的 `result.status` 确定是临时还是永久重定向，从而决定是否更新 URL。(1107)

155) 服务器不会为你发送押送数据，告诉服务器你想获得压缩数据：

{% highlight python %}
>>> import urllib2, httplib
>>> httplib.HTTPConnection.debuglevel = 1 # 注意这样做实际是无效的，原因参见 143 的 Note
>>> request = urllib2.Request('http://diveintomark.org/xml/atom.xml')
>>> request.add_header('Accept-encoding', 'gzip')
>>> opener = urllib2.build_opener()
>>> f = opener.open(request)
connect: (diveintomark.org, 80)
send: '
GET /xml/atom.xml HTTP/1.0
Host: diveintomark.org
User-agent: Python-urllib/2.1
Accept-encoding: gzip
'
reply: 'HTTP/1.1 200 OK\r\n'
header: Date: Thu, 15 Apr 2004 22:24:39 GMT
header: Server: Apache/2.0.49 (Debian GNU/Linux)
header: Last-Modified: Thu, 15 Apr 2004 19:45:21 GMT
header: ETag: "e842a-3e53-55d97640"
header: Accept-Ranges: bytes
header: Vary: Accept-Encoding
header: Content-Encoding: gzip
header: Content-Length: 6289
header: Connection: close
header: Content-Type: application/atom+xml
{% endhighlight %}

`request.add_header('Accept-encoding', 'gzip')` 一旦你已经创建了你的 Request 对象, 就添加一个 Accept-encoding 头信息告诉服务器你能接受 gzip 压缩数据。

`header: Content-Encoding: gzip` 服务器的返回信息: Content-Encoding: gzip 头信息意谓着你要回得的数据已经被 gzip 压缩了。(1108)

156) 解压缩 gzip 数据：

{% highlight python %}
>>> compresseddata = f.read()
>>> len(compresseddata)
6289
>>> import StringIO
>>> compressedstream = StringIO.StringIO(compresseddata)
>>> import gzip
>>> gzipper = gzip.GzipFile(fileobj=compressedstream)
>>> data = gzipper.read()
>>> print data
<?xml version="1.0" encoding="iso-8859-1"?>
<feed version="0.3"
  xmlns="http://purl.org/atom/ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xml:lang="en">
  <title mode="escaped">dive into mark</title>
  <link rel="alternate" type="text/html" href="http://diveintomark.org/"/>
  <-- rest of feed omitted for brevity -->
>>> len(data)
15955
{% endhighlight %}

使用它的 read() 方法将正常地获得非压缩数据, 但这个数据已经被 gzip 压缩过。

Python 有 gzip 模块, 它读取 (并实际写入) 磁盘上的 gzip 压缩文件。 但是磁盘上还没有文件, 只在内存里有一个 gzip 压缩缓冲区, 并且 你不想仅仅为了解压缩而写出一个临时文件。 那么怎么做来创建一个内存数据 (compresseddata) 之外的类似文件的对象呢, 需要使用 StringIO 模块。

创建 GzipFile 的一个实例, 并且告诉它其中的 “file” 是一个类似文件的对象 compressedstream。

`data = gzipper.read()`  gzipper 是一个类似文件的对象，代表一个 gzip 压缩文件。使用它的 read() 方法 “读取” 将会解压缩数据。 尽管这个 “file” 并非一个磁盘上的真实文件; 但 gzipper 还是真正的从你用 StringIO 包装了压缩数据所创建的类似文件的对象中 “读取” 数据, 并确实解压缩了数据。(1108)

157) 抛弃中间件 StringIO 而通过 f 直接访问 GzipFile 是不可以的：

{% highlight python %}
>>> f = opener.open(request)
>>> f.headers.get('Content-Encoding')
'gzip'
>>> data = gzip.GzipFile(fileobj=f).read()
Traceback (most recent call last):
  File "<stdin>", line 1, in ?
  File "c:\python23\lib\gzip.py", line 217, in read
    self._read(readsize)
  File "c:\python23\lib\gzip.py", line 252, in _read
    pos = self.fileobj.tell()   # Save current position
AttributeError: addinfourl instance has no attribute 'tell'
{% endhighlight %}

GzipFile 需要存储其位置并在压缩文件上往返游走。当 “file” 是来自远程服务器的字节流时无法工作; 你能用它做的所有工作就是一次返回一个字节流, 而不是在字节流上往返。 所以使用 StringIO 这种看上去不雅的手段是最好的解决方案: 下载压缩的数据, 除此之外用 StringIO 创建一个类似文件的对象, 并从中解压缩数据。(1108)

158) [全部放在一起](http://woodpecker.org.cn/diveintopython/http_web_services/alltogether.html)：

`if urlparse.urlparse(source)[0] == 'http':` urlparse 是一个解析 URL 的垂手可得的工具模块。 它的主要功能也调用 urlparse, 获得一个 URL 并将其拆分为为一个包含 (scheme, domain, path, params, 查询串参数 和 验证片断) 的 tuple。

`opener = urllib2.build_opener(SmartRedirectHandler(), DefaultErrorHandler())` 使用 _两个_ 自定义 URL 处理器创建一个 URL 开启器: SmartRedirectHandler 为了处理 301 和 302 重定向, 而 DefaultErrorHandler 为了处理 304, 404 以及其它的错误条件。(1109)

EOF