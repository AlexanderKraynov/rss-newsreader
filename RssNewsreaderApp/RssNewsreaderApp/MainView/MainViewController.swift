//
//  ViewController.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 16.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import DeepDiff
import UIKit

class MainViewController: UIViewController {
    private var newsFeed = [RssNews]()
    private var filteredNewsFeed = [RssNews]()
    private var categories = ["Все"]
    private var service: NewsService = NewsServiceImpl()
    private var currenCategory = "Все"
    @IBOutlet private var newsTable: UITableView!
    @IBOutlet private var categoryPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        service = NewsServiceImpl()
        setupTableView()
        setupCategoryPicker()
        getEvents(self)
    }

    private func setupTableView() {
        newsTable.dataSource = self
        newsTable.delegate = self
        newsTable.rowHeight = 100
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getEvents), for: .valueChanged)
        newsTable.refreshControl = refreshControl
    }

    private func setupCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }

    private func getDiff(old: [RssNews], new: [RssNews]) -> (insertions: [IndexPath], deletions: [IndexPath]) {
        let differences = diff(old: old, new: new)
        var deletions = [IndexPath]()
        var insertions = [IndexPath]()
        for difference in differences {
            if let deletion = difference.delete?.index {
                deletions.append(IndexPath(row: deletion, section: 0))
            }
            if let insertion = difference.insert?.index {
                insertions.append(IndexPath(row: insertion, section: 0))
            }
        }
       return (insertions, deletions)
    }

    func filterForCurrentCategory() {
        let old = filteredNewsFeed
        if currenCategory == "Все" {
            filteredNewsFeed = newsFeed
        } else {
            filteredNewsFeed = newsFeed.filter {
                $0.category == currenCategory
            }
        }
        let diff = getDiff(old: old, new: filteredNewsFeed)
        DispatchQueue.main.async {
            self.newsTable.beginUpdates()
            if !diff.insertions.isEmpty {
                self.newsTable.insertRows(at: diff.insertions, with: .automatic)
            }
            if !diff.deletions.isEmpty {
                self.newsTable.deleteRows(at: diff.deletions, with: .fade)
            }
            self.newsTable.endUpdates()
        }
    }

    @objc func getEvents(_ sender: Any) {
        service.getNews {
            self.newsFeed = $0
            self.filterForCurrentCategory()
            for item in self.newsFeed {
                if !self.categories.contains(item.category) {
                    self.categories.append(item.category)
                }
            }
            DispatchQueue.main.async {
                self.categoryPicker.reloadAllComponents()
                self.newsTable.reloadData()
                let refreshControl = sender as? UIRefreshControl
                refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - UI Table View Data Source

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredNewsFeed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as? NewsTableCell else {
            return UITableViewCell()
        }
        cell.setup(with: filteredNewsFeed[indexPath.row])
        return cell
    }
}

// MARK: - UI Table View Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "NewsDetailViewController", bundle: nil)
            .instantiateViewController(identifier: "NewsDetailViewController") as? NewsDetailViewController else {
            return
        }
        viewController.item = filteredNewsFeed[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UI Picker View Data Source

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
}

// MARK: - UI Picker View Delegate

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currenCategory = categories[row]
        filterForCurrentCategory()
    }
}
