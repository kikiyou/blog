1. 打开浏览器

import webbrowser
webbrowser.open("http://www.baidu.com")

2. 乌龟画圆

import turtle

def draw_square():
    window = turtle.Screen()
    window.bgcolor("red")


    brad = turtle.Turtle()
    brad.shape("turtle")
    brad.color("yellow")
    brad.speed(2)

    brad.forward(100)
    brad.right(90)
    brad.forward(100)
    brad.right(90)
    brad.forward(100)
    brad.right(90)
    brad.forward(100)
    brad.right(90)

    window.exitonclick()


draw_square()


pypi 下载排行榜：
http://pypi-ranking.info/alltime


3. csv 格式

csv = [['A1','A2','A3'],
      ['B1','B2','B3']]


csv = [{'name1':A1,'name2':'A2','name3':'A3'},
      {'name1':'B1','name2':'B2','name3':'A3'}]


enrollments = []
for row in reader:
    enrollments.append(row)

-----上面代码可以用下面一句话代替-------
enrollments = list(reader)
