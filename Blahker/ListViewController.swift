//
//  ListViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/12/4.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListViewController: UITableViewController {
    var rules = [String: [String]]()
    var sortedRules = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        reload()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        self.refreshControl = refreshControl

        tableView.backgroundView?.addSubview(refreshControl)
        tableView.indicatorStyle = .white
    }

    func reload() {
        guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
            return
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) -> Void in
            self.refreshControl?.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            guard let data = data,
                let jsons = JSON(data: data).array else { return }

            self.rules = [:]

            for rule in jsons {
                guard let domains = rule["trigger"]["if-domain"].array,
                    let selector = rule["action"]["selector"].string else { continue }
                for domain in domains {
                    if let domainString = domain.string {
                        var selectors = self.rules[domainString] ?? []
                        selectors.append(selector)
                        self.rules[domainString] = selectors
                    }
                }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        task.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedRules = rules.keys.sorted() { $0 < $1 }
        return rules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rule", for: indexPath)

        let domain = sortedRules[indexPath.row]
        cell.textLabel?.text = domain
        cell.detailTextLabel?.text = "  " + (rules[domain]?.joined(separator: ", ") ?? "")

        return cell
    }
}
