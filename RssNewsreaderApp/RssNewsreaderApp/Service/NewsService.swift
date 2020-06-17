//
//  NewsService.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 16.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

protocol NewsService {
    typealias NewsCompletion = (([RssNews]) -> Void)
    func getNews(completion: @escaping NewsCompletion)
}
