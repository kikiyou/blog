package main

import (
	"fmt"
	"log"
	"net/http"
)

// 1 定义类型
type String string
type Struct struct {
	Greeting string
	Punct    string
	Who      string
}

// 2 实现http.Handler的方法
func (s String) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, string(s))
}
func (s *Struct) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, fmt.Sprintf("%v", s))
}
func main() {
	// 3  设置需要处理的对应的url
	http.Handle("/string", String("I'm a frayed knot."))
	http.Handle("/struct", &Struct{"Hello", ":", "Gophers!"})

	//   这里就是默认的 nil
	e := http.ListenAndServe("localhost:4000", nil)
	if e != nil {
		log.Fatal(e)
	}
}