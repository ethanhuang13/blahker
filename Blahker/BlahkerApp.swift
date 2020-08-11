//
//  BlahkerApp.swift
//  Blahker
//
//  Created by Ethanhuang on 2020/8/11.
//  Copyright © 2020 Elaborapp Co., Ltd. All rights reserved.
//

import SwiftUI

@main
struct BlahkerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SetupView()
        }
    }
}
