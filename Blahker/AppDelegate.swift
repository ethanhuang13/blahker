//
//  AppDelegate.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import BackgroundTasks
import SafariServices
import UIKit

let contentBlockerExteiosnIdentifier = "com.elaborapp.Blahker.ContentBlocker"
let contentBlockerReloadTaskIdentifier = "com.elaborapp.Blahker.ContentBlockerReload"

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: contentBlockerReloadTaskIdentifier, using: nil) { task in
            guard let refreshTask = task as? BGAppRefreshTask else {
                fatalError("task is not BGAppRefershTask")
            }
            self.handleContentBlockerReload(task: refreshTask)
        }

        return true
    }
    
    private func handleContentBlockerReload(task: BGAppRefreshTask) {
        scheduleContentBlockerReload()
        
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { state, error -> Void in
            switch state?.isEnabled {
            case .some(true):
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { error -> Void in
                    if error == nil {
                        print("background reloadContentBlocker complete")
                        task.setTaskCompleted(success: true)
                    } else {
                        print("background reloadContentBlocker: \(String(describing: error))")
                    }
                })
            default:
                print("background reloadContentBlocker skip. Blocker disabled.")
            }
        })
    }
}

func scheduleContentBlockerReload() {
    let request = BGAppRefreshTaskRequest(identifier: contentBlockerReloadTaskIdentifier)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60 * 60) // Fetch no earlier than 2 hours from now

    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}
