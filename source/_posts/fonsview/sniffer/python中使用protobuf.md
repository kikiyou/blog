# python中使用protobuf

## 什么是protobuf
protobuf是由google开发并开源的一种轻便高效的结构化数据存储格，与其类似的有json xml yml等。

## python中使用protobuf
+ 安装protobuf 编译器
    `sudo dnf install protobuf protobuf-compiler.x86_64`
    `pip install protobuf`

+ 书写protobuf格式定义文件
`vi addressbook.proto`

``` python
package tutorial;  
  
message Person {  
  required string name = 1;  
  required int32 id = 2;  
  optional string email = 3;  
  
  enum PhoneType {  
    MOBILE = 0;  
    HOME = 1;  
    WORK = 2;  
  }  
  
  message PhoneNumber {  
    required string number = 1;  
    optional PhoneType type = 2 [default = HOME];  
  }  
  
  repeated PhoneNumber phone = 4;  
}  
  
message AddressBook {  
  repeated Person person = 1;  
}  
```
+ 生成对应的python文件
protoc -I=. --python_out=. addressbook.proto

执行完之后，你会看到生成的addressbook_pb2.py 文件
+ 使用addressbook_pb2.py 生成protoc的二进制文件

``` python
# -*- coding: utf-8 -*-
#! /usr/bin/python

import addressbook_pb2
import os,sys

# This function fills in a Person message based on user input.
def PromptForAddress(person):
    person.id = 1234
    person.name = "monkey"
    person.email = "123@com"
    phone_number = person.phone.add()
    phone_number.number = '110110110'

    phone_number2 = person.phone.add()
    phone_number2.number = '120120120'
    # phone_number.type = addressbook_pb2.Person.HOME

def ListPeople(address_book):
    for person in address_book.person:
        print "Person ID:", person.id
        print "  Name:", person.name
        if person.HasField('email'):
            print "  E-mail address:", person.email

    for phone_number in person.phone:
      if phone_number.type == addressbook_pb2.Person.MOBILE:
        print "  Mobile phone #: ",
      elif phone_number.type == addressbook_pb2.Person.HOME:
        print "  Home phone #: ",
      elif phone_number.type == addressbook_pb2.Person.WORK:
        print "  Work phone #: ",
      print phone_number.number

if len(sys.argv) != 2:
    print "Usage:", sys.argv[0], "ADDRESS_BOOK_FILE"
    sys.exit(-1)

address_book = addressbook_pb2.AddressBook()

# Read the existing address book.
try:
    if os.path.isfile(sys.argv[1]):
        print "读取到的数据："
        f = open(sys.argv[1], "rb")
        address_book.ParseFromString(f.read())
        ListPeople(address_book)
        f.close()
    else:
        # Add an address.
        PromptForAddress(address_book.person.add())
        f = open(sys.argv[1], "wb")
        f.write(address_book.SerializeToString())
        f.close() 
        print "写入数据完成"
except IOError:
    print sys.argv[1] + ": Could not open file.  Creating a new one."
```
+ 上面python使用方法

第一次执行是生成：
`python AddressBook.py ADDRESS_BOOK_FILE`

第二次执行可以看到生成结果：
`python AddressBook.py ADDRESS_BOOK_FILE`

+ 使用protoc 工具 裸看 生成玩儿二进制文件ADDRESS_BOOK_FILE
$ protoc --decode_raw < ADDRESS_BOOK_FILE 
``` shell
1 {
  1: "monkey"
  2: 1234
  3: "123@com"
  4 {
    1 {
      6: 0x3031313031313031
    }
  }
  4 {
    1 {
      6: 0x3032313032313032
    }
  }
}
```