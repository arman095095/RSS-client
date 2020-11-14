//
//  DataFetchErros.swift
//  RSS-client
//
//  Created by Arman Davidoff on 12.11.2020.
//

import Foundation

enum DataFetchErrors: LocalizedError {
    case XMLformat
    case XMLParsing
    
    var errorDescription: String? {
        switch self {
        case .XMLformat:
            return "Некорректный формат XML"
        case .XMLParsing:
            return "Ошибка построения модели"
        }
    }
}
