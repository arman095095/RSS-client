//
//  ViewController.swift
//  Networking
//
//  Created by Arman Davidoff on 05.04.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import UIKit

class NetworkServiceUS {
    
    var currentURLString: String?
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let ss = URLSession(configuration: config)
        return ss
    }()
    
    func getRequest(URLString:String,complition: @escaping (Data?,Error?) -> ()) {
        currentURLString = URLString
        guard let url = URL(string: URLString) else {
            complition(nil,NetworkErrors.incorrectURL)
            return
        }
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            if self?.currentURLString != nil && self?.currentURLString == URLString {
                if let error = error {
                    complition(nil,error)
                    return
                }
                guard let data = data else {
                    complition(nil,NetworkErrors.dataNil)
                    return
                }
                complition(data,nil)
            }
            else { return }
        }.resume()
    }
    
    
}

