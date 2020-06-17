//
//  RssDateFormatter.swift
//  RssNewsreaderApp
//
//  Created by Александр Крайнов on 17.06.2020.
//  Copyright © 2020 Александр Крайнов. All rights reserved.
//

import Foundation

enum RssDateFormatter {
    static func rfc822DateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return dateFormatter
    }

    static func rfc822DateFormatter2() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return dateFormatter
    }
}
