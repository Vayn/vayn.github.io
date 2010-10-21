---
layout: post
title: '{Python} Step One'
author: Vayn
date: 2010-10-21
categories:
  - python
---

阅读《简明 Python 教程》最后的一个问题：

> 我会建议你先解决这样一个问题：创建你自己的命令行 地址簿 程序。在这个程序中，你可以添加、修改、删除和搜索你的联系人（朋友、家人和同事等等）以及它们的信息（诸如电子邮件地址和/或电话号码）。这些详细信息应该被保存下来以便以后提取。

我的答案：

{% highlight python %}
#!/usr/bin/python
# Filename: address.py
import cPickle as p
import os

class Person:
    '''Address book'''
    dictfile = 'addbook.data'

    def __init__(self):
        self.name = ''
        self.info = ''
        if os.path.isfile(Person.dictfile):
            if os.path.getsize(Person.dictfile) > 0:
                self.r = file(Person.dictfile)
                self.dict = p.load(self.r)
            else:
                self.dict = {}
        else:
            self.dict = {}

    def __del__(self):
        try:
            self.r.close()
        except:
            pass

    def add(self):
        ''' Add one to address book'''
        self.name = raw_input('Please input name: ')
        if self.dict.has_key(self.name):
            print 'This name is already in address book'
        else:
            if len(self.name) == 0:
                print 'Your input is blank!'
            else:
                self.info = raw_input('Please input contact info: ');
                if len(self.info) == 0:
                    print 'Your input is blank!'
                else:
                    self.dict[self.name] = self.info
                    p.dump(self.dict, file(Person.dictfile, 'w'))
                    print '%s has been saved.' % self.name

    def edit(self):
        '''Edit contact info'''
        self.name = raw_input('Please input name which you want to edit: ')
        if self.name in self.dict.keys():
            self.info = raw_input('Please input new contact info: ')
            self.dict[self.name] = self.info
            print 'Edit successfully!'
            p.dump(self.dict, file(Person.dictfile, 'w'))
        else:
            print 'This name is not in address book'

    def delete(self):
        '''Delete one from address book'''
        self.name = raw_input('Please input name which you want to delete: ')
        if self.name in self.dict.keys():
            del self.dict[self.name]
            print 'Delete successfully!'
            p.dump(self.dict, file(Person.dictfile, 'w'))
        else:
            print 'This name is not in address book'

    def display(self):
        '''Display address book'''
        print 'Name\tInfo'
        for self.name, self.info in self.dict.items():
            print '%s\t%s' % (self.name, self.info)

    def search(self):
        '''Search in address book'''
        self.name = raw_input('Please input name which you want to search: ')
        if self.name in self.dict.keys():
            print '%s\'s info: %s' % (self.name, self.dict[self.name])
        else:
            print 'This name is not in address book'

if __name__ == '__main__':
    print Person.__doc__
    person = Person()

    while True:
        select = raw_input('\
\nWhat do you want to do?\n\n\
    1. Add new contact\n\
    2. Display all contact\n\
    3. Search contact\n\
    4. Delete contact\n\
    5. Edit contact\n\
    6. Quit\n\n\
Please input the number: ')
        if select == '1':
            person.add()
        elif select == '2':
            person.display()
        elif select == '3':
            person.search()
        elif select == '4':
            person.delete()
        elif select == '5':
            person.edit()
        elif select == '6':
            exit()
        else:
            print 'Your input is wrong.\n'
{% endhighlight %}

EOF