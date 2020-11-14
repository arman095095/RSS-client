//
//  NewsListModels.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsListViewModel {
    
    private var models: [NewsListModel]
    private var sources: [NewsFeedSource] {
        return UserSettings.shared.getNewsFeedSources()
    }
    var currentSource: NewsFeedSource?
    
    init(models: [NewsListModel]) {
        self.models = models
    }
}

// MARK: NewsFeedSources Functions
extension NewsListViewModel {
    
    func addNewSource(source: NewsFeedSource) {
        self.saveSource(source)
        self.currentSource = source
    }
    
    private func saveSource(_ source: NewsFeedSource) {
        UserSettings.shared.createNewsFeedSource(source: source)
    }
}

// MARK: NewsListModels Functions
extension NewsListViewModel {
    
    func numberOfRows() -> Int {
        return models.count
    }
    
    func updateModels(models: [NewsListModel]) {
        self.models = models
    }
    
    func checkModel(at indexPath: IndexPath) -> NewsDetailViewModelType {
        if models[indexPath.row].viewed { return models[indexPath.row] }
        UserSettings.shared.saveNews(model: models[indexPath.row])
        models[indexPath.row].viewed = true
        return models[indexPath.row]
    }
    
    func model(at indexPath: IndexPath) -> NewsListCellModelType {
        return models[indexPath.row]
    }
}

// MARK: NewsListModel
extension NewsListViewModel {
    struct NewsListModel: NewsListCellModelType, NewsDetailViewModelType {
        var title: String
        var date: String
        var description: String
        var viewed: Bool = false
    }
}

// MARK: NewsFeedSource
extension NewsListViewModel {
    @objc(_TtCC10RSS_client17NewsListViewModel14NewsFeedSource)class NewsFeedSource: NSObject, NSCoding {
        
        var url: String
        var userNamed: String
        
        init(url: String, userNamed: String) {
            self.url = url
            self.userNamed = userNamed
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(url, forKey: "url")
            coder.encode(userNamed, forKey: "userNamed")
        }
        
        required init?(coder: NSCoder) {
            url = coder.decodeObject(forKey: "url") as? String ?? ""
            userNamed = coder.decodeObject(forKey: "userNamed") as? String ?? ""
        }
    }
}
