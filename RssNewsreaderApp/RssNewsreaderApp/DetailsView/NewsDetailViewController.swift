//
//  NewsDetailViewController.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 16.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    var item: RssNews?
    @IBOutlet private var newsImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var fullTextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else {
            return
        }
        guard let imageURL = URL(string: item.photoUrl ?? "") else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.newsImage.image = image
            }
        }
        .resume()
        titleLabel.text = item.title
        fullTextLabel.text = item.fullText
    }
}
