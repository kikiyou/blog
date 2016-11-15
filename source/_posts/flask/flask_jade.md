---
title: falsk + jinja + jade 
tags:
- flask
---
# flask + jinja + jade 使用
<!-- more -->

好处：后缀是html或其他时 使用jinja模版

后坠是jade  使用的是jade模版

----------run.py

from flask import Flask,render_template
app = Flask(__name__)

app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
app.debug = True
@app.route('/')
@app.route('/<name>')
def hello(name=None):
    return render_template('hello.jade', name=name)

if __name__ == "__main__":
    app.run()

----------hello.jade
doctype 5
html
	head: title Hello from flask
	body
		if name
			h1(class="red") Hello 
				= name
			span.description #{name|capitalize} is a great name!
		else
			h1 Hello World!