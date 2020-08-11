//
//  ListViewController.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/12/4.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

class BlockerListViewController: UITableViewController {
    var rules = [String: [String]]()
    var sortedRules = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "更新擋廣告網站清單", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        tableView.refreshControl = refreshControl
        tableView.indicatorStyle = .white
    }

    @objc func reloadData() {
        guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
            return
        }

//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, connectionError) in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            guard let data = data,
                let rules = try? JSONDecoder().decode([Rule].self, from: data) else {
                    return
            }

            self.rules = [:]

            for rule in rules {
                if let domains = rule.trigger.ifDomain,
                    let selector = rule.action.selector {
                    for domain in domains {
                        var selectors = self.rules[domain] ?? []
                        selectors.append(selector)
                        self.rules[domain] = selectors
                    }
                } else if let selector = rule.action.selector {
                    var selectors = self.rules["Any"] ?? []
                    selectors.append(selector)
                    self.rules["Any"] = selectors
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
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }
}
