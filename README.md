# 前言
我工作用的Mac Pro是256GB ssd硬盘。开发iOS久了，经常提示磁盘空间不够，其中最大原因是来自Xcode®

可以打开 ~/Library/Developer/Xcode/DerivedData 看看，这里存放了Xcode编译构建过的所有项目工程数据。

这如 watchdog 磁盘清理软件描述提及的那样 automatically cleans up stale cache files。将陈腐失效的缓存数据及时清理掉，你的ssd硬盘可用空间就多起来了。


# 目录

```
~/Library/Developer/Xcode/DerivedData
~/Library/Caches/AndroidStudioPreview2.2
```
