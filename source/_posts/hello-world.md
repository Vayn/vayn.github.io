---
title: 使用 Karabiner Elements 修改 macOS Sierra 键位
tag: [macOS,trick]
---

macOS 来到 Sierra (10.12) 后，Karabiner 已然失效。幸好 Karabiner 的开发者们已经释出 Karabiner 的后续版本 [Karabiner Elements](https://github.com/tekezo/Karabiner-Elements)，通过在 `karabiner.json`（相当于之前的 `private.xml`）进行设置，即可修改 Mac 系统的键盘。

## Examples

### 键位交换

Esc, CapsLock, Left Ctrl 三方交换：

``` json
{
    "profiles": [
        {
            "name": "Default profile",
            "selected": true,
            "simple_modifications": {
                "caps_lock": "left_control",
                "left_control": "escape",
                "escape": "caps_lock"
            }
        }
    ]
}
```

More info: [Examples](https://github.com/tekezo/Karabiner-Elements/tree/master/examples)


