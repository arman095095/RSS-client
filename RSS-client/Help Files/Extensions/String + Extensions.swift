//
//  String + Extensions.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import UIKit

extension String {
    //self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}
