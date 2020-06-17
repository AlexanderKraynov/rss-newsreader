//
//  RssNews.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 17.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import DeepDiff
import Foundation

struct RssNews: DiffAware {
    typealias DiffId = String

    var diffId: String {
        link
    }
    var title: String
    var pubDate: Date
    var photoUrl: String?
    var fullText: String
    var category: String
    var link: DiffId

    init() {
        title = ""
        pubDate = Date()
        photoUrl = nil
        fullText = ""
        category = ""
        link = ""
    }

    static func compareContent(_ a: RssNews, _ b: RssNews) -> Bool {
        a.link == b.link
    }
}
