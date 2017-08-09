package main

import (
	"golang.org/x/tour/wc"
	"strings"
)

func WordCount(s string) map[string]int {
	counts := make(map[string]int)
	s_strs := strings.Fields(s)
	for _, s_str := range s_strs {
		counts[s_str] += 1
	}
	return counts
}

func main() {
	wc.Test(WordCount)
}


-------------------
练习：map
实现 WordCount。它应当返回一个含有 s 中每个 “词” 个数的 map。函数 wc.Test 针对这个函数执行一个测试用例，并输出成功还是失败。

你会发现 strings.Fields 很有帮助。