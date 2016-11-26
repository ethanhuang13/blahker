# [Blahker[(https://github.com/ethanhuang13/blahker)
「巴拉剋 - 蓋版廣告消除器」是一款 Safari 瀏覽器所用的擋廣告延伸插件，同時支援 macOS 與 iOS。

使用者瀏覽網站時遇到蓋版網站，往往很突然，與內文無關，又很難關閉。感覺就像是前往目的地的途中，遇到不相干的人拉住你，跟你 blah blah blah 推銷個不停，又很難中斷人家，非常煩人。於是將 "blah" 與 "blocker" 合併創出 Blahker 這個名稱，中文音譯為「巴拉剋」。

廣告是許多網站賴以為生的收入來源，所以 Blahker 的目的並不是消除所有的廣告，而只針對那些通常與內文無關又煩人的蓋版廣告。對於想要阻擋廣告的 Safari 使用者，我們推薦 [1Blocker](https://1blocker.com)。

目前 Blahker 已經含括了台灣幾個常見網站的蓋版阻擋規則，未來也將以台灣的網站為主，所以大部分的說明都會是中文。如果有興趣了解阻擋規則，可以參見 [blockerList.json](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextension/blockerList.json) 以及 Apple 的[說明文件](https://developer.apple.com/library/content/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1)。

## 廣告阻擋原理與隱私問題

Apple 提供了 WebKit API 給開發者來製作廣告阻擋器。Safari 會向插件詢問阻擋網頁元素的規則，插件則按照格式回傳一 JSON 檔。在這過程中，插件程式不會得知使用者瀏覽了什麼網站，使用者的隱私完全安全。在 macOS 中，可以直接安裝 .safariextz 檔案來加入插件至 Safari，而在 iOS 中則要安裝 app，然後在「設定 > Safari > 內容阻擋器」啟用 app 中所附的插件。

有些 iOS 廣告阻擋器是透過架設 VPN 的方式，阻止裝置存取廣告商的任何資源。但這方式最大的問題就是 VPN 完全知曉使用者的一切網路行為，對於隱私有著極大的潛在風險。Blahker 使用的 API 是完全安全的，且原始碼公開在此 [GitHub 網站](https://github.com/ethanhuang13/blahker)。

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

- [Blahker](https://github.com/ethanhuang13/blahker) 開放原始碼程式
- Apple - [Safari Extensions Developer Portal](https://developer.apple.com/safari/extensions/)
- Apple - [Safari Extensions Development Guide](https://developer.apple.com/library/content/documentation/Tools/Conceptual/SafariExtensionGuide/Introduction/Introduction.html)
- Apple - [Safari App Extensions Programming Guide](https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternetWeb/Conceptual/SafariAppExtension_PG/)
- Apple - [Content Blocking Rules](https://developer.apple.com/library/content/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1)
- Apple - [Safari Extensions Gallery](https://safari-extensions.apple.com)
- [BlockParty](https://github.com/krishkumar/BlockParty) - 一個開源且原理與 Blahker 類似的廣告阻擋器

---

2016 Elaborapp Co., Ltd. All Right Reserved.
