//
//  NetworkErrors.swift
//  RSS-client
//
//  Created by Arman Davidoff on 12.11.2020.
//

import Foundation

enum NetworkErrors: LocalizedError {
    case incorrectURL
    case dataNil
    
    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "URL адрес введен некорректно"
        case .dataNil:
            return "Ошибка получения данных"
        }
    }
}
