---
layout: post
title: '{Ubuntu} 在 ubuntu 10.04 使用左手指针'
author: Vayn
date: 2010-05-01T22:25:00+0000
categories: 
  - cursor
  - linux
  - trick
  - ubuntu

---

<p>1、在 GNOME-Look.org 下载 <a href="http://gnome-look.org/content/show.php/Aero+Mouse+Cursors+with+Drop+Shadow?content=67833">Aero Mouse Cursors with Drop Shadow</a> 这套指针中的左手指针。你也可以下载别的主题，我喜欢 Aero 指针。</p>
<p>2、将压缩包解开，复制到 /usr/share/icons 中。</p>
<p>3、打开 /usr/share/icons/default/index.theme 文件，修改&nbsp;Inherits=XXX 这一行， 把 XXX 改成刚才复制到目录的文件夹名字，如 Inherits=aero-left。</p>
<p>在 ubuntu 9.10 的时候我的做法是打开外观，直接把主题压缩包拖进去，但在 10.04 此方法失效了 Orz。</p>
<p>4、重启 X。</p>
<p>注意，在 GDM（登录介面）还是老样子，登录后就好了。<br />
也许 <span class="Apple-style-span" style="color: #46494d; font-family: monaco, 'bitstream vera sans mono', 'courier new', courier, monospace; font-size: 14px; white-space: pre;">xsetroot -cursor_name right_ptr</span> 可以解决？一会儿试试。</p>
<p>EOF</p>
