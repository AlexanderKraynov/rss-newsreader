//
//  NewsServiceImpl.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 16.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

class NewsServiceImpl: NSObject, NewsService {
    private let newsUrl = "https://www.vesti.ru/vesti.rss"
    private var currentElement = ""
    private var currentModel = RssNews()
    private var currentEnclosure = ""
    private var rssFeed = [RssNews]()
    private var completion: NewsCompletion?

    func getNews(completion: @escaping NewsCompletion) {
        rssFeed = [RssNews]()
        guard let url = URL(string: newsUrl) else {
            return
        }
        self.completion = completion
        var request = URLRequest(url: url)
        request.setValue("no-cahce", forHTTPHeaderField: "Cache-Control")
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        .resume()
    }
}

// MARK: - XML Parser Delegate

extension NewsServiceImpl: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        switch elementName {
        case "item":
            currentModel = RssNews()
        case "enclosure":
            if let urlString = attributeDict["url"] {
                currentEnclosure = urlString
            }
        default:
            return
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentModel.title += string
        case "pubDate":
            if let date = RssDateFormatter.rfc822DateFormatter().date(from: string) {
                currentModel.pubDate = date
            } else if let date = RssDateFormatter.rfc822DateFormatter2().date(from: string) {
                currentModel.pubDate = date
            }
        case "yandex:full-text":
            currentModel.fullText += string
        case "category":
            currentModel.category += string
        case "link":
            currentModel.link += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            currentModel.photoUrl = currentEnclosure
            rssFeed.append(currentModel)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(rssFeed)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
