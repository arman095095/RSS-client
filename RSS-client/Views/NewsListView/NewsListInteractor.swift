//
//  NewsListInteractor.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsListBusinessLogic {
    func makeRequest(request: NewsList.Model.Request.RequestType)
}

class NewsListInteractor: NewsListBusinessLogic {
    
    var presenter: NewsListPresentationLogic?
    var dataFetcher = Builder.dataFetcher()
    
    func makeRequest(request: NewsList.Model.Request.RequestType) {
        switch request {
        case .getNewsList(let source):
            dataFetcher.getNewsListFromURL(url: source.url) { (models, error) in
                if let error = error {
                    self.presenter?.presentData(response: .presentError(error: error.localizedDescription))
                    return
                }
                guard !models.isEmpty else { return }
                self.presenter?.presentData(response: .presentNewsList(responseModels: models))
            }
        case .getNewsListWithNewSource(let source):
            dataFetcher.getNewsListFromURL(url: source.url) { (models, error) in
                if let error = error {
                    self.presenter?.presentData(response: .presentError(error: error.localizedDescription))
                    return
                }
                guard !models.isEmpty else { return }
                self.presenter?.presentData(response: .presentNewsListWithNewSource(responseModels: models,source))
            }
        }
    }
    
}
