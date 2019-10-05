# Blahker 🈲
![](https://travis-ci.org/ethanhuang13/blahker.svg?branch=master) [![GitHub release](https://img.shields.io/github/release/ethanhuang13/blahker.svg)](https://itunes.apple.com/tw/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?mt=8&at=1l3vpBq&pt=99170802&ct=readme) ![GitHub top language](https://img.shields.io/github/languages/top/ethanhuang13/blahker.svg) [![GitHub](https://img.shields.io/github/license/ethanhuang13/blahker.svg)](https://github.com/ethanhuang13/blahker/blob/master/LICENSE) 

Blahker is a Safari content blocker for interstitial ads in Taiwan's websites. You can download the [iOS app](https://itunes.apple.com/tw/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?mt=8&at=1l3vpBq&pt=99170802&ct=readme) and the [macOS extension](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextz). The blocking rules are listed [here](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextension/blockerList.json).

---

「[Blahker 巴拉剋 - 蓋版廣告消除器](https://github.com/ethanhuang13/blahker)」是一款 Safari 瀏覽器所用的擋廣告延伸插件，同時支援 iOS 與 macOS。

使用者瀏覽網站時遇到蓋版網站，往往很突然，與內文無關，又很難關閉。感覺就像是前往目的地的途中，遇到不相干的人拉住你，跟你 blah blah blah 推銷個不停，又很難中斷人家，非常煩人。於是將 "blah" 與 "blocker" 合併創出 Blahker 這個名稱，中文音譯為「巴拉剋」。

廣告是許多網站賴以為生的收入來源，所以 Blahker 的目的並不是消除所有的廣告，而只針對那些通常與內文無關又煩人的蓋版廣告。對於想要阻擋廣告的 Safari 使用者，我們推薦 [1Blocker](https://1blocker.com)。

目前 Blahker 已經含括了台灣幾個常見網站的蓋版阻擋規則，未來也將以台灣的網站為主，所以大部分的說明都會是中文。如果有興趣了解阻擋規則，可以參見 [blockerList.json](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextension/blockerList.json) 以及 Apple 的[說明文件](https://developer.apple.com/library/content/documentation/Extensions/Conceptual/ContentBlockingRules/CreatingRules/CreatingRules.html#//apple_ref/doc/uid/TP40016265-CH2-SW1)。

Blahker 是開源的，且以後將會採用適當的授權方式開放協作。如果你對於參與這個項目有興趣的話，包括提出需求申請，請參考 [CONTRIBUTING](https://github.com/ethanhuang13/blahker/blob/master/CONTRIBUTING.md) 文件。

目前 [macOS 版](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextz)可以直接下載，[iOS 版](https://itunes.apple.com/tw/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?mt=8&at=1l3vpBq&pt=99170802&ct=readme)透過 Elaborapp Co., Ltd. （精巧應用）免費發布於 App Store，並且加上應用程式內購的捐款功能，以提供主要開發者 [@ethanhuang13](https://twitter.com/ethanhuang13) 的部分開發成本。

## 廣告阻擋原理與隱私問題

有些 iOS 廣告阻擋器是透過架設 VPN 的方式，阻止裝置存取廣告商的任何資源。但這方式最大的問題就是 VPN 完全知曉使用者的一切網路行為，對於隱私有著極大的潛在風險。

所幸在 iOS 9 之後，Apple 提供了 WebKit API 給開發者來製作廣告阻擋器。Safari 會向插件詢問阻擋網頁元素的規則，插件則按照格式回傳一 JSON 檔。在這過程中，插件程式只負責提供規則，而不知道使用者瀏覽了什麼網站，隱私得到完整的保護。在 macOS 中，使用者可以直接安裝 .safariextz 檔案來加入插件至 Safari，並且在延伸功能介面中會看到「Blahker 沒有權限可讀取或傳送任何網頁的內容」。而在 iOS 中則要安裝 app，然後在「設定 > Safari > 內容阻擋器」啟用 app 中所附的插件。

總而言之，Blahker 用以阻擋廣告所使用的方法是絕對不會侵犯隱私的，並且原始碼公開在此 [GitHub 網站](https://github.com/ethanhuang13/blahker)。

---

## iOS 版

### 系統需求
- iOS 9.0 以上

### 安裝方式

- 下載 [Blahker](https://itunes.apple.com/tw/app/blahker-ba-la-ke-gai-ban-guang/id1182699267?mt=8&at=1l3vpBq&pt=99170802&ct=readme)
- 安裝 app 之後，在「設定 > Safari > 內容阻擋器」啟用 app 中所附的插件。

---

## macOS Safari App 版

自從 Safari 13 以後 Apple 要求所有的延伸功能使用新的「Safari App」方式發行。為此 Blahker 也開發了 Safari App，上架至 Mac App Store，並且可以向下相容。

### 系統需求

- macOS 10.12 Sierra 或以上
- Safari 10 或以上

### 安裝方式

- 從 Mac App Store [下載](https://apps.apple.com/us/app/blahker-巴拉剋/id1482371114?l=zh&ls=1&mt=12)
- 安裝 app 之後，只要打開過一次，就可以關閉
- 到「Safari > 偏好設定 > 延伸功能」啟用 app 中所附的插件

---

## macOS 舊版

僅適用於 Safari 9~12。建議使用新的 Safari App 版。

### 系統需求
- macOS 10.10 (OS X Yosemite) 或以上
- Safari 9 或以上

### 安裝方式
- 下載 [Blahker.safariextz](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextz)，點擊並安裝至 Safari 即可

---

## 開源專案

- 如果你具備 Apple 開發者身分，可以將原始碼下載後安裝到自己的裝置上使用
- 不論是 iOS 或 Mac 版，阻擋規則皆是讀取自 GitHub 上的 [blockerList.json](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextension/blockerList.json)，所以可以在不更新 app 的情況下自動更新阻擋規則

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
## 開發者的感想
廣告阻擋器並不是終極解答。一部分人使用阻擋器，使得網站必須投放更多更重的廣告來平衡收益。到頭來，沒有用阻擋器的使用者反而會看到更多廣告，而來不及阻擋的廣告也只會更多。這其實是個經濟學的課題。

目前 Blahker 只想針對使用者體驗最差的蓋版廣告下手。研究的過程中有發現不少網站雖然有廣告，但是沒有那麼令人厭惡，而且載入速度也能滿意。相信一定有更好的方式可以兼顧內容網站的品質與使用者體驗。
