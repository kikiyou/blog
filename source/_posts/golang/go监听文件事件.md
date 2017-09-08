go也可以监听文件事件,用到一个开源库[fsnotify](https://github.com/howeyc/fsnotify)

直接上代码

```
// TestFsnotify project main.go
package main

import (
	"github.com/howeyc/fsnotify"
	"log"
)

func main() {
	// 新建文件事件监听
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal(err)
	}

	done := make(chan bool)
	// Process events
	go func() {
		for {
			select {
			case ev := <-watcher.Event:

				if ev.IsCreate() {
					log.Println("文件事件 新建:", ev)
				} else if ev.IsDelete() {
					log.Println("文件事件 删除:", ev)
				} else if ev.IsModify() {
					log.Println("文件事件 修改:", ev)
				} else if ev.IsRename() {
					log.Println("文件事件 重命名:", ev)
				} else if ev.IsAttrib() {
					log.Println("文件事件 修改元数据:", ev)
				}
			case err := <-watcher.Error:
				log.Println("error:", err)
			}
		}
	}()

	// 开始监听文件事件
	err = watcher.Watch("H:\\temp")
	if err != nil {
		log.Fatal(err)
	}

	<-done

	/* ... do stuff ... */
	watcher.Close()
}
```