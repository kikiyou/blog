---
title: python 单元测试
date: 2016-08-18 16:10:02
tags: python
---
python 单元测试
<!-- more -->
+ 测试
    ```
    test_requests.py
        import unittest
    ```
    - 测试函数
        ljq.py
        ```
        def sum(x,y):
            return x+y

        def sub(x,y):
            return x-y
        ```

        test_ljq.py
        ```
        #!/usr/bin/env python
        import unittest
        import ljq

        class mytest(unittest.TestCase):
            def setUp(self):
                pass
            def tearDown(self):
                pass
            
            def  testsum(self):
                self.assertEqual(ljq.sum(1,2),3)
            def  testsub(self):
                self.assertEqual(ljq.sub(2,1),1)


        if __name__ == '__main__':
            unittest.main()
        ```
    - 测试类
    ``` ljq.py
    class myclass():
	def __init__(self):
		pass
	def sum(self,x,y):
		return x+y

	def sub(self,x,y):
		return x-y


    ```
    #!/usr/bin/env python
    import unittest
    import ljq

    class mytest(unittest.TestCase):
        def setUp(self):
            self.tclass = ljq.myclass()
        def tearDown(self):
            pass
        
        def  testsum(self):
            self.assertEqual(ljq.sum(1,2),3)
        def  testsub(self):
            self.assertEqual(ljq.sub(2,1),1)


    if __name__ == '__main__':
        unittest.main() 
    ``` 