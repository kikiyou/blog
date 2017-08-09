package main

import "fmt"

type IPAddr [4]byte

// TODO: Add a "String() string" method to IPAddr.

func (v IPAddr) String() string {
	return fmt.Sprintf("%v.%v.%v.%v", v[0],v[1],v[2],v[3])
}

func main() {
	addrs := map[string]IPAddr{
		"loopback":  {127, 0, 0, 1},
		"googleDNS": {8, 8, 8, 8},
	}
	for k, v := range addrs {
		fmt.Printf("%v: %v\n", k, v)
	}
}
-----------

练习：Stringers
让 IPAddr 类型实现 fmt.Stringer 以便用点分格式输出地址。

例如，IPAddr{1, 2, 3, 4} 应当输出 "1.2.3.4"。