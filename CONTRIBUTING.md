# Contributing

Blahker 是開源的，但主要功能並不需要更新程式，只需要增加阻擋廣告的規則至 [blockerList.json](https://github.com/ethanhuang13/blahker/blob/master/Blahker.safariextension/blockerList.json) 即可。你可以使用 pull request 來新增阻擋規則。若是不會編寫該 JSON，也可以新增 issue 並說明想要阻擋的網站

---
# iOS 版開發

## Basic Info

This app is written in Swift 3 with Xcode 8. Targeting iOS 9 and above.

## Source

* Source code: `git clone https://github.com/ethanhuang13/blahker`

## Setup

It's suggested to use rvm and bundle to manage fastlane.

* Install rvm: `\curl -sSL https://get.rvm.io | bash -s stable`
* Install ruby-2.3.1 and bundler: `rvm install ruby-2.3.1`
* `bundle install` to install Gems
* Use `pod install` and `fastlane` tools

---
2016 Elaborapp Co., Ltd. All Right Reserved.
