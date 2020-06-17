//
//  NewsTableCell.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 16.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import UIKit

class NewsTableCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    func setup(with item: RssNews) {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: item.pubDate)
        titleLabel.text = item.title
        dateLabel.text = formattedDate
    }
}
