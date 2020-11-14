//
//  NetworkDataFetcher.swift
//  Protocols
//
//  Created by Arman Davidoff on 30.10.2020.
//

import Foundation
import SWXMLHash

class NetworkDataFetcher {
    
    var networkService: Network
    
    required init(networkService: Network) {
        self.networkService = networkService
    }
    
    private func getXMLResponse(with url: String, complition: @escaping (XMLIndexer?,Error?) -> ()) {
        networkService.getRequest(url: url) { (data, error) in
            if let error = error {
                complition(nil,error)
                return
            }
            guard let data = data else { return }
            let xml = SWXMLHash.parse(data)
            complition(xml,nil)
        }
    }
   
    func getNewsListFromURL(url: String,complition: @escaping ([ResponseNewsModel],Error?) -> ()) {
        getXMLResponse(with: url) { (xml, error) in
            if let error = error {
                complition([],error)
                return
            }
            guard let xml = xml else { return }
            var models = [ResponseNewsModel]()
            guard let response = try? xml.byKey("rss").byKey("channel").byKey("item").all else {
                complition([],DataFetchErrors.XMLformat)
                return }
            response.forEach {
                guard let model = try? ResponseNewsModel.deserialize($0) else {
                    complition([],DataFetchErrors.XMLParsing)
                    return
                }
                models.append(model)
            }
            complition(models,nil)
        }
    }
   
}

