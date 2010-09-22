---
layout: post
title: '{PHP}  Create a class instance member dynamically'
author: Vayn
date: 2010-09-14T03:43:06+0000
categories:
  -
  - php
  - tutorial

---

在一份[Smarty 学习教程](http://www.ibm.com/developerworks/cn/opensource/os-php-smarty/)中发现的动态创建类实例成员的方法：

{% highlight php %}
<?php

//
// Example is a simple class that stores an arbitrary
// number of named properties.
//

class Example {
    private $catalog = array();

    public function SetProperties( $arrayVariables ) {
        foreach ( $arrayVariables as $name => $value ) {
            $this->SetProperty( $name, $value );
        }
    }

    public function SetProperty( $name, $value ) {
        $this->$name = $value;
        $this->catalog[] = $name;
    }

    public function GetProperties( ) {
        $result = array();
        foreach ( $catalog as $name ) {
            $result[$name] = $this->GetProperty( $name );
        }

        return( $result );
    }

    public function GetProperty( $name ) {
        return ( $this->$name );
    }
}
?>
{% endhighlight %}

<blockquote>该类最令人感兴趣的部分是第 18 行 $this->$name = $value;。这行代码将动态创建类实例成员。例如，如果调用 $example->SetProperty( 'name', 'Groucho' )，则可以用（传统的）$example->name 检索名称。</blockquote>
相关资料：[Can you create class properties dynamically in PHP ?](http://stackoverflow.com/questions/829823/can-you-create-class-properties-dynamically-in-php "Stack Overflow")

