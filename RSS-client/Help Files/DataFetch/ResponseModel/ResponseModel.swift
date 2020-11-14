//
//  ResponseModel.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import Foundation
import SWXMLHash

struct ResponseNewsModel: XMLIndexerDeserializable {
    var title: String?
    var description: String?
    var date: String?
    
    static func deserialize(_ element: XMLIndexer) throws -> ResponseNewsModel {
        return try ResponseNewsModel(title: element["title"].value(), description: element["description"].value(), date: element["pubDate"].value())
    }
}
