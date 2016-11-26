# Blahker
「巴拉剋 - 蓋版廣告消除器」是一款 Safari 瀏覽器所用的擋廣告延伸插件，同時支援 macOS 與 iOS。

## 隱私與廣告消除器原理

Apple 提供了 WebKit API 給開發者來製作廣告阻擋器。Safari 會向插件詢問阻擋網頁元素的規則，插件則按照格式回傳一 JSON 檔。在這過程中，插件程式不會得知使用者瀏覽了什麼網站，對於使用者來說是完全安全的。在 macOS 中，可以直接安裝 .safariextz 檔案來加入插件至 Safari，而在 iOS 中則要安裝 app，然後在「設定 > Safari > 內容阻擋器」啟用 app 中所附的插件。

## Mac 版

開發中，但已可下載使用。預計之後上架至 [Safari Extensions Gallery](https://safari-extensions.apple.com)

### 系統需求
- macOS 10.10 (OS X Yosemite) 以上
- Safari 9.0 以上

### 安裝方式
- 下載 [Blahker.safariextz](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextz)
- 點擊並安裝至 Safari 即可

---
# iOS 版

開發中，預計之後上架 App Store

### 系統需求
- iOS 9.0 以上

---
## 相關資訊

- Apple - [Safari Extensions Developer Portal](https://developer.apple.com/safari/extensions/)
- Apple - [Safari Extensions Development Guide](https://developer.apple.com/library/content/documentation/Tools/Conceptual/SafariExtensionGuide/Introduction/Introduction.html)
- Apple - [Safari App Extensions Programming Guide](https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternetWeb/Conceptual/SafariAppExtension_PG/)
- Apple - [Content Blocking Rules](https://developer.apple.com/library/content/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1)
- Apple - [Safari Extensions Gallery](https://safari-extensions.apple.com)
- [BlockParty](https://github.com/krishkumar/BlockParty)

---

2016 Elaborapp Co., Ltd. All Right Reserved.
