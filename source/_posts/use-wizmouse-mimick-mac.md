---
title: 使用 WizMouse 让 Windows 支持 macOS 鼠标行为
tag: [Windows,trick,software]
categories: 随笔
---

macOS 的鼠标操作有两个异于 Windows 的行为：

1. 「自然」滚动：就是滚轮向上，页面向下，反之亦然。这个动作是模仿真实环境下将纸张上下搓动。
2. 在非激活窗口使用滚动：鼠标指针焦点在哪个窗口，就能使用滚轮控制此窗口上下滚动。省去来回切换窗口焦点的麻烦。

第1点好坏有赖于个人习惯，不过第2点确实可以节省不少时间。那么如何在 Windows 上也让鼠标采用以上行为？不用调注册表，只需要安装 [WizMouse](http://antibody-software.com/web/software/software/wizmouse-makes-your-mouse-wheel-work-on-the-window-under-the-mouse/) 即可。

运行 WizMouse 后鼠标就自带非激活窗口滚动功能了，如果还需要自然滚动，在 Settings 里将 `Reverse Mouse Scrolling` 勾选上就好了。
