//
//  SetupViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/21.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit

class SetupViewController: UIViewController {
    /// Use this flag to show alert after automatically reloading
    private var isLoadedFailedBefore = false

    @IBAction func reloadButton(_ sender: Any) {
    }

    @IBAction func donateButton(_ sender: Any) {
    }

    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tutorialLabel: UILabel!
}
