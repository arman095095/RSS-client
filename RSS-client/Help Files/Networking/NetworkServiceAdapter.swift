//
//  NetworkServiceAdapter.swift
//  Protocols
//
//  Created by Arman Davidoff on 30.10.2020.
//

import Foundation

protocol Network {
    func getRequest(url:String, complition: @escaping (Data?,Error?) -> () )
}

class NetworkServiceUSAdapter: Network {
    
    private var networkService: NetworkServiceUS
    
    init(networkService: NetworkServiceUS) {
        self.networkService = networkService
    }
    
    func getRequest(url: String, complition: @escaping (Data?, Error?) -> ()) {
        networkService.getRequest(URLString: url, complition: complition)
    }
}

